//
//  ApiClient.swift
//  Playable
//
//  Created by Frank Gregor on 20.11.20.
//

import UIKit

// MARK: - API Client

class ApiClient: ObservableObject {
    let config: ApiClientConfiguration
    
    init(with configuration: ApiClientConfiguration) {
        config = configuration
    }
    
    // MARK: - Public API
    
    private func GET<Model:Decodable>(model: Model.Type, request: URLRequest, completion: @escaping (Model?) -> Void) {
        log.debug("request: \(request)")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                log.error("error requesting data of type: \(model)")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(model, from: data)
                completion(result)
            }
            catch let error {
                log.error(error)
                completion(nil)
            }
        }
        dataTask.resume()
        session.finishTasksAndInvalidate()
    }

    // MARK: - Private Helper
    
    /// Returns an URLRequest object for the given url string with give request parameters.
    ///
    /// - Parameters:
    ///   - urlString: A string for an URL
    ///   - urlParameters: A dictionary with request parameters
    /// - Throws: Any underlying exceptions is passed through, throws `ApiError` exceptions
    /// - Returns: An instance of URLRequest
    private func request(for urlString: String, with urlParameters: ApiRequestParameters) throws -> URLRequest {
        guard var requestUrl = URL(string: urlString) else {
            throw Api.Exception.malformedUrlString("The given string must be a valid URL: '\(urlString)'")
        }
        
        var sortedParameters = urlParameters
        sortedParameters = sortedParameters.sortedByKeys(ascending: true)

        requestUrl = requestUrl.appendingQueryParameters(sortedParameters)
        log.debug("requestUrl: \(requestUrl)")

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        return request
    }
}
