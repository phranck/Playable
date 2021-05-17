//
//  ButtonStyles.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct ListRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1))
    }
}

struct NavigationBarItemStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding(EdgeInsets(top: 5, leading: 9, bottom: 5, trailing: 9))
            .font(.system(size: 17, weight: .medium, design: .rounded))
            .foregroundColor(.accentColor)
            .background(.secondarySystemBackground)
            .cornerRadius(9, antialiased: true)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.075))
    }
}
