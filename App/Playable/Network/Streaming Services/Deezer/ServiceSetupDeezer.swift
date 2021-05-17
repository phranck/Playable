//
//  ServiceSetupDeezer.swift
//  Playable
//
//  Created by Frank Gregor on 02.12.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct ServiceSetupDeezer: View {
    let serviceType: StreamingServiceType = .deezer

    var body: some View {
        VStack {
            Text("\(serviceType.name) Service Setup")
        }
    }
}

struct ServiceSetupDeezer_Previews: PreviewProvider {
    static var previews: some View {
        ServiceSetupDeezer()
    }
}
