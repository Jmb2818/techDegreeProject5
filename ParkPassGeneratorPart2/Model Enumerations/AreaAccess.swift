//
//  AreaAccess.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Enumeration for each type of area access
enum AreaAccess: String {
    case amusement
    case rideControl
    case kitchen
    case maintenance
    case office
}

extension AreaAccess: CaseIterable {}
