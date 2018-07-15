//
//  createPassword.swift
//  YourGuideSwift
//
//  Created by Finn Wolff on 7/14/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class createPassword: UIViewController {

    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var phone = ""
    
    @IBAction func signUp(_ sender: Any) {
        
        var number = passwordTextField.text
        
        if passwordTextField.text == "" || emailTextField.text == "" {
            
            errorLabel.text = "You need to enter an email and password"
            errorLabel.alpha = 1
            
        }
        
        else if (number?.characters.count)! < 6 {
            
            errorLabel.text = "Your password isn't long enough"
            errorLabel.alpha = 1
        }
        
        else {
            
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
            user.username = phone
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
                        
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = displayErrorMessage
                        
                    }
                    
                    
                } else {
                    
                    
                    print("User signed up")
                    
                    self.performSegue(withIdentifier: "createUserSettings", sender: self)

            
        }
        
    })
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        performSegue(withIdentifier: "backFromPassword", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
        passwordTextField.setBottomBorder()
        emailTextField.setBottomBorder()

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
