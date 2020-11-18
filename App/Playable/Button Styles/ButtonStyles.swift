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
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.easeInOut(duration: 0.1))
    }
}

struct NavigationBarItemStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(Color.label.opacity(0.8))
            .background(Color.secondarySystemBackground)
            .cornerRadius(9, antialiased: true)
            .shadow(color: Color.systemGray.opacity(0.35), radius: 0, x: 0, y: -1)
            .shadow(color: Color.black.opacity(0.6), radius: 0, x: 0, y: 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.075))
    }
}

struct ExpandedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding(12)
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(Color.label.opacity(0.8))
            .background(Color.secondarySystemBackground)
            .cornerRadius(15, antialiased: true)
            .shadow(color: Color.systemGray.opacity(0.35), radius: 0, x: 0, y: -1)
            .shadow(color: Color.black.opacity(0.6), radius: 0, x: 0, y: 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.075))
    }
}
