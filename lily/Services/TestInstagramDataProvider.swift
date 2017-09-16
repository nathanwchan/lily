//
//  TestInstagramDataProvider.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import Alamofire

class TestInstagramDataProvider: DataProvider {
    
    let lilyTheSheepdogIGMediaEndpoint = "https://www.instagram.com/lily.the.sheepdog/media/"
    let roccoIGMediaEndpoint = "https://www.instagram.com/rocco_roni/media/"
    
    func getContestsFromIGEndpoint(_ endpoint: String, completion: @escaping (([Contest]?) -> Void)) {
        Alamofire.request(endpoint).responseJSON { response in
            guard let json = response.result.value else {
                print("can't get json")
                return
            }
            guard let jsonData = json as? [String: AnyObject] else {
                print("can't get jsonData")
                return
            }
            guard let items = jsonData["items"] as? [AnyObject] else {
                print("can't get items")
                return
            }
            
            let mediaList = items.flatMap { Media.decode(json: $0) }
            let contests = mediaList.map { Contest(name: "Contest \(arc4random_uniform(100))", media: $0, state: State(rawValue: Int(arc4random_uniform(3)))!) }
            completion(contests)
        }
    }
    
    func getContestsForUser(completion: @escaping (([Contest]?) -> Void)) {
        getContestsFromIGEndpoint(lilyTheSheepdogIGMediaEndpoint, completion: completion)
    }
    
    func getPublicContests(completion: @escaping (([Contest]?) -> Void)) {
        getContestsFromIGEndpoint(roccoIGMediaEndpoint, completion: completion)
    }
    
    func getMediaForUser(completion: @escaping (([Media]?) -> Void)) {
        Alamofire.request(lilyTheSheepdogIGMediaEndpoint).responseJSON { response in
            guard let json = response.result.value else {
                print("can't get json")
                return
            }
            guard let jsonData = json as? [String: AnyObject] else {
                print("can't get jsonData")
                return
            }
            guard let items = jsonData["items"] as? [AnyObject] else {
                print("can't get items")
                return
            }
            
            let mediaList = items.flatMap { Media.decode(json: $0) }
            completion(mediaList)
        }
    }
}
