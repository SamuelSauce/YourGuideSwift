//
//  USERFollowers.swift
// XALTED
//
//  Created by Finn Wolff on 1/24/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class Settings: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsCellDelegate {
    
    
    func didTapSignOut(_ sender: SettingsCell) {
        if let tappedIndex = settingsTV.indexPath(for: sender) {
            
            PFUser.logOut()
            navigationController?.setNavigationBarHidden(true, animated: true)
            performSegue(withIdentifier: "backToLogin", sender: self)
            
            
        } else {
            return
        }
        
    }
    
    func didTapEditProfile(_ sender: SettingsCell) {
        if let tappedIndex = settingsTV.indexPath(for: sender) {
            
            performSegue(withIdentifier: "toEditProfile", sender: self)
            
            
        } else {
            return
        }
        
        
    }
    
   
        
    @IBAction func back(_ sender: Any) {
    
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBOutlet weak var settingsTV: UITableView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSettingsToProfile" {
            
            let vc = segue.destination as! Profile
            
        }
        else if segue.identifier == "toEditProfile" {
            
            let vc = segue.destination as! EditProfile
            
        }
            
        else if segue.identifier == "backToLogin" {
            
            let vc = segue.destination as! Login
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if let nav = self.navigationController?.navigationBar {
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingsTV.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        
        cell.delegate = self
        
        return cell
        
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
    
    //ORIGINAL FOLLOWER SYSTEM
    /*
     let query = PFUser.query()
     
     query?.findObjectsInBackground(block: { (objects, error) in
     
     if error != nil {
     print(error)
     
     } else if let users = objects {
     
     //self.usernames.removeAll()
     //self.userIDs.removeAll()
     //self.isFollowing.removeAll()
     
     for object in users {
     
     if let user = object as? PFUser {
     
     if user.objectId != PFUser.current()?.objectId {
     
     self.usernames.append(user.username!)
     self.userIDs.append(user.objectId!)
     
     let query = PFQuery(className: "Followers")
     
     
     
     query.whereKey("follower", equalTo: PFUser.current()?.objectId)
     query.whereKey("following", equalTo: user.objectId)
     
     query.findObjectsInBackground(block: { (objects, error) in
     
     if let objects = objects {
     
     if objects.count > 0 {
     
     self.isFollowing[user.objectId!] = true
     
     } else {
     
     self.isFollowing[user.objectId!] = false
     
     }
     
     if self.isFollowing.count == self.usernames.count {
     
     self.tableview.reloadData()
     
     self.refresher.endRefreshing()
     
     }
     
     }
     
     })
     
     
     }
     
     }
     
     }
     //self.refresher.endRefreshing()
     
     }
     
     
     })
     
     
     */
    
    
    
}

//Used for segueing to chosen brand profile
protocol SettingsCellDelegate: class {
    func didTapSignOut(_ sender: SettingsCell)
    func didTapEditProfile(_ sender: SettingsCell)
}

