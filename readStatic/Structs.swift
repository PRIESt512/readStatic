//
//  Structs.swift
//  readStatic
//
//  Created by pleshkanev.a.a on 12.04.2020.
//  Copyright © 2020 pleshkanev.a.a. All rights reserved.
//

import Foundation

struct User: CustomDebugStringConvertible {
    var debugDescription: String {
        String(format: "Name - %@, id - %d", self.name, self.personNumber)
    }

    let name: String
    let personNumber: String
    var steps: [StepMetrics]
    
    mutating func addSteps(_ steps: [StepMetrics]) {
        self.steps += steps
    }
}

struct StepMetrics: CustomDebugStringConvertible {
    var debugDescription: String {
        String(format: "StartDate - %@, EndDate - %@, Value - %E, Number - $@", self.startDate.debugDescription, self.endDate.debugDescription, self.value, self.personNumber)
    }
    
    let endDate: Date
    let startDate: Date
    let value: Double
    let personNumber: String
}
