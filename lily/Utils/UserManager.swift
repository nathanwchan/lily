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
    let defaults = UserDefaults.standard
    
    private init() {
        if let token = defaults.string(forKey: Globals.userDefaultsTokenKey) {
            self.token = token
        }
        
    }
    private(set) var token: String?
    
    func save(_ token: String) {
        defaults.set(token, forKey: Globals.userDefaultsTokenKey)
        self.token = token
    }
    
    func clearToken() {
        self.token = nil
    }
}
