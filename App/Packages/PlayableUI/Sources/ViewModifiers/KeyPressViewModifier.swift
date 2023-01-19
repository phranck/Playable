// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 15.12.22
//

import SwiftUI

/// Keyboard layout independent keycodes
public enum ViewKeyCode: UInt16 {
    case Return        = 0x24
    case Tab           = 0x30
    case Space         = 0x31
    case Delete        = 0x33
    case Escape        = 0x35
    case Command       = 0x37
    case Shift         = 0x38
    case CapsLock      = 0x39
    case Option        = 0x3A
    case Control       = 0x3B
    case RightShift    = 0x3C
    case RightOption   = 0x3D
    case RightControl  = 0x3E
    case Function      = 0x3F
    case F17           = 0x40
    case VolumeUp      = 0x48
    case VolumeDown    = 0x49
    case Mute          = 0x4A
    case F18           = 0x4F
    case F19           = 0x50
    case F20           = 0x5A
    case F5            = 0x60
    case F6            = 0x61
    case F7            = 0x62
    case F3            = 0x63
    case F8            = 0x64
    case F9            = 0x65
    case F11           = 0x67
    case F13           = 0x69
    case F16           = 0x6A
    case F14           = 0x6B
    case F10           = 0x6D
    case F12           = 0x6F
    case F15           = 0x71
    case Help          = 0x72
    case Home          = 0x73
    case PageUp        = 0x74
    case ForwardDelete = 0x75
    case F4            = 0x76
    case End           = 0x77
    case F2            = 0x78
    case PageDown      = 0x79
    case F1            = 0x7A
    case LeftArrow     = 0x7B
    case RightArrow    = 0x7C
    case DownArrow     = 0x7D
    case UpArrow       = 0x7E
}

public extension View {
    @available(iOS, deprecated, message: "The closure of this modifier is being ignored. It just returns the view it is attached to.")
    func onKeyPress(_ keyCode: ViewKeyCode, action: @escaping () -> Void) -> some View {
#if os(macOS)
        modifier(KeyPressViewModifier(keyCode, action: action))
#else
        self
#endif
    }
}

#if os(macOS)
import Carbon.HIToolbox

// MARK: - Private API

private struct KeyPressViewModifier: ViewModifier {
    let keyCode: ViewKeyCode
    let action: () -> Void

    init(_ keyCode: ViewKeyCode, action: @escaping () -> Void) {
        self.keyCode = keyCode
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .background {
                KeyCodeView(keyCode: keyCode, action: action)
            }
    }
}

private struct KeyCodeView: NSViewRepresentable {
    var keyCode: ViewKeyCode
    var action: () -> Void

    func makeNSView(context: Context) -> _KeyCodeView {
        let view = _KeyCodeView()
        view.keyCode = keyCode.rawValue
        view.action = action
        view.frame = .zero

        return view
    }

    func updateNSView(_ view: _KeyCodeView, context: Context) {}
}

private extension KeyCodeView {
    // swiftlint:disable type_name
    final class _KeyCodeView: NSView {
        var keyCode: UInt16 = 0
        var action: (() -> Void) = {}

        override func performKeyEquivalent(with event: NSEvent) -> Bool {
            if event.keyCode == keyCode {
                action()
                return true
            }
            return super.performKeyEquivalent(with: event)
        }
    }
}
#endif
