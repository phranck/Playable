//
//  Dictionary+URLParameters.swift
//  StatusBoard
//
//  Created by Frank Gregor on 20.11.20.
//

import Foundation

extension Dictionary where Key: Comparable {
    
    func sortedByKeys(ascending: Bool = false) -> Dictionary {
        var sortedDictionary = Dictionary()
        
        let sortedKeys = ascending ? self.sorted(by: { $0.key < $1.key }).map(\.key) : self.sorted(by: { $0.key > $1.key }).map(\.key)
        for key in sortedKeys {
            sortedDictionary[key] = self[key]
        }
        
        return sortedDictionary
    }
    
}

extension Dictionary {
    
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}
