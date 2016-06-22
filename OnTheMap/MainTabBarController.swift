//
//  MinTabBarControll.swift
//  OnTheMap
//
//  Created by Marcin Lament on 14/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController{
    
    
    
    override func viewDidLoad() {
        loadData()
    }
    
    @IBAction func logout(sender: AnyObject) {
        OTMClient.sharedInstance().logout { (error) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func checkIn(sender: AnyObject) {
//        UdacityClient.sharedInstance().getUserLocation(UdacityClient.sharedInstance().userId!)
        let controller = storyboard!.instantiateViewControllerWithIdentifier("CheckinNavigationController") as! UINavigationController
        presentViewController(controller, animated: true){
            print("OHOHOHOHOHOH")
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        loadData()
    }
    
    func loadData(){
        OTMClient.sharedInstance().getFirst100Checkins(){ (success, error) in
            performUIUpdatesOnMain {
                if (success != nil) {
                    print("Loaded!!!")
                    if(self.selectedIndex == 0){
                        (self.selectedViewController as! MapViewController).refresh()
                    }else{
                        (self.selectedViewController as! ListViewController).refresh()
                    }
                } else {
                    print("Loading error!!!")
                    //                    self.displayError(errorString)
                }
            }
        }

    }
}