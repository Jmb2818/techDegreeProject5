//
//  GeneratedPassModel.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 1/26/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation

struct GeneratedPassModel {
    let pass: Pass
    let fullname: String?
    let passType: String
    let foodDiscount: String
    let merchDiscount: String
    let rideAccess: Bool
    
    init(from pass: Pass) {
        self.pass = pass
        self.fullname = pass.fullName
        self.passType = pass.passType
        self.foodDiscount = "• Food \(pass.swipe(discountOn: .food).message)"
        self.merchDiscount = "• Merchandise \(pass.swipe(discountOn: .food).message)"
        self.rideAccess = pass.swipe(rideAccess: .all).access
    }
    
}


/*
 if let pass = pass {
 
 passFullNameLabel.text = pass.fullName
 passTypeLabel.text = pass.passType
 foodDiscountLabel.text = "• Food \(pass.swipe(discountOn: .food).message)"
 merchDiscountLabel.text = "• Merchandise \(pass.swipe(discountOn: .food).message)"
 */
