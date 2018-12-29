//
//  ManagerPass.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 12/22/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class ManagerPass: Pass {
    
    // MARK: Properties
    var entrant: Entrant
    var isBirthday: Bool
    var passSwipeStamp: Date? = nil
    let passType: String
    let fullName: String?
    let managerType: ManagerType
    
    // MARK: Initializers
    init(entrant: Entrant, managerTypeString: String) throws {
        var _managerType: ManagerType?
        ManagerType.allCases.forEach { current in
            if current.rawValue == managerTypeString {
                _managerType = current
            }
        }
        
        guard let managerType = _managerType else {
            throw GeneratorError.incorrectSubtype("Employee Type Incorrect")
        }
        
        if entrant.employeeEntrant() != nil, let errorString = entrant.employeeEntrant() {
            throw GeneratorError.missingInformation("Error creating \(managerType.rawValue) Employee Pass. \(errorString)")
        }
        
        self.isBirthday = entrant.isEntrantBirthday()
        self.entrant = entrant
        self.managerType = managerType
        // if employee is a manager make sure the swipe knows which type of manager
        self.passType = "\(managerType.rawValue) Pass"
        self.fullName = entrant.fullName
    }
    
    // MARK: Required Methods
    func swipe(for areaAccess: AreaAccess) -> SwipeResult {
        return SwipeResult(access: true, birthdayMessage: birthdayMessage)
    }
    
    func swipe(rideAccess: RideAccess) -> SwipeResult {
        
        // Check if pass has a pass stamp and if it is swiped less than 5 seconds ago
        // If not then give new pass stamp
        if let lastSwipeDate = passSwipeStamp {
            if isPassSwipedTooSoon(timeOfLastSwipe: lastSwipeDate) {
                return SwipeResult(access: false, message: "Sorry you have tried to access this ride in the last 5 seconds.", birthdayMessage: birthdayMessage)
            } else {
                passSwipeStamp = Date()
            }
        } else {
            passSwipeStamp = Date()
        }
        return SwipeResult(access: true, message: createSkipLineMessage(), birthdayMessage: birthdayMessage)
    }
    
    func swipe(discountOn: DiscountAccess) -> SwipeResult {
        return SwipeResult(access: true, message: "Discount of 25%", birthdayMessage: birthdayMessage)
    }
}

