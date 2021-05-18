//
//  ServiceSetupRadio.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI
import RadioBrowser
import URLImage

struct ServiceSetupRadio: View {
    let serviceType: StreamingServiceType = .radio
    
    @ObservedObject var radioBrowser = RadioBrowser()
    
    init() {
        let locale = Locale.current
        let regionCode = locale.regionCode ?? "DE"
        
        self.radioBrowser.stationsForCountryCode(regionCode)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(radioBrowser.radioStations, id: \.self) { station in
                NavigationLink(destination: EmptyView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.secondarySystemBackground)
                        
                        HStack {
                            URLImage(URL(string: station.iconUrlString!)!) {
                                // This view is displayed before download starts
                                EmptyView()
                            }
                            inProgress: { progress in
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .cornerRadius(6)
                                    .padding(.trailing, 8)
                                    .foregroundColor(.secondaryLabel)
                                    .rotationEffect(.degrees(360))
                                    .animation(Animation.linear)
                            }
                            failure: { error, retry in
                                Image(systemName: "waveform.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .cornerRadius(6)
                                    .padding(.trailing, 8)
                                    .foregroundColor(.secondaryLabel)
                            }
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 56, alignment: .center)
                                    .cornerRadius(6)
                                    .padding(.trailing, 8)
                                    .foregroundColor(.label)
                            }

                            VStack(alignment: .leading) {
                                Text(station.name)
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                    .foregroundColor(.label)

                                Spacer()
                            }
                            
                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondaryLabel)
                        }
                        .padding(10)
                    }
                    .padding([.leading, .trailing], 10)
                }
                .buttonStyle(ListRowButtonStyle())
            }
            
        }
    }
}

struct RadioConfiguration_Previews: PreviewProvider {
    
    static var previews: some View {
        ServiceSetupRadio()
    }
    
}
