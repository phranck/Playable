//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import Network
import SwiftUI

/// An enum to handle the network status
public enum NetworkStatus: Equatable {
    case connected
    case disconnected(NWPath.UnsatisfiedReason)
}

public final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "\(NetworkMonitor.self)")

    public static let shared = NetworkMonitor()
    @Published public var status: NetworkStatus = .connected

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:
                    self.status = .connected

                default:
                    self.status = .disconnected(path.unsatisfiedReason)
                }
            }
        }

        monitor.start(queue: queue)
    }
}
