//
//  FindOnMapViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 25/07/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FindOnMapViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextView: UITextField!
    
    var delegate:EnterLocationDelegate?
    
    @IBAction func findonMapAction(sender: AnyObject) {
        findOnMap(locationTextView.text!)
    }
    
    override func viewDidLoad() {
        let colorTop = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0).CGColor
        let colorBottom = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).CGColor
        styleButton(findOnMapButton, colorTop: colorTop, colorBottom: colorBottom)
        
        locationTextView.delegate = self
        if locationTextView.text!.isEmpty{
            findOnMapButton.userInteractionEnabled = false
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(FindOnMapViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(gesture)
        
        locationTextView.delegate = self
    }
    
    func findOnMap(locationString: String){
        activityIndicator.startAnimating()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationString
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                self.showAlert("Error", message: "Problem getting locations. Please try again.", completion: nil)
                return
            }
            
            if(response.mapItems.count > 0){
                let placemark = response.mapItems[0].placemark;
                self.activityIndicator.stopAnimating()
                self.delegate?.findOnMapViewControllerDidEnterLocation(self, queryText: locationString, placemark: placemark)
            }else{
                self.showAlert("Error", message: "No locations found. Please try again.", completion: nil)
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        findOnMapButton.userInteractionEnabled = !text.isEmpty
        return true
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol EnterLocationDelegate {
    func findOnMapViewControllerDidEnterLocation(childViewController:FindOnMapViewController, queryText: String, placemark: MKPlacemark)
}