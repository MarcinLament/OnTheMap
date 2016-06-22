//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 14/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var userCheckins: [UserCheckin] {
        return OTMClient.sharedInstance().userCheckins
    }
    
    override func viewWillAppear(animated: Bool) {
        updateMapLayout()
    }
    
    func refresh(){
        updateMapLayout()
    }
    
    func updateMapLayout(){
        var annotations = [MKPointAnnotation]()
        for checkin in userCheckins {
            let coordinate = CLLocationCoordinate2D(latitude: checkin.latitude, longitude: checkin.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(checkin.firstName) \(checkin.lastName)"
            annotation.subtitle = checkin.mediaURL
            
            if(checkin.isUsersPost){
                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
                let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
                mapView.setRegion(region, animated: true)
            }
            
            annotations.append(annotation)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}