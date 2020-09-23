//
//  Extensions.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 23/08/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd mm yyyy"
        return dateFormatter.string(from: self)
        
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd mm yyyy"
        return dateFormatter.string(from: self)
        
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else
        { return 0}
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else
              { return 0}
        
        return end - start 
        
    }
    
    
}

extension UIColor {
    
    func primary() -> UIColor {
        
        return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    }
    
    func tabBarUnselected() -> UIColor {
        
        return UIColor(red: 255/255, green: 216/255, blue: 223/255, alpha: 1)
    }
    
    
}
