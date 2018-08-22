//
//  createPassword.swift
//  YourGuideSwift
//
//  Created by Finn Wolff on 7/14/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class SignUpName: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var newProfilePic: UIImageView!
    
    var imageFiles = [PFFile]()
    
    var activityIndicator = UIActivityIndicatorView()

    
    @IBAction func chooseAnImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("setting corner radius")
            newProfilePic.image = image
            let h = newProfilePic.frame.height / 2
            newProfilePic.layer.cornerRadius = h
            newProfilePic.layer.masksToBounds = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func signUp(_ sender: Any) {
    
        if first.text == "" || last.text == "" || location.text == "" {
            
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
            
            let changeSettings = PFObject(className: "UserSettings")
            
            changeSettings["userid"] = PFUser.current()?.objectId
            
            changeSettings["username"] = PFUser.current()?.username
            
            changeSettings["first"] = first.text
            
            changeSettings["last"] = last.text
            
            changeSettings["location"] = location.text
            
            changeSettings["rating"] = 0
            
            changeSettings["guide"] = false
            //Crashes if user does not put a profile picture.
            let imageData = UIImageJPEGRepresentation(newProfilePic.image!, 1)
            
            let imageFile = PFFile(name: "image.png", data: imageData!)
            
            changeSettings["imageFile"] = imageFile
            
            imageFile?.saveInBackground { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    
                    
                } else {
                    
                    print("image uploaded")
                    
                }
                
            }
            
            changeSettings.saveInBackground { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    
                    
                } else {
                    
                    print("settings saved")
                    
                }
                
                
            }
            performSegue(withIdentifier: "createUserProfile", sender: self)
            
        }
    
    }
    
    @IBAction func back(_ sender: Any) {
        
        performSegue(withIdentifier: "backToUserAndPass", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
        first.setBottomBorder()
        last.setBottomBorder()
        location.setBottomBorder()
        
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
