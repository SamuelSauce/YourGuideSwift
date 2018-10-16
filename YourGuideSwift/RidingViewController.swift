//
//  RidingViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 9/17/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse
class RidingViewController: UIViewController {

    @IBOutlet weak var endRide: UIButton!
    @IBAction func endRide(_ sender: Any) {
        PFUser.current()!["isGuiding"] = false
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "defaultRoot") as! UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
