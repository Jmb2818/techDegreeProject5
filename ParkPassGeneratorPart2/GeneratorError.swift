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
}
