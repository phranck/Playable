//
//  ServiceSetupRadio.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI
import RadioBrowser

struct ServiceSetupRadio: View {
    let serviceType: ServiceType = .radio
    
    @ObservedObject var radioBrowser = RadioBrowser()
    
    init() {
    }
    
    var body: some View {
        EmptyView()
    }

}

//struct RadioStationListRow: View {
//    let station: RadioStation
//
//    var body: some View {
////        ZStack {
////            RoundedRectangle(cornerRadius: 18, style: .continuous)
////                .foregroundColor(.secondarySystemBackground)
//
//            HStack {
//                WebImage(url: URL(string: station.coverUrl!))
//                    .placeholder(Image(systemName: "photo"))
//                    .resizable()
//                    .indicator(.activity)
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 64, height: 64, alignment: .center)
////                    .cornerRadius(12.5)
////                    .padding(10)
//                    .background(Color.label.opacity(0.1))
//                    .clipShape(SuperEllipseShape())
//
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(station.name)
//                        .font(.system(size: 16, weight: .regular, design: .rounded))
//                        .foregroundColor(.label)
//                        .lineLimit(2)
//
//                    Spacer()
//                }
//                Spacer()
//            }
//            .padding(10)
////        }
////        .frame(height: 64)
//    }
//}
//
//struct RadioStationListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        RadioStationListRow(
//            station: RadioStation(id: 1, name: "Radio Halligalli", streamUrl: "")
//        )
//    }
//}
