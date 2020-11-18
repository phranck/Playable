//
//  DeviceBrowser.swift
//  Playable
//
//  Created by Frank Gregor on 05.03.21.
//  Copyright © 2021 Woodbytes. All rights reserved.
//

import Foundation

class DeviceBrowser: NSObject {
    fileprivate struct DeviceType {
        static let LinkPlay = "_linkplay._tcp."
    }

    fileprivate let browser = NetServiceBrowser()
    fileprivate var services: Set<NetService> = Set<NetService>()
    
    func start() {
        browser.delegate = self
        browser.searchForServices(ofType: DeviceType.LinkPlay, inDomain: "local.")
        browser.schedule(in: .main, forMode: .common)
    }
    
    func stop() {
        browser.stop()
        browser.remove(from: .main, forMode: .common)
    }
}

// MARK: - NetServiceBrowserDelegate

extension DeviceBrowser: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        log.debug("didFind service: \(service)")
        services.insert(service)

        service.delegate = self
        service.startMonitoring()
        service.schedule(in: .main, forMode: .common)
        service.resolve(withTimeout: 5)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        log.debug("didRemove service: \(service)")
        services.remove(service)
    }

}

// MARK: - NetServiceDelegate

extension DeviceBrowser: NetServiceDelegate {
    
    func netServiceDidResolveAddress(_ service: NetService) {
        if let addresses = service.addresses,
           let ipv4 = resolveIPv4(addresses: addresses) {
            log.debug("Service IPAddress: \(service.name) - \(ipv4)")
        }
    }
    
    func netService(_ service: NetService, didUpdateTXTRecord data: Data) {
        let dict = NetService.dictionary(fromTXTRecord: data)
        log.debug("TXT record: \(dict)")
    }
    
    func resolveIPv4(addresses: [Data]) -> String? {
        var result: String?
        
        for addr in addresses {
            let data = addr as NSData
            var storage = sockaddr_storage()
            data.getBytes(&storage, length: MemoryLayout<sockaddr_storage>.size)
            let family = Int32(storage.ss_family)
            
            if family == AF_INET {
                let addr4 = withUnsafePointer(to: &storage) {
                    $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                        $0.pointee
                    }
                }
                
                if let ip = String(cString: inet_ntoa(addr4.sin_addr), encoding: .ascii) {
                    result = ip
                    break
                }
            }
        }
        
        return result
    }

}
