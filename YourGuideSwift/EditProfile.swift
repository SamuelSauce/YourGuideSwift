//
//  EditProfile.swift
//  YourGuideSwift
//
//  Created by Finn Wolff on 7/28/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class EditProfile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var experienceLevel: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var userBio: UITextView!
    @IBOutlet weak var newProfilePic: UIImageView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var imageFiles = [PFFile]()
    
    @IBAction func chooseAnImage(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            newProfilePic.image = image
            let h = newProfilePic.frame.height / 2
            newProfilePic.layer.cornerRadius = h
            newProfilePic.layer.masksToBounds = true
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        performSegue(withIdentifier: "backToSettings", sender: self)
    }
    
    
    @IBAction func save(_ sender: Any) {
        
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
                    
                    object.setValue(self.first.text, forKey: "first")
                    
                    object.setValue(self.last.text, forKey: "last")
                    
                    object.setValue(self.experienceLevel.text, forKey: "experienceLevel")
                    
                    object.setValue(self.location.text, forKey: "location")
                    
                    object.setValue(self.userBio.text, forKey: "bio")
                    
                    let imageData = UIImageJPEGRepresentation(self.newProfilePic.image!, 1)
                    
                    let imageFile = PFFile(name: "image.png", data: imageData!)
                    
                    object.setValue(imageFile, forKey: "imageFile")
                    
                    object.saveInBackground()
                    
                    imageFile?.saveInBackground { (success, error) in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if error != nil {
                            
                            self.createAlert(title: "Could not update profile", message: "There was a problem updating your profile")
                            
                        } else {
                            
                            self.createAlert(title: "Profile Updated", message: "Profile details successfully updated")
                            
                            
                        }
                        
                    }
                    self.performSegue(withIdentifier: "backToSettings", sender: self)

                    
                }
            }
            
    }
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        let query = PFQuery(className: "UserSettings")
        
        query.whereKey("userid", equalTo: PFUser.current()?.objectId)
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let changedSettings = objects {
                
                for object in changedSettings {
                    
                    if let changeSettings = object as? PFObject {
                        
                        self.imageFiles.append(changeSettings["imageFile"] as! PFFile)
                        
                        self.first.text = (changeSettings["first"] as! String)
                        
                        self.last.text = (changeSettings["last"] as! String)
                        
                        self.experienceLevel.text = (changeSettings["experienceLevel"] as! String)
                        
                        self.location.text = (changeSettings["location"] as! String)
                        
                        self.userBio.text = (changeSettings["bio"] as! String)
                        
                        //RETRIEVES IMAGE FROM PARSE
                        let profileImage = changeSettings.object(forKey: "imageFile") as? PFFile
                        
                        profileImage!.getDataInBackground({ (data, error) in
                            
                            if let imageData = data {
                                let downloadedImage = UIImage(data: imageData)!
                                self.newProfilePic.image = downloadedImage
                                let h = self.newProfilePic.frame.height / 2
                                self.newProfilePic.layer.cornerRadius = h
                                self.newProfilePic.layer.masksToBounds = true
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
                
                
            }
            
        })


        // Do any additional setup after loading the view.
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
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Introduce yourself to your guide"
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
