//
//  LoginController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 03/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//
import UIKit
import ProgressHUD

class LoginController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()
        
    }
    
    //MARK: - IBActions
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" {
            
            FirebaseUser.resetPasswordFor(email: emailTextField.text!) { (error) in
                
                if error != nil {
                    
                    ProgressHUD.showError(error!.localizedDescription)
                } else {
                    ProgressHUD.showSuccess("Check your email")
                }
                
            }
            
        } else {
            
            ProgressHUD.showError("Please insert your email address")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            FirebaseUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else if isEmailVerified {
                    print("go to app yay")
                    // enter the application
                } else {
                    ProgressHUD.showError("Please verify email")
                }
                
            }
              } else {
                 
                  ProgressHUD.showError("All fields are required")
              }
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
    
    
    
    
}
