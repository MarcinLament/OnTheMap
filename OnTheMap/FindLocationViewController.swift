//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 14/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FindLocationViewController: UIViewController, EnterLocationDelegate, EnterLinkDelegate{
    
    struct Constants{
        static let findOnMapSegue = "FindOnMapSegue"
        static let submitLinkSegue = "SubmitLinkSegue"
    }
    
    @IBOutlet weak var findOnMapContainer: UIView!
    @IBOutlet weak var addLinkContainer: UIView!
    
    var locationString: String?;
    
    var findOnMapViewController: FindOnMapViewController?;
    var submitLinkViewController: SubmitLinkViewController?;
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        addLinkContainer.hidden = true;
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar?.shadowImage = UIImage()
    }
    
    func submit(linkText: String, coordinate: CLLocationCoordinate2D) {
        OTMClient.sharedInstance().postUserLocation(locationString!, mediaUrl: linkText, latitude: coordinate.latitude, longitude: coordinate.longitude){ (success, error) in
            performUIUpdatesOnMain {
                if (success != nil) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    self.showAlert("Error", message: error!, completion: nil)
                }
            }
        }
    }
    
    func findOnMapViewControllerDidEnterLocation(childViewController: FindOnMapViewController, queryText: String, placemark: MKPlacemark) {
        findOnMapContainer.hidden = true;
        addLinkContainer.hidden = false;
        submitLinkViewController?.updateMapLayout(placemark)
        self.locationString = queryText
    }
    
    func submitLinkViewControllerDidEnterLink(childViewController:SubmitLinkViewController, linkText: String, coordinate: CLLocationCoordinate2D) {
        submit(linkText, coordinate: coordinate)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.findOnMapSegue {
            findOnMapViewController = segue.destinationViewController as? FindOnMapViewController
            findOnMapViewController!.delegate = self
        }else if segue.identifier == Constants.submitLinkSegue{
            submitLinkViewController = segue.destinationViewController as? SubmitLinkViewController
            submitLinkViewController!.delegate = self
        }
    }
}
