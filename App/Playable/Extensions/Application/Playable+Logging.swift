//
//  Playable+Logging.swift
//  Playable
//
//  Created by Frank Gregor on 16.05.21.
//  Copyright © 2021 Woodbytes. All rights reserved.
//

import Foundation
import SwiftyBeaver
let log = SwiftyBeaver.self

func setupLogging() {
    // https://docs.swiftybeaver.com/article/20-custom-format
    let console = ConsoleDestination()
    console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
    console.asynchronously = false
    log.addDestination(console)
    
    log.debug("Logging Setup: done")
}
