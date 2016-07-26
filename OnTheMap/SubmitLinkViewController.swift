//
//  SubmitLinkViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 25/07/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SubmitLinkViewController:UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var linkTextView: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var delegate:EnterLinkDelegate?
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        let colorTop = UIColor(red:0.15, green:0.45, blue:0.85, alpha:1.0).CGColor
        let colorBottom = UIColor(red:0.16, green:0.38, blue:0.64, alpha:1.0).CGColor
        styleButton(submitButton, colorTop: colorTop, colorBottom: colorBottom)
        
        linkTextView.delegate = self
        if linkTextView.text!.isEmpty{
            submitButton.userInteractionEnabled = false
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SubmitLinkViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(gesture)
        
        _ = UITapGestureRecognizer(target: self, action: #selector(SubmitLinkViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(gesture)
        
        linkTextView.delegate = self
    }
    
    @IBAction func submit(sender: AnyObject) {
        self.delegate?.submitLinkViewControllerDidEnterLink(self, linkText: linkTextView.text!, coordinate: coordinate)
    }
    
    func updateMapLayout(placemark: MKPlacemark){
        coordinate = CLLocationCoordinate2D(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        submitButton.userInteractionEnabled = !text.isEmpty
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

extension FindLocationViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.blueColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}

protocol EnterLinkDelegate {
    func submitLinkViewControllerDidEnterLink(childViewController:SubmitLinkViewController, linkText: String, coordinate: CLLocationCoordinate2D)
}