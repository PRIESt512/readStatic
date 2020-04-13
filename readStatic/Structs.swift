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
    let vsp: String
    let personNumber: String
    var steps: Set<StepMetrics>
    var histogramSteps: Dictionary<String, Int> = [:]

    mutating func addSteps(_ steps: [StepMetrics]) {
        self.steps.formUnion(steps)
    }
    
    mutating func setHistogram(_ hist: Dictionary<String, Int>) {
        self.histogramSteps = hist
    }
}

struct StepMetrics: CustomDebugStringConvertible {
    var debugDescription: String {
        String(format: "StartDate - %@, EndDate - %@, Value - %f, Number - $@", self.startDate.debugDescription, self.endDate.debugDescription, self.value, self.personNumber)
    }

    let endDate: Date
    let startDate: Date
    let value: Double
    let personNumber: String
}

extension StepMetrics: Hashable {

    static func == (lhs: StepMetrics, rhs: StepMetrics) -> Bool {
        return lhs.endDate == rhs.endDate &&
            lhs.startDate == rhs.startDate &&
            lhs.value == rhs.value &&
            lhs.personNumber == rhs.personNumber
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(endDate)
        hasher.combine(startDate)
        hasher.combine(value)
        hasher.combine(personNumber)
    }
}

extension StepMetrics: Comparable {
    static func < (lhs: StepMetrics, rhs: StepMetrics) -> Bool {
        if lhs.startDate != rhs.startDate {
            return lhs.startDate < rhs.startDate
        } else if lhs.endDate != rhs.endDate {
            return lhs.endDate < rhs.endDate
        } else if lhs.value != rhs.value {
            return lhs.value < rhs.value
        } else {
            return lhs.personNumber < rhs.personNumber
        }
    }
}

func test(person: [User]) {
    var personNumber = ""
    for item in person {
        personNumber = item.personNumber
        for _ in 0...50 {
            let hash = sha256(data: personNumber)
            if(hash == "5e0a117ef80e520c1cc6b6e80505deb541b8bf06207941ffb2aeb4cf8b93f78f") {
                print("Bingo")
            }
            personNumber = hash
        }
    }
}
