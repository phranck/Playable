//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import Foundation
import OSLog

public let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "me.woodbytes.Playable", category: "")

public func setupLogging() {
    log.debug("Logging Setup: done")
}

// MARK: - Public Logger API

public extension Logger {
    func `default`(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        _log(.default, message, file: file, function: function, line: line)
    }

    func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        _log(.info, message, file: file, function: function, line: line)
    }

    func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        _log(.debug, message, file: file, function: function, line: line)
    }

    func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        _log(.error, message, file: file, function: function, line: line)
    }

    func fault(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        _log(.fault, message, file: file, function: function, line: line)
    }
}

// MARK: - Private Logger API

private extension Logger {
    func _log(_ level: OSLogType, _ message: Any, file: String, function: String, line: Int) {
        let fileUrl = URL(filePath: file)
        let fileName = fileUrl.lastPathComponent.components(separatedBy: ".")[0]

        if let msg = message as? Error {
            log(level: level, "[\(fileName) → \(function):\(line)] \(msg.localizedDescription)")
            return
        }

        if let msg = message as? Dictionary<String, Any> {
            log(level: level, "[\(fileName) → \(function):\(line)] \(msg.description)")
            return
        }

        if let msg = message as? String {
            log(level: level, "[\(fileName) → \(function):\(line)] \(msg)")
            return
        }
    }
}
