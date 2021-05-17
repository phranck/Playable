//
//  ServiceSetupRadio.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct ServiceSetupRadio: View {
    let serviceType: StreamingServiceType = .radio
    
    var body: some View {
        VStack {
            Text("\(serviceType.name) Service Setup")
        }
    }
}

struct RadioConfiguration_Previews: PreviewProvider {
    static var previews: some View {
        ServiceSetupRadio()
    }
}
