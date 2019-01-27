//
//  UserStrings.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 1/26/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation

class UserStrings {
    
    enum MockData {
        static let firstName = "Harry"
        static let lastName = "Potter"
        static let company = "Acme"
        static let dob = "10/31/1981"
        static let ssn = "345-43-1234"
        static let projectNum = "1001"
        static let streetAddress = "300 Hogwarts Way"
        static let city = "Hogsmeade"
        static let state = "Scotland"
        static let zipcode = "40453"
    }
    
    enum Error {
        static let generalTitle = "Error Generating Pass"
        static let okTitle = "OK"
        static let errorWithType = "A pass could not be created from the type or subtype selected."
    }
}
