//
//  GuestType.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// An enumeration for each type of guest there can be
enum GuestType: String {
    case adult = "Adult"
    case vip = "VIP"
    case child = "Child"
    case senior = "Senior"
    case seasonPass = "Season Pass"
}

extension GuestType: CaseIterable {}
