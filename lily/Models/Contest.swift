//
//  Contest.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct Contest {
    var name: String
    var media: Media
    var isComplete: Bool = false
    
    init(name: String, media: Media) {
        self.name = name
        self.media = media
    }
}
