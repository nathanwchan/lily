//
//  Contest.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import IGListKit

enum State: Int {
    case Inactive
    case InProgress
    case Complete
}

enum SortOrder {
    case CreatedAtDesc
}

class Contest: ListDiffable {
    var id: String
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
        self.id = UUID().uuidString
        self.name = name
        self.media = media
        self.state = state
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Contest else { return false }
        return name == object.name
    }
}
