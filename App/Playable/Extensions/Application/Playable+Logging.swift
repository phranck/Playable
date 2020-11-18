//
//  Playable+Logging.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 24.11.20.
//

import Foundation
import SwiftyBeaver
import RadioBrowser

let log = SwiftyBeaver.self

extension Playable {
    
    func setupLogging() {
        // https://docs.swiftybeaver.com/article/20-custom-format
        let console = ConsoleDestination()
        console.useTerminalColors   = false
        console.levelString.debug   = "[DEBUG]"
        console.levelString.info    = "[INFO]"
        console.levelString.error   = "[ERROR]"
        console.levelString.verbose = "[VERBOSE]"
        console.levelString.warning = "[WARNING]"
        log.addDestination(console)
        
        let cloud = SBPlatformDestination(
            appID: "aJp2px",
            appSecret: "xnScsmxwrcmdelxp8sifnw8rBoejpmq5",
            encryptionKey: "q5HfWq5l3opv6nqinlikvj6jnsnnQyzQ"
        )
        log.addDestination(cloud)
        
        log.info("Logging Setup: done")
        log.info("Radio Browser Version: \(RadioBrowser.version)")
    }
    
}
