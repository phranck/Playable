//
//  Created by Frank Gregor on 16.03.18.
//  Copyright © 2018 Sir Apfelot. All rights reserved.
//

import Foundation

extension URL {
    
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
    
}
