//
//  LivePollsWidgetAttributes.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import ActivityKit
import Foundation

struct LivePollsWidgetAttributes: ActivityAttributes {
    
    typealias ContentState = Poll

    public var pollId: String
    init(pollId: String) {
        self.pollId = pollId
    }
}
