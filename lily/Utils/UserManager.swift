//
//  UserManager.swift
//  lily
//
//  Created by Nathan Chan on 10/3/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    var token: String?
}
