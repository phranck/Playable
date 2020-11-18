//
//  ApiClientTypes.swift
//  Playable
//
//  Created by Frank Gregor on 21.11.20.
//

import Foundation

typealias ApiRequestParameters = [String: String]
typealias ApiFailure           = (Api.Exception) -> Void

struct Api {
    struct Request {
        enum Parameter: String {
            case apiKey        = "api_key"
            case apiSignature  = "api_sig"
            case bundleId      = "bundle_id"
            case bundleVersion = "bundle_version"
            case format        = "format"
            case method        = "method"
        }
    }
    
    struct Response {
        enum Parameter: String {
            case stat
            case success
            case errno
            case exception
            case message
            case data
        }
        
        enum Format: String {
            case json
            case xml
        }
        
        enum Status: String {
            case ok
            case fail
        }
    }
    
    enum Exception: Error {
        case undefined(String)
        case invalidParameters(String)
        case malformedUrlString(String)
        case jsonSerialization(String)
        case responseException(String)
    }
    
}
