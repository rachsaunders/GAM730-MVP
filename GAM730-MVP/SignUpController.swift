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
    var datePicker = UIDatePicker()
    
    //MARK: - ViewLifeCycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark

        setupBackgroundTouch()
        setupDatePicker()
        
       }
    
    //MARK: - IBActions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if isTextDataInputed(){
            
            // check passwords match
            if passwordTextField.text! == confirmPasswordTextField.text! {
                
            registerUser()
            } else {
                 ProgressHUD.showError("Passwords don't match")
                
            }
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
    
    // change the date of birth to a date picker
    private func setupDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor().primary()
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        dateOfBirthTextField.inputAccessoryView = toolBar
    }
      
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
      
      @objc func dismissKeyboard() {
          self.view.endEditing(false)
          
      }
    
    @objc func handleDatePicker() {
        
    }
    
    @objc func doneClicked() {
        
    }
    
    // check the user has inputted all their data
    private func isTextDataInputed() -> Bool {
        return fullNameTextField.text != "" && emailTextField.text != "" && countryTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" && dateOfBirthTextField.text != ""
    }
      
    
    // MARK: - Register The User
    
    private func registerUser() {
        
        ProgressHUD.show()
        
        FirebaseUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, fullName: fullNameTextField.text!, country: countryTextField.text!, isMan: isMan, dateOfBirth: Date(), completion:  {
            error in
            
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent!")
                
                // the below dismisses the signup controller when user has signed up
                self.dismiss(animated: true, completion: nil)
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
            
            
            
            
        })
        
    }
    

    
}
