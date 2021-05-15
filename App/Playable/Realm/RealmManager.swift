//
//  ServiceSetupRadio.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import Foundation
import RealmSwift
import RadioBrowser

class RealmManager {
    static let sharedInstance: RealmManager = RealmManager()
    
    private init() {}
    
    private let realm = try! Realm()
    var isSearching: Bool = false
    var searchText: String = ""
    
    // MARK: - Public API
    
    func start() {
        migrateIfNeeded()
        log.info("\(RealmManager.self) started - RadioStations: \(radioStations.count)")
        log.debug("Realm Database: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
    }
    
    // MARK: - Private API
    
    private func migrateIfNeeded() {
        
    }
    
    func addOrUpdate<Model:Object>(_ models: [Model]) {
        DispatchQueue.main.async {
            do {
                self.realm.beginWrite()
                self.realm.add(models, update: .modified)
                try self.realm.commitWrite()
                
            } catch let error {
                log.error(error)
            }
        }
    }
}

// MARK: - RadioBrowser Extension

extension RealmManager {
    
    var radioStations: [RadioStation] {
        let sortedArticles: Results = realm.objects(RadioStation.self).sorted(byKeyPath: "name", ascending: true)
        return Array(sortedArticles)
    }

}
