//
//  MatchViewController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 05/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//


import UIKit


protocol MatchViewControllerDelegate {
    func didClickSendMessage(to user: FirebaseUser)
    func didClickKeepSwiping()
}

class MatchViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var cardBackgroundView: UIView!
    
    @IBOutlet weak var starView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
   

    //MARK: - Vars
    var user: FirebaseUser?
    var delegate: MatchViewControllerDelegate?

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        if user != nil {
            presentUserData()
        }
    }
    
    
    //MARK: - IBActions
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        delegate?.didClickSendMessage(to: user!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func keepSwipingButtonPressed(_ sender: Any) {
        delegate?.didClickKeepSwiping()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Setup
    private func setupUI() {
        
        cardBackgroundView.layer.cornerRadius = 10
        starView.layer.cornerRadius = 10
        starView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cardBackgroundView.applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
    }

    
    private func presentUserData() {
        
        avatarImageView.image = user!.avatar?.circleMasked
        let cityCountry = user!.country
        let nameAge = user!.fullName + ", \(abs(user!.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        nameAgeLabel.text = nameAge
        cityCountryLabel.text = cityCountry
    }
    
}
