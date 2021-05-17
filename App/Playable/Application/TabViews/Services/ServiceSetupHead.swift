//
//  ServiceSetupHead.swift
//  Playable
//
//  Created by Frank Gregor on 01.12.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct ServiceSetupHead: View {
    var service: StreamingServiceType
    
    var body: some View {
        VStack(alignment: .center) {
            service.icon
                .renderingMode(service.iconRenderingMode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 90)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
                .foregroundColor(service.iconRenderingColor)
            
            Text(service.name)
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text(service.description)
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
    }
}

struct ServiceSetupHead_Previews: PreviewProvider {
    static var previews: some View {
        ServiceSetupHead(service: .deezer)
    }
}
