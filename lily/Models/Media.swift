//
//  Media.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct Media {
    var id: String
    var code: String
    var userId: String
    var username: String
    var imageUrl: String // videos contain screenshot url, carousel is url of first image
    var createdTime: String
    var caption: String?
    var type: String // image, carousel, video
    var link: String
    
    init(id: String,
         code: String,
         userId: String,
         username: String,
         imageUrl: String,
         createdTime: String,
         caption: String?,
         type: String,
         link: String) {
        self.id = id
        self.code = code
        self.userId = userId
        self.username = username
        self.imageUrl = imageUrl
        self.createdTime = createdTime
        self.caption = caption
        self.type = type
        self.link = link
    }
    
    static func decode(json: AnyObject) -> Media? {
        guard let dict = json as? [String: AnyObject] else { return nil }
        
        guard let id = dict["id"] as? String else { return nil }
        guard let code = dict["code"] as? String else { return nil }
        
        guard let userDict = dict["user"] as? [String: AnyObject] else { return nil }
        guard let userId = userDict["id"] as? String else { return nil }
        guard let username = userDict["username"] as? String else { return nil }
        
        guard let imagesDict = dict["images"] as? [String: AnyObject] else { return nil }
        guard let standardResolutionImagesDict = imagesDict["standard_resolution"] as? [String: AnyObject] else { return nil }
        guard let imageUrl = standardResolutionImagesDict["url"] as? String else { return nil }
        
        guard let createdTime = dict["created_time"] as? String else { return nil }
        
        var caption: String?
        if let captionDict = dict["caption"] as? [String: AnyObject] {
            caption = captionDict["text"] as? String
        }
        
        guard let type = dict["type"] as? String else { return nil }
        guard let link = dict["link"] as? String else { return nil }
        
        return Media(id: id, code: code, userId: userId, username: username, imageUrl: imageUrl, createdTime: createdTime, caption: caption, type: type, link: link)
    }
}

// DELETE THIS:
let testMedia = Media(id: "123", code: "abc", userId: "234", username: "usernameTest", imageUrl: "https://scontent-sea1-1.cdninstagram.com/t51.2885-19/s150x150/12825859_1155023317871197_291136405_a.jpg", createdTime: "0000", caption: "Caption test!", type: "image", link: "https://www.instagram.com/p/BY38rA3Ht_-/")
