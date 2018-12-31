//
//  VendorPass.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 12/22/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class VendorPass: Pass {
    
    var entrant: Entrant
    var isBirthday: Bool
    var passCreationDate = Date()
    let passType: String
    let fullName: String?
    let vendorType: VendorType
    var passSwipeStamp: Date? = nil
    
    init(entrant: Entrant, vendorTypeString: String) throws {
        var _vendorType: VendorType?
        VendorType.allCases.forEach { current in
            if current.rawValue == vendorTypeString {
                _vendorType = current
            }
        }
        
        
        guard let vendorType = _vendorType else {
            throw GeneratorError.incorrectSubtype("Vendor Type Incorrect")
        }
        
        if let errorString = entrant.vendorEntrant() {
            throw GeneratorError.missingInformation("Error creating \(vendorType.rawValue) Vendor Pass. \(errorString)")
        }
        
        self.isBirthday = entrant.isEntrantBirthday()
        self.entrant = entrant
        self.vendorType = vendorType
        self.fullName = entrant.fullName
        self.passType = "\(vendorType.rawValue) Vendor Pass"
    }
    
    func swipe(for areaAcess: AreaAccess) -> SwipeResult {
        switch areaAcess {
        case .kitchen:
            if vendorType != .fedex {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .amusement:
            if vendorType == .nwElectrical || vendorType == .orkin {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .rideControl:
            if vendorType == .orkin || vendorType == .nwElectrical {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .maintenance:
            if vendorType == .fedex || vendorType == .nwElectrical {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        case .office:
            if vendorType == .fedex || vendorType == .nwElectrical {
                return SwipeResult(access: true, birthdayMessage: birthdayMessage)
            }
        }
        return SwipeResult(access: false, birthdayMessage: birthdayMessage)
    }
    
    func swipe(rideAccess: RideAccess) -> SwipeResult {
        return SwipeResult(access: false, birthdayMessage: birthdayMessage)
    }
    
    func swipe(discountOn: DiscountAccess) -> SwipeResult {
        return SwipeResult(access: false, message: "Discount Not Available", birthdayMessage: birthdayMessage)
    }
    
}
