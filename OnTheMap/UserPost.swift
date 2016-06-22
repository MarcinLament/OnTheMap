//
//  UserPost.swift
//  OnTheMap
//
//  Created by Marcin Lament on 19/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

struct UserPost{
    
    let objectId: String?
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary["objectId"] as! String
    }
    
    static func userPostFromResult(result: [String:AnyObject]) -> UserPost {
        return UserPost(dictionary: result)
    }
}