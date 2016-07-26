//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Marcin Lament on 22/06/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

extension OTMClient{

    struct UdacityConstants{
        static let SessionUrl = "https://www.udacity.com/api/session"
        static let UsersUrl = "https://www.udacity.com/api/users/"
    }
    
    struct ParseConstants{
        static let LocationsUrl = "https://api.parse.com/1/classes/StudentLocation";
        static let LocationsLimitCount = "?limit=100&order=-updateAt"
        
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ClientKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct RequestKeys{
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        
        
    }
    
    struct ResponseKeys{
        static let Account = "account"
        static let Key = "key"
        static let User = "user"
        static let Results = "results"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}