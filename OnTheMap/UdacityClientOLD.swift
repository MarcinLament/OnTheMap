//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Marcin Lament on 05/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

class UdacityClientOLD : NSObject {
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    var userId: String? = nil
    var user: NSDictionary? = nil
    var userCheckins = [UserCheckin]()
    
    func login(username: String, password: String, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void){
        
        let httpBody = String("{\"udacity\": {\"username\": \""+username+"\", \"password\": \""+password+"\"}}");
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            
            var parsedResult: NSDictionary!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                self.userId = (parsedResult["account"] as! NSDictionary)["key"] as? String
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            }
            
            if(self.userId != nil){
                self.getUserDetails(completionHandlerForConvertData);
//                completionHandlerForConvertData(result: self.userId, error: nil)
            }else{
                let userInfo = [NSLocalizedDescriptionKey : "User ID is empty"]
                completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            }
//            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForConvertData)
            
        }
        task.resume()
    }
    
    func getUserDetails(completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void){
        print(self.userId)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + String(self.userId!))!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            var parsedResult: NSDictionary!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                
                if let obj = parsedResult!["user"] {
                    print("OK")
                    self.user = obj as? NSDictionary
                    if(self.user!["first_name"] != nil && self.user!["last_name"] != nil){
                        completionHandlerForConvertData(result: self.user, error: nil)
                    }else{
                        let userInfo = [NSLocalizedDescriptionKey : "User is empty"]
                        completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
                    }

                } else {
                    print("BAD")
                }
                
//                let obj = parsedResult!["user"]! as? NSDictionary
//                print(obj)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            }
            
                    }
        task.resume()
    }
    
    func getFirst100Checkins(completionHandlerForGetCheckins: (result: [UserCheckin]!, error: NSError?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey : "Cannot get users checkins"]
                completionHandlerForGetCheckins(result: nil, error: NSError(domain: "completionHandlerForGetCheckins", code: 1, userInfo: userInfo))
                return
            }
            
            var results: AnyObject!
            do {
                results = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForGetCheckins(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            }
            
            if let results = results["results"] as? [[String:AnyObject]] {
                
                self.userCheckins = UserCheckin.userCheckinsFromResults(results)
//                print(checkins)
                
                completionHandlerForGetCheckins(result: self.userCheckins, error: nil)
            } else {
                completionHandlerForGetCheckins(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
            }
            
            
            
        }
        task.resume()
        
    }
    
    func postUserLocation(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPostingUserLocation: (result: UserCheckin!, error: NSError?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body = [String:AnyObject]()
        body["uniqueKey"] = userId
        body["firstName"] = self.user!["first_name"]
        body["lastName"] = self.user!["last_name"]
        body["mapString"] = mapString
        body["mediaURL"] = mediaUrl
        body["latitude"] = latitude
        body["longitude"] = longitude
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String

        print(jsonString)
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandlerForPostingUserLocation(result: nil, error: NSError(domain: "completionHandlerForPostingUserLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Posting User Location response"]))
                return
            }
            
            do {
                let results = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                let userPost = UserPost.userPostFromResult((results as? [String:AnyObject])!)
                
                if (userPost.objectId != nil) {
                
                    let userCheckin = UserCheckin(firstName: self.user!["first_name"] as! String,
                                                  lastName: self.user!["last_name"] as! String,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  mediaURL: mediaUrl,
                                                  isUsersPost: true)
                    
                    self.userCheckins.insert(userCheckin, atIndex: 0)
                    
                    completionHandlerForPostingUserLocation(result: userCheckin, error: nil)
                }else{
                    let userInfo = [NSLocalizedDescriptionKey : "Failed to post user location"]
                    completionHandlerForPostingUserLocation(result: nil, error: NSError(domain: "completionHandlerForPostingUserLocation", code: 1, userInfo: userInfo))
                }
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForPostingUserLocation(result: nil, error: NSError(domain: "completionHandlerForPostingUserLocation", code: 1, userInfo: userInfo))
            }
            
            
        }
        task.resume()
    }
    
    func logout(completionHandlerForLogout: (error: NSError?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
//            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            completionHandlerForLogout(error: nil)
        }
        task.resume()
    }
    
    // given raw JSON, return a usable Foundation object
//    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: NSDictionary!, error: NSError?) -> Void) {
//        
//        var parsedResult: NSDictionary!
//        do {
//            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
//        } catch {
//            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
//            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
//        }
//        
//        completionHandlerForConvertData(result: parsedResult, error: nil)
//    }
    
    
    class func sharedInstance() -> UdacityClientOLD {
        struct Singleton {
            static var sharedInstance = UdacityClientOLD()
        }
        return Singleton.sharedInstance
    }
}