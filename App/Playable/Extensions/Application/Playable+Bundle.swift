//
//  Bundle+Extensions.swift
//  StatusBoard
//
//  Created by Frank Gregor on 20.11.20.
//

import UIKit

fileprivate let NA = "n/a"

extension Playable {
    public static let bundleId: String = Bundle.id(forBundle: Bundle.main)
    public static let version: String = "\(Bundle.version(forBundle: Bundle.main))"
    public static let buildNumber: String = "\(Bundle.buildNumber(forBundle: Bundle.main))"
}

extension Bundle {
    // MARK: - Private Helper
    
    fileprivate static func id(forBundle bundle: Bundle) -> String {
        if let result = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String {
            return result
        }
        return NA
    }
    
    fileprivate static func version(forBundle bundle: Bundle) -> String {
        if let result = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return result
        }
        return NA
    }
    
    fileprivate static func buildNumber(forBundle bundle: Bundle) -> String {
        if let result = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return result
        }
        return NA
    }
}
