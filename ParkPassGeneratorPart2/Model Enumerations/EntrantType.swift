//
//  EntrantType.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/15/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

enum EntrantType: String {
    case Guest = "Guest"
    case Employee = "Employee"
    case Manager = "Manager"
    case Vendor = "Vendor"
}

extension EntrantType: CaseIterable {}
