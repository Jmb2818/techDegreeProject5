//
//  DiscountAccess.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Enumeration for discount access types
enum DiscountAccess: String {
    case food
    case merchandise
}

extension DiscountAccess: CaseIterable {}
