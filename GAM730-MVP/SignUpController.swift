//
//  SignUpController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 03/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import UIKit
import ProgressHUD

class SignUpController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: - Variables
    
    // Man, Woman, NonBinary
    var isMan = true
    
    //MARK: - ViewLifeCycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark

        setupBackgroundTouch()
        
       }
    
    //MARK: - IBActions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if isTextDataInputed(){
            registerUser()
        } else {
            ProgressHUD.showError("Please fill all info")
        }
        
    }
    
    
    @IBAction func genderSegmentValue(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            isMan = true
        } else {
            isMan = false
        }
        
        isMan = sender.selectedSegmentIndex == 0 ? true : false
        
    }
    
    //MARK: - Setup
      
      // Need to set this background touch so that the keyboard can be coded to disappear when user stops typing
      private func setupBackgroundTouch() {
          // user can interact with background image now:
          backgroundImageView.isUserInteractionEnabled = true
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
          backgroundImageView.addGestureRecognizer(tapGesture)
          
      }
      
      @objc func backgroundTap() {
          dismissKeyboard()
      }
      
      
      //MARK: - Helpers
      
      private func dismissKeyboard() {
          self.view.endEditing(false)
          
      }
    
    // check the user has inputted all their data
    private func isTextDataInputed() -> Bool {
        return fullNameTextField.text != "" && emailTextField.text != "" && countryTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" && dateOfBirthTextField.text != ""
    }
      
    
    // MARK: - Register The User
    
    private func registerUser() {
        
    }
    

    
}
