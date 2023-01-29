//// Playable - 🎧
//// This file is part of the Playable project.
//// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
////
//// Created by: Frank Gregor
//// Created at: 14.01.23
////
//
//import SFSafeSymbols
//import SwiftUI
//
//public struct Navigation {
//    enum Group {
//        case podcasts
//        case radio
//        case general
//    }
//
//    enum Item {
//        enum Podcasts: Int, CaseIterable {
//            case live = 100
//            case discover
//            case subscribed
//            case popular
//            case featured
//
//            public static var allCases: [Podcasts] = [
//                .live, .discover, .subscribed, .popular, .featured
//            ]
//        }
//
//        enum Radio: Int, CaseIterable {
//            case favorites = 200
//
//            public static var allCases: [Radio] = [
//                .favorites
//            ]
//        }
//
//        enum General: Int, CaseIterable {
//            case settings = 300
//            case account
//
//            public static var allCases: [General] = [
//                .settings, .account
//            ]
//        }
//    }
//}
//
//extension Navigation.Group: Identifiable {
//    public var id: Int {
//        switch self {
//        case .podcasts:
//            return 0
//        case .radio:
//            return 1
//        case .general:
//            return 2
//        }
//    }
//}
//
//extension Navigation.Group: CaseIterable {
//    public static var allCases: [Navigation.Group] = [
//        .podcasts(NavigationItem.allPodcastCases),
//        .radio(NavigationItem.allRadioCases),
//        .general(NavigationItem.allGeneralCases)
//    ]
//}
//
//extension NavigationItem: CaseIterable {
//    public static var allPodcastCases: [NavigationItem] = [
//        .live, .discover, .subscribed, .popular, .featured
//    ]
//    public static var allRadioCases: [NavigationItem] = [
//        .favorites
//    ]
//    public static var allGeneralCases: [NavigationItem] = [
//        .settings, .account
//    ]
//}
//
//public extension NavigationItem {
//    var title: String {
//        switch self {
//        case .live:
//            return "Live"
//        case .discover:
//            return "Discover"
//        case .subscribed:
//            return "Subscribed"
//        case .popular:
//            return "Popular"
//        case .featured:
//            return "Featured"
//        }
//    }
//
//    var icon: SFSymbol {
//        switch self {
//        case .live:
//            return .antennaRadiowavesLeftAndRight
//        case .discover:
//            return .waveformAndMagnifyingglass
//        case .subscribed:
//            return .checklistChecked
//        case .popular:
//            return .chartLineUptrendXyaxis
//        case .featured:
//            return .medal
//        }
//    }
//
//    var shortcut: KeyboardShortcut {
//        switch self {
//        case .live:
//            return KeyboardShortcut("1", modifiers: .command)
//        case .discover:
//            return KeyboardShortcut("2", modifiers: .command)
//        case .subscribed:
//            return KeyboardShortcut("3", modifiers: .command)
//        case .popular:
//            return KeyboardShortcut("4", modifiers: .command)
//        case .featured:
//            return KeyboardShortcut("5", modifiers: .command)
//        }
//    }
//}
