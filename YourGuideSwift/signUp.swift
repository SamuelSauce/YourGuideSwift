//
//  LoginVC.swift
//  Second Flock Mobile App
//
//  Created by Finn Wolff on 2/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class signUp: UIViewController {
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUp: UIButton!

    //Alert Method
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func userSignUp(_ sender: Any) {
        //USE CATCH FUNCTION TO STOP APP FROM CRASHING
        if emailTextField.text == "" || passwordTextField.text == "" || usernameTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //Sign Up
            
            //NEED TO SET PARAMETERS FOR MINIMUM USERNAME AND PASSWORD LENGTH
            
            let user = PFUser()
            
            user.email = emailTextField.text
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            
            user.signUpInBackground(block: { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    if let error = error as NSError? {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        if let errorMessage = error.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                        
                    }
                    
                    
                } else {
                    
                    
                    print("User signed up")
                    
                    
                    self.performSegue(withIdentifier: "signUpToMap", sender: self)
                    
                }
                
            })
            
            
        }
        
    }
    
    
    @IBAction func toLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    

    
    
    
    //VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        
        /*if PFUser.current() != nil {
         
         self.performSegue(withIdentifier: "goToFeed", sender: self)
         
         } */
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        //used later to style login text boxes
        
        /*
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        */
        
    }
    
    
    //Keyboard Close Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



