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
    
    private init() {}
    
    //MARK: - FirebaseUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                let user = FirebaseUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                
                user.getUserAvatarFromFirestore { (didSet) in
                    
                }
                
            } else {
                //first login
                
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
            query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: true).limit(to: limit)
            print("first \(limit) users loading")
            
        } else {
            
            if lastDocumentSnapshot != nil {
                query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending: true).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                
                print("next \(limit) user loading")

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
    
    
    func downloadUsersFromFirebase(withIds: [String], completion: @escaping (_ users: [FirebaseUser]) -> Void) {
        
        var usersArray: [FirebaseUser] = []
        var counter = 0
        
        for userId in withIds {
            
            FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    
                    usersArray.append(FirebaseUser(_dictionary: snapshot.data()! as NSDictionary))
                    counter += 1
                    
                    if counter == withIds.count {
                        
                        completion(usersArray)
                    }
                    
                } else {
                    completion(usersArray)
                }
            }
        }
    }
    
    
    //MARK: - Likes
    func downloadUserLikes(completion: @escaping (_ likedUserIds: [String]) -> Void) {
        
        FirebaseReference(.Like).whereField(kLIKEDUSERID, isEqualTo: FirebaseUser.currentId()).getDocuments { (snapshot, error) in
            
            var allLikedIds: [String] = []
            
            guard let snapshot = snapshot else {
                completion(allLikedIds)
                return
            }
            
            if !snapshot.isEmpty {
                
                for likeDictionary in snapshot.documents {
                    
                    allLikedIds.append(likeDictionary[kUSERID] as? String ?? "")
                }
                
                completion(allLikedIds)
            } else {
                print("No likes found")
                completion(allLikedIds)
            }
        }
    }

    
    
    func checkIfUserLikedUs(userId: String, completion: @escaping (_ didLike: Bool) -> Void) {
        
        FirebaseReference(.Like).whereField(kLIKEDUSERID, isEqualTo: FirebaseUser.currentId()).whereField(kUSERID, isEqualTo: userId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            completion(!snapshot.isEmpty)
        }
    }
    
    
    //MARK: - Match
    func downloadUserMatches(completion: @escaping (_ matchedUserIds: [String]) -> Void) {
        
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        FirebaseReference(.Match).whereField(kMEMBERIDS, arrayContains: FirebaseUser.currentId()).whereField(kDATE, isGreaterThan: lastMonth).order(by: kDATE, descending: true).getDocuments { (snapshot, error) in
            
            var allMatchedIds: [String] = []
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                
                for matchDictionary in snapshot.documents {
                    
                    allMatchedIds += matchDictionary[kMEMBERIDS] as? [String] ?? [""]
                }
                
                completion(removeCurrentUserIdFrom(userIds: allMatchedIds))
                
            } else {
                print("No Matches found")
                completion(allMatchedIds)
            }
        }
    }
    
    
    func saveMatch(userId: String) {
        
        let match = MatchObject(id: UUID().uuidString, memberIds: [FirebaseUser.currentId(), userId], date: Date())
        match.saveToFireStore()
    }
    
    
    //MARK: - RecentChats
    func downloadRecentChatsFromFireStore(completion: @escaping (_ allRecents: [RecentChat]) -> Void) {
        
        FirebaseReference(.Recent).whereField(kSENDERID, isEqualTo: FirebaseUser.currentId()).addSnapshotListener { (querySnapshot, error) in
            
            var recentChats: [RecentChat] = []
            
            guard let snapshot = querySnapshot else { return }
            
            if !snapshot.isEmpty {
                
                for recentDocument in snapshot.documents {
                    
                    if recentDocument[kLASTMESSAGE] as! String != "" && recentDocument[kCHATROOMID] != nil && recentDocument[kOBJECTID] != nil {
                        
                        recentChats.append(RecentChat(recentDocument.data()))
                    }
                }
                
                recentChats.sort(by: { $0.date > $1.date })
                completion(recentChats)
                
            } else {
                completion(recentChats)
            }
        }
    }


    
}
