//
//  FirebaseListener.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 20/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import Firebase

class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init () {}
    
    //MARK: FirebaseUser
    
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                let user = FirebaseUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                
                user.getUserAvatarFromFireStore { (didSet) in
                    
                    
                }
                
            
            } else {
                // first login
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    FirebaseUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
            }
            
        }
        
    }
    
}
