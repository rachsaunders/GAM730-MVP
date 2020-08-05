//
//  SignUpController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 03/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import UIKit

class SignUpController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    
    
    //MARK: - ViewLifeCycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
    
        
       }
    
    //MARK: - IBActions
    

    
}
