//
//  Formatter.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// Class created to format dates into various needed formats
class Formatter {
    static var dateFormatter = DateFormatter()
    
    // Function to format date of birth entered as string by user to actual date
    static func createDateOfBirthDate(fromString string: String?) -> Date? {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let dob = string, let dateOfBirth = dateFormatter.date(from: dob) else {
            return nil
        }
        return dateOfBirth
    }
    
    // Function to check if the date of birth of an entrant is the same date as current date
    static func isBirthday(dateOfBirth: Date) -> Bool {
        dateFormatter.dateFormat = "MMM d"
        let birthDay = dateFormatter.string(from: dateOfBirth)
        let currentDate = dateFormatter.string(from: Date())
        return birthDay == currentDate
    }
    
    // Function to get current Date's month and day
    static func getCurrentDateMonthDay() -> String {
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: Date())
    }
    
    // Function to format a string into a number if possible
    static func formatNumberFromString(_ stringNum: String?) -> Int? {
        if let numberString = stringNum {
            let numNoOtherChar = numberString.components(separatedBy:
                CharacterSet.decimalDigits.inverted).joined(separator: "")
            return Int(numNoOtherChar)
        }
        return nil
    }
}
