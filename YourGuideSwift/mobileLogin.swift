//
//  mobileLogin.swift
//  YourGuideSwift
//
//  Created by Finn Wolff on 7/14/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class mobileLogin: UIViewController {

    @IBOutlet weak var mobileNumber: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func nextStep(_ sender: Any) {
        
        var number = mobileNumber.text
        
        if mobileNumber.text == ""  {
            
            errorLabel.alpha = 1
            
            } else if (number?.characters.count)! < 10 {
            
            errorLabel.text = "Phone number isn't long enough"
            errorLabel.alpha = 1
        }
        
        else {
        
        var user = PFUser.query()
        user?.whereKey("username", equalTo: mobileNumber.text)
        user?.findObjectsInBackground { (objects, error) in
            if let object = objects {
                
                if object.count > 0 {
                    
                    self.performSegue(withIdentifier: "accountExists", sender: self)
                    
                } else {
                    
                    self.performSegue(withIdentifier: "newAccount", sender: self)
                    
                }
        
                }
                
                
            }
            
        }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountExists" {
            
            let vc = segue.destination as! signIn
            
            vc.phone = mobileNumber.text!
            
        }
        
        else if segue.identifier == "newAccount" {
            
            let vc = segue.destination as! createPassword
            vc.phone = mobileNumber.text!
        }
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        mobileNumber.setBottomBorder()

        // Do any additional setup after loading the view.
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

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
