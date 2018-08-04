//
//  createPassword.swift
//  YourGuideSwift
//
//  Created by Finn Wolff on 7/14/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class SignUpAbout: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var experienceLevel: UITextField!
    @IBOutlet weak var userBio: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    
    
        
    @IBAction func signUp(_ sender: Any) {
    
        if experienceLevel.text == "" || userBio.text == "" {
            
            errorLabel.text = "Please fill out all the fields"
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
            
            let changeSettings = PFQuery(className: "UserSettings")
            
            changeSettings.whereKey("userid", equalTo: PFUser.current()?.objectId)
            
            changeSettings.findObjectsInBackground { (objects, error) in
                if let mySettings = objects {
                    
                    for object in mySettings {
                        
                        object.setValue(self.experienceLevel.text, forKey: "experienceLevel")
                        
                        object.setValue(self.userBio.text, forKey: "bio")
                        
                        object.saveInBackground()
                    }
                }
                
                
            }
            
            
            performSegue(withIdentifier: "setupComplete", sender: self)
            
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
    
        performSegue(withIdentifier: "backToCreateName", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0

        experienceLevel.setBottomBorder()
        
    }
    
    //Keyboard Close Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("editing bio")
        textView.text = ""
        textView.textColor = UIColor.white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Help us get to know you!"
            textView.textColor = UIColor.lightGray
        }
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
