//
//  NavigationBarTitleView.swift
//  Playable
//
//  Created by Frank Gregor on 17.05.21.
//  Copyright © 2021 Woodbytes. All rights reserved.
//

import SwiftUI

struct NavigationBarTitleView: View {
    var service: StreamingServiceType
    
    var body: some View {
        HStack {
            service.icon
                .renderingMode(service.iconRenderingMode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 18)
            
            Text(service.name)
                .font(.headline)
        }
    }
}

struct NavigationBarTitleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarTitleView(service: .deezer)
    }
}
