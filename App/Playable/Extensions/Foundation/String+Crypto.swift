//
//  String+Crypto.swift
//  StatusBoard
//
//  Created by Frank Gregor on 20.11.20.
//

import Foundation
import CryptoKit

extension String {
    
    func md5() throws -> String {
        guard let data = self.data(using: .utf8) else {
            throw StringCryptoError.stringToDataConversion("Error while converting string to Data object.")
        }
        
        return Insecure.MD5
            .hash(data: data)
            .prefix(Insecure.MD5.byteCount)
            .map {
                String(format: "%02hhx", $0)
            }
            .joined()
    }
    
}

enum StringCryptoError: Error {
    case stringToDataConversion(String)
}
