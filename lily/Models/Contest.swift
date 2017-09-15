//
//  Contest.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

enum State: Int {
    case Inactive
    case InProgress
    case Complete
}

struct Contest {
    var name: String
    var media: Media
    var state: State {
        didSet {
            // state machine - transitions
            switch oldValue {
            case .Inactive:
                if state == .Complete {
                    state = oldValue
                }
            default:
                break
            }
        }
    }
    
    init(name: String, media: Media, state: State = .Inactive) {
        self.name = name
        self.media = media
        self.state = state
    }
}
