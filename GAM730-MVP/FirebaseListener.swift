//
//  FirebaseListener.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 20/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init () {}
    
    //MARK: FirebaseUser
    
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                //   let user = FirebaseUser(_dictionary: snapshot.data() as! NSDictionary) changed to the below
                
                let user = FirebaseUser(_dictionary: snapshot.data()! as NSDictionary)
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
    
    func downloadUsersFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [FirebaseUser], _ snapshot: DocumentSnapshot?) ->Void) {
        
        var query: Query!
        var users: [FirebaseUser] = []
        
        if isInitialLoad {
            query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: false).limit(to: limit)
            
            print("first limit users downloaded")
            
        } else {
            
            if lastDocumentSnapshot != nil {
                
                query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: false).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                
                print("next limit users loading")
                
            } else {
                
                print("last snapshot is nil")
            }
            
        }
        
        if query != nil {
            
            query.getDocuments { (snapShot, error) in
                
                guard let snapshot = snapShot else { return }
                
                if !snapshot.isEmpty {
                    
                    for userData in snapshot.documents {
                        
                        let userObject = userData.data() as NSDictionary
                        
                        if !(FirebaseUser.currentUser()?.likedIdArray?.contains(userObject[kOBJECTID] as! String) ?? false) && FirebaseUser.currentId() != userObject[kOBJECTID] as! String {
                            
                            users.append(FirebaseUser(_dictionary: userObject))
                            
                        }
                    }
                    
                    completion(users, snapshot.documents.last!)
                    
                } else {
                    print("no more users to fetch")
                    completion(users, nil)
                }
            }
        } else {
            completion(users, nil)
        }
    }
    
}
