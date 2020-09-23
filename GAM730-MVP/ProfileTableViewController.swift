//
//  ProfileTableViewController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 21/09/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    
    // IBOutlets
    
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var profileCellBackgroundView: UIView!
    
    @IBOutlet weak var aboutMeView: UIView!
    
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var cityCountryLabel: UILabel!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var jobTextField: UITextField!
    
    @IBOutlet weak var professionTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var lookingForTextField: UITextField!
    
    // vars
    
    var editingMode = false
    
    
    // View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        setupBackgrounds()
        
        if  FirebaseUser.currentUser() != nil {
            loadUserData()
            updateEditingMode()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
  
    // IBActions
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showEditOptions()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        showPictureOptions()
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        editingMode.toggle()
        updateEditingMode()
        
        // if else
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    
    @objc func editUserData() {
        
        
        
    }
    
    
    // Setup
    private func setupBackgrounds() {
        
        profileCellBackgroundView.clipsToBounds = true
        // curve the corners
        profileCellBackgroundView.layer.cornerRadius = 100
        
        profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        aboutMeView.layer.cornerRadius = 10
        
     
    }
    
    private func showSaveButton () {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    // MARK:- LoadUserData
    
    private func loadUserData() {
       
        let currentUser = FirebaseUser.currentUser()!
        
        nameAgeLabel.text = currentUser.fullName + ", \(abs(currentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        cityCountryLabel.text = currentUser.country
        aboutMeTextView.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
        jobTextField.text = currentUser.profession
        professionTextField.text = currentUser.profession
        // fix gender issues 3 options not two
        genderTextField.text = currentUser.isMan ? "Male" : "Female"
        countryTextField.text = currentUser.country
        lookingForTextField.text = currentUser.lookingFor
        
        
        
        // changed the below from avatarImageView to avatarImage due to an error
        avatarImage.image = UIImage(named: "avatar")
        
        // TO DO SEE POSTIT NOTE IN PINK 34 and maybe 35
        
    }
    
    // Editing Mode
    
    private func updateEditingMode() {
        
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
        
    }

    // Helpers
    private func showKeyboard() {
        self.aboutMeTextView.becomeFirstResponder()
    }
    
    private func hideKeyboard() {
        
        self.view.endEditing(false)
    }
    
    
    // Alert Controller
    
    private func showPictureOptions() {
        
        let alertController = UIAlertController(title: "Upload Picture", message: "You can change your picture", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            
            print("changing the picture options is working")
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
                 
                 print("uploading the picture options is working")
                 
                 
             }))
             
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func showEditOptions() {
        
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to edit your account info.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            
        
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (alert) in
                 
           print("Change name is working")
                 
                 
             }))
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (alert) in
                       
                       
                       
                       
                   }))
                   
             
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}
