// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 19.01.23
//

import SwiftUI

/// Takes a boolean as condition to show the `content` closure or not.
public struct Conditional<Content: View>: View {
    public typealias ContentBuilder = () -> Content
    private var condition: Bool
    private var content: ContentBuilder

    public init(if condition: Bool = false, @ViewBuilder _ content: @escaping ContentBuilder) {
        self.condition = condition
        self.content = content
    }

    public var body: some View {
        condition ? content() : nil
    }
}
