//
//  locationViewController.swift
//  YourGuideSwift
//
//  Created by Samuel Bridge on 8/12/18.
//  Copyright © 2018 Samuel Bridge. All rights reserved.
//

import UIKit
import Parse

class locationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var current = "Alta"
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        current = titles[row]
        print(current)
    }
        let titles = ["Alta", "Snowbird", "Brighton", "Solitude", "Park City Mountain Resort", "Deer Valley", "Snowbasin", "Jackson Hole Ski Area", "Sun Valley", "Aspen Highlands Ski Resort", "Breckenridge", "Steamboat", "Telluride", "Keystone", "Mammoth", "Bear Mountain Ski Resort", "Squaw Valley"]
    
    @IBOutlet weak var locationPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func done(_ sender: Any) {
        //Should be able to just do
        //user = PFUser.current()?
        var user = PFUser.query()
        
        user?.whereKey("username", equalTo: PFUser.current()?.username)
        
        user?.findObjectsInBackground(block: { (objects, error) in
            
            if let persons = objects {
                
                for object in persons {
                    
                    if let person = object as? PFObject {
                        
                        person.setValue(self.current, forKey: "resort")
                        person.saveInBackground()
                        
                    }
                    
                }
                
                
            }
            
        })
        
        self.dismiss(animated: true, completion: nil)
        
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
