//
//  SwipeResult.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Struct for printout of the result of a swipe
struct SwipeResult {
    
    // MARK: Proeprties
    let access: Bool
    let description: String
    let message: String
    let birthdayMessage: String
    
    // MARK: Initializer that takes a modified message like a birthday message
    init(access: Bool, message: String = "", birthdayMessage: String) {
        self.access = access
        
        if access {
            self.description = "Access Granted!"
        } else {
            self.description = "Access Denied!"
        }
        
        self.message = message
        self.birthdayMessage = birthdayMessage
    }
    
    
}
