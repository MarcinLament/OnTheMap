//
//  UserCheckin.swift
//  OnTheMap
//
//  Created by Marcin Lament on 14/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

struct UserCheckin{
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mediaURL: String
    let uniqueKey: String
    var isUsersPost: Bool = false
    
    init(firstName: String, lastName: String, latitude: Double, longitude: Double, mediaURL: String, isUsersPost: Bool){
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mediaURL = mediaURL
        self.uniqueKey = ""
        self.isUsersPost = isUsersPost
    }
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mediaURL = dictionary["mediaURL"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
    }
    
    static func userCheckinsFromResults(results: [[String:AnyObject]]) -> [UserCheckin] {
        
        var checkins = [UserCheckin]()
        
        for result in results {
            checkins.append(UserCheckin(dictionary: result))
        }
        
        return checkins
    }
}

extension UserCheckin: Equatable {}

func ==(lhs: UserCheckin, rhs: UserCheckin) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}
