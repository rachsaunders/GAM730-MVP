//
//  FirebaseUser.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 10/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit

class FirebaseUser: Equatable {
    
    
    static func == (lhs: FirebaseUser, rhs: FirebaseUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String
    var email: String
    var fullName: String
    var dateOfBirth: Date
    var isMan: Bool
    var country: String
    
    var profession: String
    var avatar: UIImage?
    var about: String
    
    var lookingFor: String
    
    var avatarLink: String
    
    // optional as may be nil!
    var likedIdArray: [String]?
    var imageLinks: [String]?
    
    let registeredDate = Date()
    var pushId: String?
    
    
    
    // On the final app you will need to add the extra options
    
    
    
    var userDictionary: NSDictionary {
        
        return NSDictionary(objects: [
            
            // copied from above
            self.objectId,
            self.email,
            self.fullName,
            self.dateOfBirth,
            self.isMan,
            self.country,
            
            self.profession,
            
            self.about,
            
            self.lookingFor,
            
            self.avatarLink,
            
            self.likedIdArray ?? [],
            self.imageLinks ?? [],
            
            self.registeredDate,
            self.pushId ?? ""
            ],
                            
                            // make sure they're in order!
            forKeys: [kOBJECTID as NSCopying,
                      kEMAIL as NSCopying,
                      kFULLNAME as NSCopying,
                      kDATEOFBIRTH as NSCopying,
                      kISMAN as NSCopying,
                      kCOUNTRY as NSCopying,
                      
                      kPROFESSION as NSCopying,
                      kABOUT as NSCopying,
                      kLOOKINGFOR as NSCopying,
                      kAVATARLINK as NSCopying,
                      
                      kLINKEDIDARRAY as NSCopying,
                      kIMAGELINKS as NSCopying,
                      
                      kREGISTEREDDATE as NSCopying,
                      kPUSHID as NSCopying,
                   
                      // will this get rid of the error who knows im so tired
                // it works yay!
                 //    kCURRENTUSER as NSCopying,
                      
                      
                      
        ])
    }
    
    //MARK: - Inits
    
    init(_objectID: String, _email: String, _fullName: String, _country: String, _dateOfBirth: Date, _isMan: Bool, _avatarLink: String = "") {
        
        objectId = _objectID
        email = _email
        fullName = _fullName
        dateOfBirth = _dateOfBirth
        isMan = _isMan
        profession = ""
        about = ""
        country = ""
        lookingFor = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
        
    }
    
    
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as? String ?? ""
        email = _dictionary[kEMAIL] as? String ?? ""
        fullName = _dictionary[kFULLNAME] as? String ?? ""
        
        if let date = _dictionary[kDATEOFBIRTH] as? Timestamp {
            dateOfBirth = date.dateValue()
        } else {
            dateOfBirth = _dictionary[kDATEOFBIRTH] as? Date ?? Date()
        }
        
        isMan = _dictionary[kISMAN] as? Bool ?? true
        profession = _dictionary[kPROFESSION] as? String ?? ""
        about = _dictionary[kABOUT] as? String ?? ""
        country = _dictionary[kCOUNTRY] as? String ?? ""
        lookingFor = _dictionary[kLOOKINGFOR] as? String ?? ""
        avatarLink = _dictionary[kAVATARLINK] as? String ?? ""
        likedIdArray = _dictionary[kLINKEDIDARRAY] as? [String]
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        
    }
    
    
    // email, password, fullName, country, isMan, dateOfBirth, completion
    
    //MARK: - Login
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ Error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, error) in
            
            if error == nil {
                
                if AuthDataResult!.user.isEmailVerified {
                    
                    FirebaseListener.shared.downloadCurrentUserFromFirebase(userId: AuthDataResult!.user.uid, email: email)
                    
                    completion(error, true)
                    
                } else {
                    print("Email not verified")
                    completion(error, false)
                    
                    
                }
                
            } else {
                completion(error, false)
            }
            
        }
        
        
       
    }
    
    //MARK: - Register the user
    
    class func registerUserWith(email: String, password: String, fullName: String, country: String, isMan: Bool, dateOfBirth: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        print("register", Date())
        // Firebase users should have minimum of email and password for authentication
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            
            completion(error)
            
            if error == nil {
                
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verification sent", error?.localizedDescription)
                }
                
                if authData?.user != nil {
                    
                    let user = FirebaseUser(_objectID: authData!.user.uid, _email: email, _fullName: fullName, _country: country, _dateOfBirth: dateOfBirth, _isMan: isMan)
                    
                    user.saveUserLocally()
                    
                }
            }
            
        }
        
    }
    
    //MARK: - Resend Links
    
    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                completion(error)
                
            })
            
        })
        
    }
    
    //MARK: - Save user Functions
    
    func saveUserLocally() {
        
        userDefaults.setValue(self.userDictionary as! [String : Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
    }
    
    func saveUserToFireStore() {
        
        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]) { (error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    
    
    
    }
    
    
    
    
    
    
    
    
}
