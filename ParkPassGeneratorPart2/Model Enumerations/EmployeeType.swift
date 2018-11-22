//
//  EmployeeType.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Enumeration for each type of employee and associated formatted string for printout
enum EmployeeType: String {
    case food = "Food"
    case ride = "Ride Operator"
    case maintenance = "Maintenance"
    case manager = "Manager"
}

extension EmployeeType: CaseIterable {}
