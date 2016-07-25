//
//  FindOnMapViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 25/07/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class FindOnMapViewController: UIViewController{

    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBAction func findonMapAction(sender: AnyObject) {
        print("OKOKOK");
    }
    
    override func viewDidLoad() {
        styleButton(findOnMapButton)
    }

    private func styleButton(uiButton: UIButton){
        uiButton.tintColor = UIColor.whiteColor()
        
        let colorTop = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0).CGColor
        let colorBottom = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).CGColor
        
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.frame.size = uiButton.frame.size
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        
        backgroundGradient.cornerRadius = 3
        uiButton.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}