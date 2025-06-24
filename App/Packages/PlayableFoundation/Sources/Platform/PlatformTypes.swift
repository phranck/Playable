// Cadrage Studio - 🎬
// This file is part of the Cadrage Studio project.
// Copyright (C) 2021-2023 Cadrage GmbH, <support@cadrage.app>
//
// Created by: Frank Gregor
// Created at: 24.03.23
//

// MARK: - macOS Types

import Foundation
import SwiftUI

#if os(macOS)
public typealias PlatformApplication                = NSApplication
public typealias PlatformApplicationDelegate        = NSApplicationDelegate
public typealias PlatformApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
public typealias PlatformColor                      = NSColor
public typealias PlatformFont                       = NSFont
public typealias PlatformImage                      = NSImage
public typealias PlatformView                       = NSView
public typealias PlatformViewRepresentable          = NSViewRepresentable
public typealias PlatformWindow                     = NSWindow
public typealias PlatformHostingController          = NSHostingController

public extension NSWindow {
    var safeAreaInsets: NSEdgeInsets {
        NSEdgeInsets()
    }
}
#endif

// MARK: - iOS Types

#if os(iOS) || os(watchOS) || os(tvOS)
public typealias PlatformApplication                = UIApplication
public typealias PlatformApplicationDelegate        = UIApplicationDelegate
public typealias PlatformApplicationDelegateAdaptor = UIApplicationDelegateAdaptor
public typealias PlatformColor                      = UIColor
public typealias PlatformFont                       = UIFont
public typealias PlatformImage                      = UIImage
public typealias PlatformView                       = UIView
public typealias PlatformViewRepresentable          = UIViewRepresentable
public typealias PlatformWindow                     = UIWindow
public typealias PlatformHostingController          = UIHostingController
#endif

public extension PlatformApplication {
#if os(iOS) || os(watchOS) || os(tvOS)
    var currentWindow: UIWindow? {
        connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .first
    }
#elseif os(macOS)
    var currentWindow: NSWindow? {
        NSApplication.shared.keyWindow
    }
#endif
}

@MainActor
public let PlatformApp = PlatformApplication.shared
