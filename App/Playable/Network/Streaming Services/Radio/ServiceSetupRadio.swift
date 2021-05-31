//
//  ServiceSetupRadio.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI
import PlayableBrowser
import SDWebImageSwiftUI

struct ServiceSetupRadio: View {
    let serviceType: StreamingServiceType = .radio
    
    @ObservedObject var radioBrowser = PlayableBrowser(agent: "Playable", version: PlayableBrowser.version)
    
    init() {
        let regionCode = Locale.current.regionCode ?? "AT"
        self.radioBrowser.stationsBy(countryCode: "AT")
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(radioBrowser.radioStations, id: \.self, content: RadioStationListRow.init)
        }
        .padding([.leading, .trailing], 8)
    }

}

struct RadioStationListRow: View {
    let station: RadioStation
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .foregroundColor(.secondarySystemBackground)
            
            HStack {
                stationCoverImage

//                VStack(alignment: .leading, spacing: 10) {
//                    Text(station.name)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .foregroundColor(.label)
//                        .lineLimit(2)
//
//                    if let description = station.description {
//                        Text(description)
//                            .font(.system(size: 15, weight: .regular, design: .rounded))
//                            .foregroundColor(.secondaryLabel)
//                            .lineLimit(3)
//                            .truncationMode(.tail)
//                    }
//
                    Spacer()
//                }
            }
        }
    }
    
    var stationCoverImage: some View {
        Group {
            if let coverUrl = station.coverUrl {
                WebImage(url: URL(string: coverUrl))
                    .placeholder(Image(systemName: "photo"))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64, alignment: .center)
                    .cornerRadius(12)
                    .padding(10)
            } else {
                Image(systemName: "photo")
            }
        }
    }
}
