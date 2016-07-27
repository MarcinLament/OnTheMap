//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Marcin Lament on 04/06/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

extension OTMClient{
    
    func login(username: String, password: String, completionHandlerForLogin: (success: Bool, errorString: String?) -> Void){

        getUserId(username, password: password){(success, userId, errorString) in
            if(success){
                self.userId = userId
                
                self.getUserDetails(userId!){(success, user, errorString) in
                    if(success){
                        self.user = user
                    }
                    
                    completionHandlerForLogin(success: success, errorString: errorString)
                }
            }
        
            completionHandlerForLogin(success: success, errorString: errorString)
        }
    }
    
    func getUserId(username: String, password: String, completionHandlerForLogin: (success: Bool, userId: String?, errorString: String?) -> Void){
        
        let httpBody = String("{\"udacity\": {\"username\": \""+username+"\", \"password\": \""+password+"\"}}")

        let httpMethod = "POST"
        let headers = ["Accept": "application/json", "Content-Type": "application/json"]

        taskForPOSTMethod(UdacityConstants.SessionUrl, httpMethod: httpMethod, httpBody: httpBody, headers: headers, subsetResponseData: true) { (result, error) in
            
            if let error = error {
                if(error.code > 1){
                    completionHandlerForLogin(success: false, userId: nil, errorString: "Invalid credentials")
                }else{
                    completionHandlerForLogin(success: false, userId: nil, errorString: error.localizedDescription)
                }
            } else {
                if let userId = (result[ResponseKeys.Account] as! NSDictionary)[ResponseKeys.Key]{
                    completionHandlerForLogin(success: true, userId: userId as? String, errorString: nil)
                } else {
                    completionHandlerForLogin(success: false, userId: nil, errorString: "Failed to login")
                }
            }
        }
    }
    
    func getUserDetails(userId: String, completionHandlerForGetUserDetails: (success: Bool, user: NSDictionary?, errorString: String?) -> Void){

        let url = UdacityConstants.UsersUrl + String(self.userId!);
        
        taskForPOSTMethod(url, httpMethod: nil, httpBody: nil, headers: nil, subsetResponseData: true) { (result, error) in
            
            if (error != nil) {
                completionHandlerForGetUserDetails(success: false, user: nil, errorString: error?.localizedDescription)
            } else {
                
                if let obj = result![ResponseKeys.User] {
                    let user = obj as? NSDictionary
                    completionHandlerForGetUserDetails(success: true, user: user, errorString: nil)
                    
                } else {
                    completionHandlerForGetUserDetails(success: false, user: nil, errorString: "Getting User Details Failed")
                }
            }
        }
    }
    
    func getFirst100Checkins(completionHandlerForGetCheckins: (userCheckins: [UserCheckin]!, errorString: String?) -> Void){
        
        let url = ParseConstants.LocationsUrl + ParseConstants.LocationsLimitCount
        let headers = ["X-Parse-Application-Id": ParseConstants.ApplicationId,
                       "X-Parse-REST-API-Key": ParseConstants.ClientKey]
        
        taskForPOSTMethod(url, httpMethod: nil, httpBody: nil, headers: headers, subsetResponseData: false) { (result, error) in
            
            if (error != nil) {
                completionHandlerForGetCheckins(userCheckins: nil, errorString: error?.localizedDescription)
            } else {
                
                if let results = result[ResponseKeys.Results] as? [[String:AnyObject]] {
                    UserCheckinsStorage.instance.userCheckins = UserCheckin.userCheckinsFromResults(results)
                    completionHandlerForGetCheckins(userCheckins: UserCheckinsStorage.instance.userCheckins, errorString: nil)
                } else {
                    completionHandlerForGetCheckins(userCheckins: nil, errorString: "Cannot parse list of checkins")
                }
            }
        }
    }
    
    func postUserLocation(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPostingUserLocation: (userCheckin: UserCheckin!, errorString: String?) -> Void){
        
        let httpMethod = "POST"
        let headers = ["X-Parse-Application-Id": ParseConstants.ApplicationId,
                       "X-Parse-REST-API-Key": ParseConstants.ClientKey,
                       "Content-Type": "application/json"]
        
        var body = [String:AnyObject]()
        body[RequestKeys.UniqueKey] = userId
        body[RequestKeys.FirstName] = self.user![ResponseKeys.FirstName]
        body[RequestKeys.LastName] = self.user![ResponseKeys.LastName]
        body[RequestKeys.MapString] = mapString
        body[RequestKeys.MediaURL] = mediaUrl
        body[RequestKeys.Latitude] = latitude
        body[RequestKeys.Longitude] = longitude
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        
        taskForPOSTMethod(ParseConstants.LocationsUrl, httpMethod: httpMethod, httpBody: jsonString, headers: headers, subsetResponseData: false) { (result, error) in
            
            if let error = error {
                completionHandlerForPostingUserLocation(userCheckin: nil, errorString: error.localizedDescription)
            } else {
                let userPost = UserPost.userPostFromResult((result as? [String:AnyObject])!)
                    
                if (userPost.objectId != nil) {
                        
                    let userCheckin = UserCheckin(firstName: self.user![ResponseKeys.FirstName] as! String,
                                                lastName: self.user![ResponseKeys.LastName] as! String,
                                                latitude: latitude,
                                                longitude: longitude,
                                                mediaURL: mediaUrl,
                                                isUsersPost: true)
                        
                    UserCheckinsStorage.instance.userCheckins.insert(userCheckin, atIndex: 0)
                        
                    completionHandlerForPostingUserLocation(userCheckin: userCheckin, errorString: nil)
                }else{
                    completionHandlerForPostingUserLocation(userCheckin: nil, errorString: "Failed to post user location")
                }
            }
        }
    }
    
    func logout(completionHandlerForLogout: (error: NSError?) -> Void){
        let httpMethod = "DELETE"

        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        var headers: NSDictionary!
        if let xsrfCookie = xsrfCookie {
            headers = [xsrfCookie.value: "X-XSRF-TOKEN"]
        }
        
        taskForPOSTMethod(UdacityConstants.SessionUrl, httpMethod: httpMethod, httpBody: nil, headers: nil, subsetResponseData: false) { (result, error) in
            completionHandlerForLogout(error: error)
        }
    }
}