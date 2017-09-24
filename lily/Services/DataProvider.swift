//
//  DataProvider.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol DataProvider {
    func getContestsForUser(maxId: String?, completion: @escaping (([Contest]) -> Void))
    func getPublicContests(maxId: String?, completion: @escaping (([Contest]) -> Void))
    func getMediaForUser(completion: @escaping (([Media]) -> Void))
}
