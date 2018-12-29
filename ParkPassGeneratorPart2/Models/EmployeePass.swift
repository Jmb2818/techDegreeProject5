//
//  EmployeePass.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class EmployeePass: Pass {
    
    // MARK: Properties
    var entrant: Entrant
    var isBirthday: Bool
    var passSwipeStamp: Date? = nil
    let passType: String
    let fullName: String?
    let employeeType: EmployeeType
    let projectNum: String?
    
    // MARK: Initializers
    init(entrant: Entrant, employeeTypeString: String) throws {
        var _employeeType: EmployeeType?
        EmployeeType.allCases.forEach { current in
            if current.rawValue == employeeTypeString {
                _employeeType = current
            }
        }
        
        guard let employeeType = _employeeType else {
            throw GeneratorError.incorrectSubtype("Employee Type Incorrect")
        }
        
        if entrant.employeeEntrant() != nil, let errorString = entrant.employeeEntrant() {
            throw GeneratorError.missingInformation("Error creating \(employeeType.rawValue) Employee Pass. \(errorString)")
        }
        
        if employeeType == .contract {
            if let projectNum = entrant.projectNum {
                self.projectNum = projectNum
            } else {
                throw GeneratorError.missingProjectNumber("Missing Project Number for Contract Employee.")
            }
        } else {
            self.projectNum = nil
        }
        
        if let dateOfBirth = entrant.dob {
            self.isBirthday = DateEditor.isBirthday(dateOfBirth: dateOfBirth)
        } else {
            self.isBirthday = false
        }
        
        self.entrant = entrant
        self.employeeType = employeeType
        self.passType = "\(employeeType.rawValue) Pass"
        self.fullName = "\(entrant.firstName ?? "") \(entrant.lastName ?? "")"
    }
    
    // MARK: Required Methods
    func swipe(for areaAccess: AreaAccess) -> SwipeResult {
        if employeeType == .contract {
            guard let swipeResult = contractEmployeePass(areaAccess: areaAccess) else {
                return SwipeResult(access: false, birthdayMessage: birthdayMessage)
            }
            return swipeResult
        }
        
        switch areaAccess {
        case .amusement:
            return SwipeResult(access: true, birthdayMessage: birthdayMessage)
        case .kitchen:
            if self.employeeType != .ride {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .maintenance:
            if self.employeeType == .maintenance {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .rideControl:
            if self.employeeType != .food {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        default: return SwipeResult(access: false, birthdayMessage: birthdayMessage)
        }
        return SwipeResult(access: false, birthdayMessage: birthdayMessage)
    }
    
    func swipe(rideAccess: RideAccess) -> SwipeResult {
        if employeeType == .contract {
            return SwipeResult(access: false, birthdayMessage: birthdayMessage)
        }
        
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
        if employeeType == .contract {
            return SwipeResult(access: false, message: "We are sorry, no discounts allowed.", birthdayMessage: birthdayMessage)
        }
        switch discountOn {
        case .food:
            return SwipeResult(access: true, message: "Discount of 15%", birthdayMessage: birthdayMessage)
        case .merchandise:
            return SwipeResult(access: true, message: "Discount of 25%", birthdayMessage: birthdayMessage)
        }
    }
}

typealias ContractEmployeePass = EmployeePass
extension ContractEmployeePass {
    func contractEmployeePass(areaAccess: AreaAccess) -> SwipeResult? {
        guard let projectNum = self.projectNum else {
            return nil
        }
        
        switch areaAccess {
        case .amusement:
            if projectNum == ProjectNumbers.twoOhOne.rawValue ||
                projectNum == ProjectNumbers.twoOhTwo.rawValue {
                return SwipeResult(access: false, birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .kitchen:
            if projectNum == ProjectNumbers.oneOhThree.rawValue ||
                projectNum == ProjectNumbers.twoOhTwo.rawValue {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: false, birthdayMessage: birthdayMessage)
            }
        case .maintenance:
            if projectNum == ProjectNumbers.twoOhOne.rawValue ||
                projectNum == ProjectNumbers.oneOhOne.rawValue {
                return SwipeResult(access: false, birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .office:
            if projectNum == ProjectNumbers.oneOhThree.rawValue ||
                projectNum == ProjectNumbers.twoOhOne.rawValue {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: false, birthdayMessage: birthdayMessage)
            }
        case .rideControl:
            if projectNum == ProjectNumbers.twoOhOne.rawValue ||
                projectNum == ProjectNumbers.twoOhTwo.rawValue {
                return SwipeResult(access: false, birthdayMessage: birthdayMessage)
            } else {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        }
    }
}
