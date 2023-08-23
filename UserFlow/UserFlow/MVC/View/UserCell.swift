//
//  UserCell.swift
//  UserFlow
//
//  Created by Yogesh Patel on 20/11/21.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func userDetailConfiguration(user: User){
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(user.profileImageName ?? "").appendingPathExtension("png").path
        
        profileImageView.image = UIImage(contentsOfFile: path ?? "")
        firstnameLabel.text = user.firstname
        lastnameLabel.text = user.lastname
        emailLabel.text = user.email
    }
    
}
