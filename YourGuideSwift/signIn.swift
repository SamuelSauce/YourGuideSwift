//
//  signIn.swift
//  YourGuideSwift
//
//  Created by Finn Wolff on 7/14/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class signIn: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var phone = ""
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func forgotPass(_ sender: Any) {
        //in the ["email":"samuelfbridge@gmail.com"], just replace my email with the current users email and it should work.
        PFCloud.callFunction(inBackground: "passReset", withParameters: ["email":"samuelfbridge@gmail.com"]) { (response, error) in
            if let error = error {
                //If it fails, maybe display a message with code inside here
                print(error.localizedDescription)
            } else {
                //else it was successful, maybe display "success, email sent" on screen here.
                let responseString = response as? String
                print(responseString)
            }
            
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        //USE CATCH FUNCTION TO STOP APP FROM CRASHING
        if passwordTextField.text == ""  {
            
            errorLabel.alpha = 1
            errorLabel.text = "Please try again"
            
        } else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            var user = PFUser.query()
            
            user?.whereKey("username", equalTo: phone)
            
            user?.findObjectsInBackground(block: { (objects, error) -> Void in
                
                if let bool = objects {
                    
                    for object in bool {
                    
                            
                        PFUser.logInWithUsername(inBackground: self.phone, password: self.passwordTextField.text!, block: { (user, error) in
                                
                        self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                                
                        if error != nil {
                                    
                            if let error = error as NSError? {
                                        
                                        
                                    var displayErrorMessage = "Please try again later."
                                        
                                        if let errorMessage = error.userInfo["error"] as? String {
                                            
                                            displayErrorMessage = errorMessage
                                            
                                        }
                                        
                                self.errorLabel.text = displayErrorMessage
                                        
                                    }
                                    
                                } else {
                            
                                    print("Logged In")
                                    
                                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                                    
                                }
                                
                                
                            })
                            
                            
                       
                    }
                }
                
            })
            
            
            self.activityIndicator.stopAnimating()
        }
        
    }
        
    
    

    @IBAction func back(_ sender: Any) {
        
        performSegue(withIdentifier: "backToMobileLogin", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.setBottomBorder()
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
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
