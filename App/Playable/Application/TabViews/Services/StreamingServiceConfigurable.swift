//
//  StreamingServiceConfigurable.swift
//  Playable
//
//  Created by Frank Gregor on 29.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import Foundation

protocol StreamingServiceConfigurable {
    var serviceType: StreamingServiceType { get set }
}
