//
//  LikeTableViewCell.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 05/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//


import UIKit

class LikeTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
//OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell(user: FirebaseUser) {
        nameLabel.text = user.fullName
        setAvatar(avatarLink: user.avatarLink)
    }
    
    
    private func setAvatar(avatarLink: String) {
        
        FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
            self.avatarImageView.image = avatarImage?.circleMasked
        }
    }
}
