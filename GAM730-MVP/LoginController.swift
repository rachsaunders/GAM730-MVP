//
//  LoginController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 03/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       overrideUserInterfaceStyle = .dark
        
    }
    
    //MARK: - IBActions
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
