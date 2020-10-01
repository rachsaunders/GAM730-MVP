//
//  CardViewController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 01/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import UIKit
import Shuffle_iOS
import Firebase

class CardViewController: UIViewController {
    
    //MARK: - VARS
    
    private let cardStack = SwipeCardStack()
    private var initialCardModels: [UserCardModel] = []

    
   // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        createUsers()

        
        
        // I commented out the below to test the swipe function!
        
//        // see the current users card
//        let user = FirebaseUser.currentUser()!
//        let cardModel = UserCardModel(id: user.objectId, name: user.fullName, age: abs(user.dateOfBirth.interval(ofComponent: .year, fromDate: Date())), occupation: user.profession, image: user.avatar)
//
//
//        initialCardModels.append(cardModel)
//        layoutCardStackView()
        
    }
    
    
    //MARK: - LAYOUT CARDS
    private func layoutCardStackView() {
        
        cardStack.delegate = self
        cardStack.dataSource = self
        
        view.addSubview(cardStack)
        
        cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CardViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = UserCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        
        for direction in card.swipeDirections {
            
            card.setOverlay(UserCardOverlay(direction: direction), forDirection: direction)
            
        }
        
        card.configure(withModel: initialCardModels[index])
        
        return card
        
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return initialCardModels.count
    }
    
    //MARK: - Delegates
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("this works so chill out")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("swipe card stack works", direction)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("selected card")
    }
    
}
