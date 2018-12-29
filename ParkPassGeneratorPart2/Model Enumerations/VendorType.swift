//
//  VendorType.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/19/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

enum VendorType: String {
    case acme = "Acme"
    case orkin = "Orkin"
    case fedex = "Fedex"
    case nwElectrical = "NW Electrical"
}

extension VendorType: CaseIterable {}
