//
//  GuestPass.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class GuestPass: Pass {
    
    // MARK: Properties
    var entrant: Entrant
    var isBirthday: Bool
    let passType: String
    let guestType: GuestType
    let fullName: String?
    var passSwipeStamp: Date? = nil
    
    // MARK: Initializers
    init(entrant: Entrant, guestTypeString: String) throws {
        
        var _guestType: GuestType?
        GuestType.allCases.forEach { current in
            if current.rawValue == guestTypeString {
                _guestType = current
            }
        }
        
        guard let guestType = _guestType else {
            throw GeneratorError.incorrectSubtype("Guest Type Incorrect")
        }
        // If the guest type is a child, make sure there is a DOB and they are under 5
        if guestType == .child {
            guard let dateOfBirth = entrant.dob else {
                let errorDescription = "Guest pass creation error for child's pass. No date of birth entered."
                throw GeneratorError.missingInformation(errorDescription)
            }
            
            let dateComponents = Calendar.current.dateComponents([.year], from: Date(), to: dateOfBirth)
            if let yearDifference = dateComponents.year, yearDifference < 5 {
                throw GeneratorError.olderThanFive("Error creating child's pass. Child is older than five.")
            }
        }
        
        // If the entrant has entered a DOB then check if it is their birthday for special messaging
        if let dateOfBirth = entrant.dob {
            self.isBirthday = DateEditor.isBirthday(dateOfBirth: dateOfBirth)
        } else {
            self.isBirthday = false
        }
        
        self.entrant = entrant
        self.guestType = guestType
        self.passType = guestType.rawValue
        self.fullName = "\(entrant.firstName ?? "") \(entrant.lastName ?? "")"
    }
    
    // MARK: Required Methods
    func swipe(for areaAcess: AreaAccess) -> SwipeResult {
        switch areaAcess {
        case .amusement:
            return SwipeResult(access: true, birthdayMessage: birthdayMessage)
        default:
            return SwipeResult(access: false, birthdayMessage: birthdayMessage)
        }
    }
    
    func swipe(rideAccess: RideAccess) -> SwipeResult {
        
        // Check if pass has a pass stamp and if it is swiped less than 5 seconds ago
        // If not then give new pass stamp
        if let lastSwipeDate = passSwipeStamp {
            if isPassSwipedTooSoon(timeOfLastSwipe: lastSwipeDate) {
                return SwipeResult(access: false, message: " Sorry you have tried to access this ride in the last 5 seconds.", birthdayMessage: birthdayMessage)
            } else {
                passSwipeStamp = Date()
            }
        } else {
            passSwipeStamp = Date()
        }
        return SwipeResult(access: true, message: createSkipLineMessage(), birthdayMessage: birthdayMessage)
    }
    
    func swipe(discountOn: DiscountAccess) -> SwipeResult {
        switch discountOn {
        case .food:
            if self.guestType == .vip {
                return SwipeResult(access: true, message: "Discount of 10%", birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: false, message: "We are sorry, no discounts allowed.", birthdayMessage: birthdayMessage)
            }
        case .merchandise:
            if self.guestType == .vip {
                return SwipeResult(access: true, message: "Discount of 20%", birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: false, message: "We are sorry, no discounts allowed.", birthdayMessage: birthdayMessage)
            }
        }
    }
    
    
}
