//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import Foundation
import SwiftyBeaver

public let log = SwiftyBeaver.self

public func setupLogging() {
    // https://docs.swiftybeaver.com/article/20-custom-format
    let console = ConsoleDestination()
    console.format = "$DHH:mm:ss.SSS$d [$L] $N.$F:$l → $M"
    console.asynchronously = false
    log.addDestination(console)

    log.debug("Logging Setup: done")
}
