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
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
                                         .withDesign(design)!
                                         .withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)!
        let largeTitle = UIFont.init(descriptor: descriptor, size: 36)
        let title = UIFont.init(descriptor: descriptor, size: 24)

        UINavigationBar.appearance().largeTitleTextAttributes = [.font : largeTitle]
        UINavigationBar.appearance().titleTextAttributes = [.font : title]

        log.info("Appearance Setup: done")
    }
    
}
