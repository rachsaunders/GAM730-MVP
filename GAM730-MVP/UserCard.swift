//
//  UserCard.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 01/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import Shuffle_iOS

class UserCard: SwipeCard {
    
//    override var swipeDirections: [SwipeDirection] {
//        return [.left, .up, .right]
//    }
//
//    override init(frame; CGRect) {
//        super.init(frame: frame)
//        footerHeight = 80
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        return nil
//    }
//
//    override func overlay(forDirection direction: SwipeDirection) -> UIView? {
//        UIView? {
//            switch direction {
//            case .left:
//                return SampleCardOverlay.left()
//                case .up:
//                return SampleCardOverlay.up()
//                case .right:
//                return SampleCardOverlay.right()
//            default:
//                return nil
//            }
//
    func configure(withModel model: UserCardModel) {
                content = UserCardContentView(withImage: model.image)
        footer = UserCardFooterView(withTitle: "\(model.name)", subtitle: model.occupation)
            }
//        }
//    }
    
    
    
    
    
}
