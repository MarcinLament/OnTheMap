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

class FindLocationViewController: UIViewController{
    
    @IBOutlet weak var findLocationView: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnMapContainer: UIView!
    @IBOutlet weak var addLinkContainer: UIView!

    
    var coordinate: CLLocationCoordinate2D!
    
    @IBAction func cancelAction(sender: AnyObject) {
        if(findOnMapContainer.hidden){
            print("show map");
            findOnMapContainer.hidden = false;
            addLinkContainer.hidden = true;
        }else{
            print("hide map");
            findOnMapContainer.hidden = true;
            addLinkContainer.hidden = false;
        }
    }
    
    override func viewDidLoad() {
        findOnMapContainer.hidden = true;
        addLinkContainer.hidden = true;
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar?.shadowImage = UIImage()
        
//        styleButton(findOnMapButton)
//        findOnMapButton.backgroundColor = UIColor(red:0.15, green:0.45, blue:0.85, alpha:1.0)
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        findLocationView.endEditing(true)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = findLocationView.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            
            if(response.mapItems.count > 0){
                let placemark = response.mapItems[0].placemark;
                self.updateMapLayout(placemark)
            }
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        OTMClient.sharedInstance().postUserLocation(findLocationView.text!, mediaUrl: "http://example.com", latitude: coordinate.latitude, longitude: coordinate.longitude){ (success, error) in
            performUIUpdatesOnMain {
                if (success != nil) {
                    print("POSTED!!!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("Loading error!!!")
                }
            }
        }

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
