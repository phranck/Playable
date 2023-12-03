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
    @ViewBuilder private let content: ContentBuilder
    @ViewBuilder private let alternateContent: ContentBuilder?

    public init(if: Bool = true, @ViewBuilder _ content: @escaping ContentBuilder, else alternateContent: ContentBuilder? = nil) {
        self.condition = `if`
        self.content = content
        self.alternateContent = alternateContent
    }

    public var body: some View {
        if condition {
            content()
        } else {
            if let alternateContent {
                alternateContent()
            } else {
                EmptyView()
            }
        }
    }
}
