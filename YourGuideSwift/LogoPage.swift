//
//  ViewController.swift
//  Flock Mobile Application
//
//  Created by Finn Wolff on 1/26/17.
//  Copyright © 2017 FTW co. All rights reserved.
//

import UIKit
import Parse


class LogoPage: UIViewController {
    
    //TIMER
    var timer = Timer()
    
    
    @objc func toLogin() {
        
        performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    @objc func toMap () {
        
        performSegue(withIdentifier: "toXalted", sender: self)
        
    }
    
    
    
    //VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        
        var user = PFUser.current()
        
        if user == nil {
            
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(LogoPage.toLogin), userInfo: nil, repeats: false)
        }
        
        if user != nil {
            
           self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(LogoPage.toMap), userInfo: nil, repeats: false)
                    
            
            
        }
        
    }
    
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

