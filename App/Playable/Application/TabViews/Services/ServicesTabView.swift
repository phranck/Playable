//
//  ServicesView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct ServicesTabView: TappableView {
    var tabItemTitle: TappableViewTitle { .services }
    @State private var presentingModal = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
//                ExpandedButton(
//                    label: LocalizedStringKey("Select a Service"),
//                    icon: .musicNote) {
//                    self.presentingModal = true
//                }
            }
            .navigationTitle(tabItemTitle.rawValue)
            .navigationBarItems(
                trailing:
                    NavigationBarItem(titleKey: LocalizedStringKey("Add"), icon: .musicNote, action: {
                        self.presentingModal = true
                    })
                
            )
            .fullScreenCover(isPresented: $presentingModal, content: {
                StreamingServiceSelectionView(presentedAsModal: $presentingModal)
                    .preferredColorScheme(.dark)
            })
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesTabView()
            .preferredColorScheme(.dark)
    }
}
