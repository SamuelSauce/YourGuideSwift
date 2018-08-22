//
//  RiderViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 8/21/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse
class RiderViewController: UIViewController {

    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var riderPicture: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    @IBAction func declineClicker(_ sender: Any) {
        PFUser.current()!["isGuiding"] = false
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "defaultRoot") as! UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "UserSettings")
        
        query.whereKey("userid", equalTo: username)
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let changedSettings = objects {
                
                for object in changedSettings {
                    
                    if let changeSettings = object as? PFObject {
                        
                        
                        self.riderLabel.text = (changeSettings["first"] as! String)
                        
                        var userRating = changeSettings["rating"] as! NSNumber
                        
                        //self.rating.setTitle("\(userRating)" as! String, for: [])
                        
                        //RETRIEVES IMAGE FROM PARSE
                        let profileImage = changeSettings.object(forKey: "imageFile") as? PFFile
                        
                        profileImage!.getDataInBackground({ (data, error) in
                            
                            if let imageData = data {
                                let downloadedImage = UIImage(data: imageData)!
                                self.riderPicture.image = downloadedImage
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
                
                
            }
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "UserSettings")
        
        query.whereKey("username", equalTo: username)
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let changedSettings = objects {
                
                for object in changedSettings {
                    
                    if let changeSettings = object as? PFObject {
                        
                        
                        self.riderLabel.text = (changeSettings["first"] as! String)
                        
                        var userRating = changeSettings["rating"] as! NSNumber
                        
                        //self.rating.setTitle("\(userRating)" as! String, for: [])
                        
                        //RETRIEVES IMAGE FROM PARSE
                        let profileImage = changeSettings.object(forKey: "imageFile") as? PFFile
                        
                        profileImage!.getDataInBackground({ (data, error) in
                            
                            if let imageData = data {
                                let downloadedImage = UIImage(data: imageData)!
                                self.riderPicture.image = downloadedImage
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
                
                
            }
            
        })
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
