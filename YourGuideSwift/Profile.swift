//
//  SecondViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 6/30/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit

class Profile: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var whiteBorder: UIImageView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var resortLabel: UILabel!
    
    
    
    @IBAction func toSettings(_ sender: Any) {
        
        performSegue(withIdentifier: "ToSettings", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"profile edit"), style: .plain, target: self, action: nil)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        whiteBorder.layer.cornerRadius = whiteBorder.frame.size.width/2
        whiteBorder.clipsToBounds = true
        whiteBorder.layer.backgroundColor = UIColor.white.cgColor
        navigationItem.title = "Samuel Bridge"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

