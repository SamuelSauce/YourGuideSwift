//
//  LoginVC.swift
//  Second Flock Mobile App
//
//  Created by Finn Wolff on 2/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class Login: UIViewController {
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    //Alert Method
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        performSegue(withIdentifier: "backToSignUp", sender: self)
        
    }
    
    
    @IBAction func signupOrLogin(_ sender: AnyObject) {
        
        //USE CATCH FUNCTION TO STOP APP FROM CRASHING
        if  passwordTextField.text == "" || usernameTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter a username and password")
            
        } else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // Login Mode
            
            //Changes segmented index title based on user/brand
            var brandorUserQuery = PFUser.query()
            
            brandorUserQuery?.whereKey("username", equalTo: usernameTextField.text)
            
            brandorUserQuery?.findObjectsInBackground(block: { (objects, error) -> Void in
                
                if let bool = objects {
                    
                    for object in bool {
                        
                            
                            PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!, block: { (user, error) in
                                
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                if error != nil {
                                    
                                    if let error = error as NSError? {
                                        
                                        
                                        var displayErrorMessage = "Please try again later."
                                        
                                        if let errorMessage = error.userInfo["error"] as? String {
                                            
                                            displayErrorMessage = errorMessage
                                            
                                        }
                                        
                                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                                        
                                    }
                                    
                                } else {
                                    
                                    print("Logged In")
                                    
                                    self.performSegue(withIdentifier: "loginToMap", sender: self)
                                    
                                }
                                
                                
                            })
                            
                            
                        
                    }
                }
                
            })
            
            
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    
    @IBOutlet var signupOrLogin: UIButton!
    

    @IBOutlet var greetingLabel: UILabel!


    
    
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
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        tabBarController?.tabBar.barTintColor = UIColor.black
        
        backButton.setTitleColor(UIColor.red, for: [])
        
        
        /*
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        //usernameTextField.tintColor = UIColor.red
        //passwordTextField.tintColor = UIColor.red
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



