//
//  FirebaseCollectionReference.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 20/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import FirebaseFirestore



    
    enum FirebaseCollectionReference: String {
        
        case User
        
    }

    
func FirebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
