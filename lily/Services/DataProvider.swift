//
//  DataProvider.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol DataProvider {
    func getContestsForUser(completion: @escaping (([Contest]?) -> Void))
    func getPublicContests(completion: @escaping (([Contest]?) -> Void))
    func getMediaForUser(completion: @escaping (([Media]?) -> Void))
}
