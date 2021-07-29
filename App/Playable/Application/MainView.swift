//
//  MainView.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct MainView: View {
//    // https://github.com/BLCKBIRDS/CustomTabBarInSwiftUI/blob/master/CustomTabBarInSwiftUI/CustomTabBar/ContentView.swift
//    @State var selection: Int = 0
//
//    var body: some View {
//        GeometryReader { gemetry in
//            VStack {
//                Spacer()
//                Text("Hello World...")
//                Spacer()
//                HStack {
//                    Spacer(minLength: 16)
//
//                    HStack {
//
//                    }
//                    .frame(
//                        width: gemetry.size.width-32,
//                        height: 72,
//                        alignment: .bottom
//                    )
//                    .background(Color.systemGray)
//                    .cornerRadius(28)
//
//                    Spacer(minLength: 16)
//                }
//                .padding(.bottom, 16)
//            }
//            .edgesIgnoringSafeArea(.vertical)
////            .padding(.bottom, 20)
//        }
//    }
        
        
        @State private var selectedTab = TappableViewItem.devices

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DevicesTabView()
                    .navigationBarTitle(
                        Text(DevicesTabView.tabItemTitle)
                    )
            }
            .tabItem {
                Label(
                    TappableViewItem.devices.titleKey,
                    systemImage: TappableViewItem.devices.systemImageName
                )
            }
            .tag(TappableViewItem.devices)

            NavigationView {
                ServicesTabView()
                    .navigationBarTitle(
                        Text(ServicesTabView.tabItemTitle)
                    )
            }
            .tabItem {
                Label(
                    TappableViewItem.services.titleKey,
                    systemImage: TappableViewItem.services.systemImageName
                )
            }
            .tag(TappableViewItem.services)

//            NavigationView {
//                SettingsTabView()
//                    .navigationBarTitle(SettingsTabView.tabItemTitle)
//            }
//            .tabItem {
//                Label(
//                    TappableViewItem.settings.titleKey,
//                    systemImage: TappableViewItem.settings.systemImageName
//                )
//            }
//            .tag(TappableViewItem.settings)
        }
        .navigationBarTitleDisplayMode(.large)
        .symbolRenderingMode(.hierarchical)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
