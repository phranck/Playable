//
//  ServicesView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct ServicesTabView: TappableView {
    static var tabItemTitle: LocalizedStringKey { TappableViewItem.services.titleKey }

    private let services: [ServiceItem] = [
        ServiceItem(type: .radio),
        ServiceItem(type: .deezer),
        ServiceItem(type: .spotify),
        ServiceItem(type: .soundcloud),
        ServiceItem(type: .tidal),
        ServiceItem(type: .napster),
    ]

    @Environment(\.hapticFeedback) var feedback
    var gridItems: [GridItem] = [GridItem()]
    @State private var isSheetActive = false

    var body: some View {
//        ScrollView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: gridItems, alignment: .top, spacing: 0) {
                        ForEach((1...services.count), id: \.self) { idx in
                            ServiceGridItem(model: services[idx-1])
                                .buttonStyle(ListRowButtonStyle())
                                .onTapGesture {
                                    showSheet()
                                }
                                .sheet(isPresented: $isSheetActive, content: {
                                    Text(services[idx-1].name)
                                })
                        }
                    }
                }
                
                HStack {
                    Text("Favorites")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top, .leading], 16)
                    Spacer()
                }

                ScrollView() {
                    
                }
            }
//        }
    }
    
    func showSheet() {
        isSheetActive = true
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesTabView()
            .preferredColorScheme(.dark)
    }
}
