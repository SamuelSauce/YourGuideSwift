//
//  USERSettingsCell.swift
//  Second Flock Mobile App
//
//  Created by Finn Wolff on 4/29/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class SettingsCell: UITableViewCell {
    
    
   
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var paymentSettings: UIButton!
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var termsOfUse: UIButton!
    
    var delegate: SettingsCellDelegate?
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        delegate?.didTapSignOut(self)
    }
    
    
    @IBAction func editProfileTapped(_ sender: Any) {
        delegate?.didTapEditProfile(self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
