//
//  RestClient.swift
//  OnTheMap
//
//  Created by Marcin Lament on 04/06/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation

class OTMClient : NSObject {

    var session = NSURLSession.sharedSession()
    
    var userId: String? = nil
    var user: NSDictionary? = nil
    var userCheckins = [UserCheckin]()
    
    func taskForGETMethod(){
        
    }
    
    func taskForPOSTMethod(url: String, httpMethod: String?, httpBody: String?, headers: [String: String]?, subsetResponseData: Bool, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        if(httpMethod != nil){
            request.HTTPMethod = httpMethod!
        }
        if (httpBody != nil) {
            request.HTTPBody = httpBody!.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        if (headers != nil) {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if(subsetResponseData){
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            }else{
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            }
            
        }
        
        task.resume()
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        do {
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
            print(parsedResult)
            
            completionHandlerForConvertData(result: parsedResult, error: nil)
            //
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}