//
//  ViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 05/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews();
        
        emailAddress.delegate = self
        password.delegate = self
        if emailAddress.text!.isEmpty || password.text!.isEmpty{
            loginButton.userInteractionEnabled = false
        }
    }
    
    @IBAction func loginUser(sender: AnyObject) {

        OTMClient.sharedInstance().login(emailAddress.text!, password: password.text!) { (success, errorString) in
            performUIUpdatesOnMain {
                if (success) {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    func completeLogin(){
        let controller = storyboard!.instantiateViewControllerWithIdentifier("LocationsNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func styleViews(){
        configureBackground()
        styleTextField(emailAddress)
        emailAddress.placeholder = "Email address"
        styleTextField(password)
        password.placeholder = "Password"
        
        let colorTop = UIColor(red:0.13, green:0.65, blue:0.94, alpha:1.0).CGColor
        let colorBottom = UIColor(red:0.19, green:0.56, blue:0.78, alpha:1.0).CGColor
        styleButton(loginButton, colorTop: colorTop, colorBottom: colorBottom)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        loginButton.userInteractionEnabled = !(emailAddress.text!.isEmpty || password.text!.isEmpty)
        return true
    }
}

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func displayError(errorString: String?) {
        showAlert("Error", message: errorString!, completion: nil)
    }
    
    private func styleTextField(textField: UITextField){
        textField.layer.backgroundColor = UIColor(red:0.98, green:0.72, blue:0.45, alpha:1.0).CGColor
        textField.layer.borderColor = UIColor(red:1.00, green:0.89, blue:0.77, alpha:0.5).CGColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textColor = UIColor(red:0.82, green:0.41, blue:0.07, alpha:1.0)
    }
    
    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red:1.00, green:0.65, blue:0.00, alpha:1.0).CGColor
        let colorBottom = UIColor(red:0.98, green:0.42, blue:0.00, alpha:1.0).CGColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}

