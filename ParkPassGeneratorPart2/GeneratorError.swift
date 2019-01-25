//
//  GeneratorError.swift
//  ParkPassGeneratorPart2
//
//  Created by Joshua Borck on 11/8/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

// An enumeration of all the errors while generating a pass
enum GeneratorError: Error {
    case incorrectSubtype(String)
    case missingInformation(String)
    case olderThanFive(String)
    case missingProjectNumber(String)
    case generic
    
    func getErrorMessage() -> String {
        switch self {
        case .incorrectSubtype(let message):
            return message
        case .missingInformation(let message):
            return message
        case .olderThanFive(let message):
            return message
        case .missingProjectNumber(let message):
            return message
        default:
            return "We are sorry, something did not work correctly."
        }
    }
}
