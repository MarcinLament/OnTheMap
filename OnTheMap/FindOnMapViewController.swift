//
//  FindOnMapViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 25/07/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class FindOnMapViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextView: UITextField!
    
    var delegate:EnterLocationDelegate?
    
    @IBAction func findonMapAction(sender: AnyObject) {
        self.delegate?.findOnMapViewControllerDidEnterLocation(self, queryText: locationTextView.text!)
    }
    
    override func viewDidLoad() {
        let colorTop = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0).CGColor
        let colorBottom = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).CGColor
        styleButton(findOnMapButton, colorTop: colorTop, colorBottom: colorBottom)
        
        locationTextView.delegate = self
        if locationTextView.text!.isEmpty{
            findOnMapButton.userInteractionEnabled = false
        }

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        findOnMapButton.userInteractionEnabled = !text.isEmpty
        return true
    }
}

protocol EnterLocationDelegate {
    func findOnMapViewControllerDidEnterLocation(childViewController:FindOnMapViewController, queryText: String)
}