//
//  LikeObject.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 05/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//


import Foundation

struct LikeObject {
    
    let id: String
    let userId: String
    let likedUserId: String
    let date: Date
    
    var dictionary: [String : Any] {
        return [kOBJECTID : id, kUSERID : userId, kLIKEDUSERID : likedUserId, kDATE : date]
    }
    
    func saveToFireStore() {
        
        FirebaseReference(.Like).document(self.id).setData(self.dictionary)
    }
}
