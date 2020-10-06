//
//  GlobalFunctions.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 05/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//


import Foundation
import Firebase

//MARK: - Matches
func removeCurrentUserIdFrom(userIds: [String]) -> [String] {
    
    var allIds = userIds

    for id in allIds {
        
        if id == FirebaseUser.currentId() {
            allIds.remove(at: allIds.firstIndex(of: id)!)
        }
    }

    return allIds
}




//MARK: - Like

func saveLikeToUser(userId: String) {
    
    let like = LikeObject(id: UUID().uuidString, userId: FirebaseUser.currentId(), likedUserId: userId, date: Date())
    like.saveToFireStore()
    
    
    if let currentUser = FirebaseUser.currentUser() {
        
        if !didLikeUserWith(userId: userId) {
            
            currentUser.likedIdArray!.append(userId)
            
            currentUser.updateCurrentUserInFireStore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
                
                print("updated current user with error ", error?.localizedDescription)
            }
        }
    }
}


func didLikeUserWith(userId: String) -> Bool {
    
    return FirebaseUser.currentUser()?.likedIdArray?.contains(userId) ?? false
}

//MARK: - Starting chat
func startChat(user1: FirebaseUser, user2: FirebaseUser) -> String {
    
    let chatRoomId = chatRoomIdFrom(user1Id: user1.objectId, user2Id: user2.objectId)
    
    createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
    
    return chatRoomId
}

func chatRoomIdFrom(user1Id: String, user2Id: String) -> String {
    
    var chatRoomId = ""
    
    let value = user1Id.compare(user2Id).rawValue
    
    chatRoomId = value < 0 ? user1Id + user2Id : user2Id + user1Id
    
    return chatRoomId
}


func restartChat(chatRoomId: String, memberIds: [String]) {
    
    FirebaseListener.shared.downloadUsersFromFirebase(withIds: memberIds) { (users) in
        if users.count > 0 {
            createRecentItems(chatRoomId: chatRoomId, users: users)
        }
    }
}



//MARK: - RecentChats

func createRecentItems(chatRoomId: String, users: [FirebaseUser]) {

    var memberIdsToCreateRecent: [String] = []
    
    for user in users {
        memberIdsToCreateRecent.append(user.objectId)
    }
    
    FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
        }
        
        
        
        for userId in memberIdsToCreateRecent {
            
            let senderUser = userId == FirebaseUser.currentId() ? FirebaseUser.currentUser()! : getReceiverFrom(users: users)
            
            let receiverUser = userId == FirebaseUser.currentId() ? getReceiverFrom(users: users) : FirebaseUser.currentUser()!
            
            let recentObject = RecentChat()
            
            recentObject.objectId = UUID().uuidString
            recentObject.chatRoomId = chatRoomId
            recentObject.senderId = senderUser.objectId
            recentObject.senderName = senderUser.fullName
            recentObject.receiverId = receiverUser.objectId
            recentObject.receiverName = receiverUser.fullName
            recentObject.date = Date()
            recentObject.memberIds = [senderUser.objectId, receiverUser.objectId]
            
            recentObject.lastMessage = ""
            recentObject.unreadCounter = 0
            recentObject.avatarLink = receiverUser.avatarLink
            
            recentObject.saveToFireStore()
        }
    }
}


func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
    
    var memberIdsToCreateRecent = memberIds
    
    for recentData in snapshot.documents {
        
        let currentRecent = recentData.data() as Dictionary
        
        if let currentUserId = currentRecent[kSENDERID] {
            
            if memberIdsToCreateRecent.contains(currentUserId as! String) {
                let index = memberIdsToCreateRecent.firstIndex(of: currentUserId as! String)!
                memberIdsToCreateRecent.remove(at: index)
            }
        }
    }
    
    return memberIdsToCreateRecent
}


func getReceiverFrom(users: [FirebaseUser]) -> FirebaseUser {
    
    var allUsers = users
    
    allUsers.remove(at: allUsers.firstIndex(of: FirebaseUser.currentUser()!)!)
    
    return allUsers.first!
    
}
