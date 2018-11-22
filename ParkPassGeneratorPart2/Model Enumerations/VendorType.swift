//
//  VendorType.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/19/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

enum VendorType: String {
    case Acme = "Acme"
    case Orkin = "Orkin"
    case Fedex = "Fedex"
    case NWElectrical = "NW Electrical"
}

extension VendorType: CaseIterable {}
