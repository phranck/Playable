//
//  ServiceApiConfiguration.swift
//  Playable
//
//  Created by Frank Gregor on 24.11.20.
//

import Foundation

protocol ApiClientConfiguration {
    var apiEndPoint: String                     { get }
    var apiResponseFormat: Api.Response.Format  { get }
}
