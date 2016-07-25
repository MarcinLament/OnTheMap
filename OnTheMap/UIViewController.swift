//
//  UIViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 04/06/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    public func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: completion))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    public func styleButton(uiButton: UIButton, colorTop: CGColor, colorBottom: CGColor){
        uiButton.tintColor = UIColor.whiteColor()
        
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.frame.size = uiButton.frame.size
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        
        backgroundGradient.cornerRadius = 3
        uiButton.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}