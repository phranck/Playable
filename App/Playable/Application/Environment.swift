//
//  Environment.swift
//  Playable
//
//  Created by Frank Gregor on 26.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI
import LinkPlay

extension EnvironmentValues {
    var hapticFeedback: UIImpactFeedbackGenerator {
        get {
            return self[Feedback.self]
        }
    }
}

public struct Feedback: EnvironmentKey {
    public static let defaultValue: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
}
