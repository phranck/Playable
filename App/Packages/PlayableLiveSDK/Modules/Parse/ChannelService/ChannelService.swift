//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 13.01.23
//

import ParseSwift
import PlayableFoundation
import SwiftUI

public class ChannelService: ObservableObject {
    @Published public var channels: [Channel] = []

    private var channelSubscription: SubscriptionCallback<Channel>?

    public init() {
        Channel.allChannels.find { result in
            switch result {
            case .success(let channels):
                log.debug("Found \(channels.count) channels")
                self.channels = channels
                self.channelSubscription = Channel.allChannels.subscribeCallback
                self.channelSubscription?.handleSubscribe(self.handleSubscribe)
                self.channelSubscription?.handleUnsubscribe(self.handleUnsubscribe)
                self.channelSubscription?.handleEvent(self.handleEvent)

            case .failure(let error):
                log.error(error.localizedDescription)
                ErrorHandler.handle(error: error)
            }
        }
    }
}

// MARK: - Private Helper

private extension ChannelService {
    func handleSubscribe(_ query: Query<Channel>, _ isNewSubscription: Bool) {
        if isNewSubscription {
            log.debug("Successfully subscribed to query \(query)")
        } else {
            log.debug("Successfully updated subscription to new query \(query)")
        }
    }

    func handleUnsubscribe(_ query: Query<Channel>) {
        log.debug("Unsubscribed from \(query)")
    }

    func handleEvent(_ query: Query<Channel>, _ event: Event<Channel>) {
        DispatchQueue.main.async {
            switch event {
            case .entered:
                log.debug("Event: entered")
            case .left(let channel):
                log.debug("Event: left: \(channel)")
            case .created:
                log.debug("Event: created")
            case .updated(let channel):
                if let index = self.channels.firstIndex(of: channel) {
                    self.channels[index] = channel
                    log.debug("Event: updated: \(channel)")
                }
            case .deleted(let channel):
                if let index = self.channels.firstIndex(of: channel) {
                    self.channels.remove(at: index)
                    log.debug("Event: deleted: \(channel)")
                }
            }
        }
    }
}
