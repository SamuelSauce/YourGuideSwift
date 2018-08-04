//
//  SecondViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 6/30/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class Profile: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var whiteBorder: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var bioTextField: UITextView!
    
    
    @IBOutlet weak var backToMap: UIBarButtonItem!
    
    //var profileImage = [PFFile]()
    
    var inSettings: Bool!
    
    @IBAction func toSettings(_ sender: Any) {
        
        inSettings = true
        performSegue(withIdentifier: "toSettings", sender: self)
        
    }
    
    //back button to Map
    @IBAction func goBackToMap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "backToMap", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inSettings = false
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"profile edit"), style: .plain, target: self, action: nil)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        whiteBorder.layer.cornerRadius = whiteBorder.frame.size.width/2
        whiteBorder.clipsToBounds = true
        whiteBorder.layer.backgroundColor = UIColor.white.cgColor
        
                
        
        let query = PFQuery(className: "UserSettings")
        
        query.whereKey("userid", equalTo: PFUser.current()?.objectId)
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let changedSettings = objects {
                
                for object in changedSettings {
                    
                    if let changeSettings = object as? PFObject {
                        
                        
                        self.name.text = (changeSettings["first"] as! String)
                        
                        self.navigationItem.title = self.name.text
                        
                        self.bioTextField.text = (changeSettings["bio"] as! String)
                        
                        self.locationLabel.text = (changeSettings["location"] as! String)
                        
                        self.experienceLabel.text = (changeSettings["experienceLevel"] as! String)
                        
                        var userRating = changeSettings["rating"] as! NSNumber
                        
                        self.rating.setTitle("\(userRating)" as! String, for: [])
                        
                        //RETRIEVES IMAGE FROM PARSE
                        let profileImage = changeSettings.object(forKey: "imageFile") as? PFFile
                        
                        profileImage!.getDataInBackground({ (data, error) in
                            
                            if let imageData = data {
                                let downloadedImage = UIImage(data: imageData)!
                                self.profileImage.image = downloadedImage
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
                
                
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inSettings = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(inSettings == false){
            self.navigationController?.navigationBar.isHidden = true
        }
       
        
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


}

