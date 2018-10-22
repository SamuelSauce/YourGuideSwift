//
//  GuideViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 10/21/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse
class GuideViewController: UIViewController {

    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var guidePicture: UIImageView!
    @IBOutlet weak var guideBio: UITextView!
    @IBOutlet weak var guideRating: UIButton!
    @IBOutlet weak var whiteBackground: UIImageView!
    @IBAction func declineButton(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "defaultRoot") as! UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guidePicture.layer.cornerRadius = guidePicture.frame.size.width/2
        guidePicture.clipsToBounds = true
        
        whiteBackground.layer.cornerRadius = whiteBackground.frame.size.width/2
        whiteBackground.clipsToBounds = true
        whiteBackground.layer.backgroundColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "UserSettings")
        
        query.whereKey("username", equalTo: username)
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let changedSettings = objects {
                
                for object in changedSettings {
                    
                    if let changeSettings = object as? PFObject {
                        
                        
                        var guideText = (changeSettings["first"] as! String)
                        guideText.append(" will be your guide!")
                        self.guideLabel.text = guideText
                        
                        var userRating = changeSettings["rating"] as! NSNumber
                        //self.rating.setTitle("\(userRating)" as! String, for: [])
                        
                        var bioText = "About "
                        bioText.append(changeSettings["first"] as! String)
                        bioText.append(": ")
                        bioText.append(changeSettings["bio"] as! String)
                        self.guideBio.text = bioText
                        //RETRIEVES IMAGE FROM PARSE
                        let profileImage = changeSettings.object(forKey: "imageFile") as? PFFile
                        
                        profileImage!.getDataInBackground({ (data, error) in
                            
                            if let imageData = data {
                                let downloadedImage = UIImage(data: imageData)!
                                self.guidePicture.image = downloadedImage
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
                
                
            }
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
