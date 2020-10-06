//
//  NewMatchCollectionView.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 05/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//


import UIKit

class NewMatchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    
  //OUTLETS
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func awakeFromNib() {
        
        hideActivityIndicator()
    }
    
    
    func setupCell(avatarLink: String) {
        
        showActivityIndicator()
        
        self.avatarImageView.image = UIImage(named: "avatar")
        
        FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
            self.hideActivityIndicator()
            self.avatarImageView.image = avatarImage?.circleMasked
        }
    }
    
    
    private func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    
    
}
