//
//  Entrant.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Entrant to park and initializer
struct Entrant {
    let firstName: String?
    let lastName: String?
    let streetAddress: String?
    let city: String?
    let state: String?
    let zipCode: String?
    let ssn: Int?
    let dob: Date?
    let projectNum: String?
    
    var fullName: String {
        return "\(self.firstName ?? "") \(self.lastName ?? "")"
    }
    
    // Initializer setting everything to nil by default. Checked for correct info in creation of pass.
    init(firstName: String? = nil, lastName: String? = nil, streetAddress: String? = nil, city: String? = nil, state: String? = nil, zipCode: String? = nil, ssn: Int? = nil, dob: Date? = nil, projectNum: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.ssn = ssn
        self.dob = dob
        self.projectNum = projectNum
    }
    
    func employeeEntrant() -> String? {
        let emptyField = ""
        var emptyFields: [String] = []
        
        // Check to make sure all required employee information has been entered
        if firstName == nil || firstName == emptyField {
            emptyFields.append("First Name")
        }
        if lastName == nil || lastName == emptyField  {
            emptyFields.append("Last Name")
        }
        if streetAddress == nil || streetAddress == emptyField  {
            emptyFields.append("Street Address")
        }
        if city == nil || city == emptyField  {
            emptyFields.append("City")
        }
        if state == nil || state == emptyField {
            emptyFields.append("State")
        }
        if zipCode == nil || zipCode == emptyField {
            emptyFields.append("Zip Code")
        }
        if ssn == nil  {
            emptyFields.append("Social Security Number")
        }
        if dob == nil {
            emptyFields.append("Date of Birth")
        }
        // If any information is missing then throw an error telling user what is missing
        guard emptyFields.isEmpty else {
            var missingItems = ""
            for missingItem in emptyFields {
                if missingItems.isEmpty {
                    missingItems += " \(missingItem)"
                } else {
                    missingItems += ", \(missingItem)"
                }
            }
            let errorString = "Missing Fields: \(missingItems)"
            
            return errorString
        }
        return nil
    }
    
    func vendorEntrant() -> String?{
        let emptyField = ""
        var emptyFields: [String] = []
        
        // Check to make sure all required employee information has been entered
        if firstName == nil || firstName == emptyField {
            emptyFields.append("First Name")
        }
        if lastName == nil || lastName == emptyField  {
            emptyFields.append("Last Name")
        }
        if dob == nil {
            emptyFields.append("Date of Birth")
        }
        // If any information is missing then throw an error telling user what is missing
        guard emptyFields.isEmpty else {
            var missingItems = ""
            for missingItem in emptyFields {
                if missingItems.isEmpty {
                    missingItems += " \(missingItem)"
                } else {
                    missingItems += ", \(missingItem)"
                }
            }
            let errorString = "Missing Fields: \(missingItems)"
            
            return errorString
        }
        return nil
    }
    
    func isEntrantBirthday() -> Bool {
        if let dateOfBirth = self.dob {
            return DateEditor.isBirthday(dateOfBirth: dateOfBirth)
       }
        
        return false
    }
    
    
}

