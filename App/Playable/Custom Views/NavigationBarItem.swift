//
//  NavigationTextButton.swift
//  Playable
//
//  Created by Frank Gregor on 29.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct NavigationBarItem: View {
    @Environment(\.hapticFeedback) var feedback
    var title: LocalizedStringKey?
    var iconName: String?
    var icon: Image?
    var action: () -> Void
    
    init(titleKey: LocalizedStringKey, action: @escaping () -> Void) {
        self.title = titleKey
        self.action = action
    }
    
    init(titleKey: LocalizedStringKey, iconName: String, action: @escaping () -> Void) {
        self.title = titleKey
        self.iconName = iconName
        self.action = action
    }
    
    init(titleKey: LocalizedStringKey, icon: Image, action: @escaping () -> Void) {
        self.title = titleKey
        self.icon = icon
        self.action = action
    }

    init(title: String, action: @escaping () -> Void) {
        self.title = LocalizedStringKey(title)
        self.action = action
    }
    
    init(title: String, iconName: String, action: @escaping () -> Void) {
        self.title = LocalizedStringKey(title)
        self.iconName = iconName
        self.action = action
    }
    
    init(title: String, icon: Image, action: @escaping () -> Void) {
        self.title = LocalizedStringKey(title)
        self.icon = icon
        self.action = action
    }
    
    init(iconName: String, action: @escaping () -> Void) {
        self.iconName = iconName
        self.action = action
    }
    
    init(icon: Image, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: {
            feedback.impactOccurred()
            action()
        }, label: {
            _label
        })
        .buttonStyle(NavigationBarItemStyle())
    }
    
    private var _label: some View {
        return Group {
            if let title = title, let icon = icon {
                HStack {
                    icon
                    Text(title)
                }
            }
            else if let title = title, let iconName = iconName {
                Label(title, systemImage: iconName)
            }
            else if let title = title {
                Text(title)
            }
            else if let icon = icon {
                icon
            }
            else if let iconName = iconName {
                Image(iconName)
            }
        }
    }
}

struct NavigationItemButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarItem(title: "Clircle", iconName: "command.circle.fill") {
            
        }
        .preferredColorScheme(.dark)
    }
}
