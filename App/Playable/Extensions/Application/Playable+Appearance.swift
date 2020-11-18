//
//  Playable+Appearance.swift
//  Playable
//
//  Created by Frank Gregor on 29.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

extension Playable {
    
    func setupAppearance() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.rounded)!, size: 18)]
        navBarAppearance.largeTitleTextAttributes = [.font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.rounded)!, size: 30)]
        
        UIWindow.appearance().backgroundColor = .systemGroupedBackground
        
        log.info("Appearance Setup: done")
    }
    
}
