//
//  FirebaseCollectionReference.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 20/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import FirebaseFirestore



enum FCollectionReference: String {
    case User
    case Like
    case Match
    case Recent
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
