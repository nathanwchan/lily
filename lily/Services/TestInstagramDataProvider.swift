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
    
    func getContestsForUser(completion: @escaping (([Contest]?) -> Void)) {
        return
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