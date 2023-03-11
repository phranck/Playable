// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 04.02.23
//

import Foundation
import RealmSwift

enum StationType: Int, PersistableEnum {
    case unknown = 0
    case radio
    case podcast
}

public class Station: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var id = UUID()

    @Persisted var station: StationType = .unknown
}

// MARK: - Debugging

extension Station {
    override public var debugDescription: String {
        var desc = "ID: \(_id), "
        desc.append("station: \(station)")

        return desc
    }
}
