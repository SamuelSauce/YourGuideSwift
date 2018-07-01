//
//  SecondViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 6/30/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit

class Profile: UIViewController, UINavigationControllerDelegate {

    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
       

        
        navigationItem.title = "Profile"
        
    }
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

