//
//  ProfileTableViewController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 21/09/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import UIKit
import Gallery
import ProgressHUD

class ProfileTableViewController: UITableViewController {
    
    
    // IBOutlets
    
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
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
    
    //MARK: - Vars
    var editingMode = false
    var uploadingAvatar = true
    
    var avatarImage: UIImage?
    var gallery: GalleryController!
    
    var alertTextField: UITextField!
    
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        
        setupBackgrounds()
        
        if FirebaseUser.currentUser() != nil {
            loadUserData()
            updateEditingMode()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    


    
    //MARK: - IBActions
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showEditOptions()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        showPictureOptions()
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editingMode.toggle()
        updateEditingMode()
        
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    
    @objc func editUserData() {
        
        let user = FirebaseUser.currentUser()!
        
        user.about = aboutMeTextView.text
        user.profession = jobTextField.text ?? ""
        user.profession = professionTextField.text ?? ""
        user.isMan = genderTextField.text == "Male"
    //    user.city = cityTextField.text ?? ""
        user.country = countryTextField.text ?? ""
        user.lookingFor = lookingForTextField.text ?? ""
  //      user.height = Double(heightTextField.text ?? "0") ?? 0.0
        
        if avatarImage != nil {

            uploadAvatar(avatarImage!) { (avatarLink) in
                
                user.avatarLink = avatarLink ?? ""
                user.avatar = self.avatarImage
                
                self.saveUserData(user: user)
                self.loadUserData()
            }
            
        } else {
           //save
            saveUserData(user: user)
            loadUserData()
        }
        
        editingMode = false
        updateEditingMode()
        showSaveButton()
    }
    
    private func saveUserData(user: FirebaseUser) {
        
        user.saveUserLocally()
        user.saveUserToFireStore()
    }
    
    //MARK: - Setup
    private func setupBackgrounds() {
        
        profileCellBackgroundView.clipsToBounds = true
        profileCellBackgroundView.layer.cornerRadius = 100
        profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        aboutMeView.layer.cornerRadius = 10
    }
    
    private func showSaveButton() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    //MARK: - LoadUserDada
    private func loadUserData() {
        
        let currentUser = FirebaseUser.currentUser()!
        
        FileStorage.downloadImage(imageUrl: currentUser.avatarLink) { (image) in
            
        }

        nameAgeLabel.text = currentUser.fullName + ", \(abs(currentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        cityCountryLabel.text = currentUser.country
        aboutMeTextView.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
        jobTextField.text = currentUser.profession
        professionTextField.text = currentUser.profession
        genderTextField.text = currentUser.isMan ? "Male" : "Female"
    //    cityTextField.text = currentUser.city
        countryTextField.text = currentUser.country
     //   heightTextField.text = "\(currentUser.height)"
        lookingForTextField.text = currentUser.lookingFor
        avatarImageView.image = UIImage(named: "avatar")?.circleMasked

        avatarImageView.image = currentUser.avatar?.circleMasked
        
    }


    //MARK: - Editing Mode
    private func updateEditingMode() {
        
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
     //   cityTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
    //    heightTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
    }

    
    //MARK: - Helpers
    private func showKeyboard() {
        self.aboutMeTextView.becomeFirstResponder()
    }

    private func hideKeyboard() {
        self.view.endEditing(false)
    }
    
    //MARK: - FileStorage
    
    private func uploadAvatar(_ image: UIImage, completion: @escaping (_ avatarLink: String?)-> Void) {
        
        ProgressHUD.show()
        
        let fileDirectory = "Avatars/_" + FirebaseUser.currentId() + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            
            ProgressHUD.dismiss()
            FileStorage.saveImagelocally(imageData: image.jpegData(compressionQuality: 0.8)! as NSData, fileName: FirebaseUser.currentId())
            completion(avatarLink)
        }
        
    }

    
    private func uploadImages(images: [UIImage?]) {
        
        ProgressHUD.show()

        FileStorage.uploadImages(images) { (imageLinks) in
            
            ProgressHUD.dismiss()

            let currentUser = FirebaseUser.currentUser()!
            
            currentUser.imageLinks = imageLinks
            
            self.saveUserData(user: currentUser)
        }
        
    }
    
    //MARK: - Gallery
    
    private func showGallery(forAvatar: Bool) {
        
        uploadingAvatar = forAvatar
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = forAvatar ? 1 : 10
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
    }


    
    //MARK: - AlertController
    private func showPictureOptions() {
        
        let alertController = UIAlertController(title: "Upload Picture", message: "You can change your Avatar or upload more pictures.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func showEditOptions() {
        
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to edit sensitive information about your account.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            
            self.showChangeField(value: "Email")
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (alert) in
            
            self.showChangeField(value: "Name")
        }))
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            
            self.logOutUser()
        }))

        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    private func showChangeField(value: String) {
        
        let alertView = UIAlertController(title: "Updating \(value)", message: "Please write your \(value)", preferredStyle: .alert)
        
        alertView.addTextField { (textField) in
            self.alertTextField = textField
            self.alertTextField.placeholder = "New \(value)"
        }
        
        alertView.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { (action) in
            
            self.updateUserWith(value: value)
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    //MARK: - Change user info
    
    private func updateUserWith(value: String) {
        
        if alertTextField.text != "" {
            
            value == "Email" ? changeEmail() : changeUserName()
        } else {
            ProgressHUD.showError("\(value) is empty")
        }
    }

    
    private func changeEmail() {
        
        FirebaseUser.currentUser()?.updateUserEmail(newEmail: alertTextField.text!, completion: { (error) in
            
            if error == nil {
                
                if let currentUser = FirebaseUser.currentUser() {
                    currentUser.email = self.alertTextField.text!
                    self.saveUserData(user: currentUser)
                }

                ProgressHUD.showSuccess("Success!")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        })

    }
    
    private func changeUserName() {

        if let currentUser = FirebaseUser.currentUser() {
            currentUser.fullName = alertTextField.text!
            
            saveUserData(user: currentUser)
            loadUserData()
        }
    }

    //MARK: - LogOut
    
    private func logOutUser() {
        
        FirebaseUser.logOutCurrentUser { (error) in
            
            if error == nil {
                
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                
                DispatchQueue.main.async {
                    
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
                
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
        
    }


}


extension ProfileTableViewController: GalleryControllerDelegate {
    
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            if uploadingAvatar {
                
                images.first!.resolve { (icon) in
                    
                    if icon != nil {
                        
                        self.editingMode = true
                        self.showSaveButton()
                        
                        self.avatarImageView.image = icon?.circleMasked
                        self.avatarImage = icon
                    } else {
                        ProgressHUD.showError("Couldn't select image!")
                    }
                }
                
            } else {
                
                Image.resolve(images: images) { (resolvedImages) in
                    
                    self.uploadImages(images: resolvedImages)
                }
            }
        }
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
