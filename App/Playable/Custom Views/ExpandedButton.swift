//
//  WBButton.swift
//  Playable
//
//  Created by Frank Gregor on 26.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct ExpandedButton: View {
    @Environment(\.hapticFeedback) var feedback: UIImpactFeedbackGenerator

    @State var label: LocalizedStringKey
    @State var icon: Image?
    var hapticFeedback: Bool = true
    var action: () -> Void
    @State private var show: Bool = false
    
    var body: some View {
        Button(action: {
            if hapticFeedback {
                feedback.impactOccurred()
            }
            self.show = true
            action()
            
        }, label: {
            HStack {
                Group {
                    Spacer()
                    if let icon = icon {
                        icon
                    }
                    Text(label)
                    Spacer()
                }
            }
        })
        .buttonStyle(ExpandedButtonStyle())
        .padding(8)
    }
}

struct ExpandedButton_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedButton(label: "Click me!") {
            
        }
    }
}
