//
//  RideAccess.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Enumeration for each type of ride access
enum RideAccess: String {
    case all
    case skipLines
}

extension RideAccess: CaseIterable {}
