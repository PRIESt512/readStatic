//
//  main.swift
//  readStatic
//
//  Created by pleshkanev.a.a on 11.04.2020.
//  Copyright © 2020 pleshkanev.a.a. All rights reserved.
//

import Foundation

print("Start")

var person: [User] = []
var personStepMetrics: [String: Array<StepMetrics>] = [:]

//Читаем всех пользователей системы
readLineOfFile(for: pathCore) { newLine in
    guard let line = newLine else {
        return
    }
    if(line.count <= 5) {
        return
    }
    let subStr = line.split(separator: semicolonSeparator)
    let newName = String(subStr[subStr.startIndex])
    let newId = Int(String(subStr[subStr.startIndex + 1])) ?? 0
    person.append(User(name: newName, personNumber: newId))
}

//print(newLines[newLines.startIndex])

//Читаем шаги по всем пользователям и собираем
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
readLineOfFile(for: pathStepMetrics) { newLine in
    guard let line = newLine else {
        return
    }
    if(line.count <= 5) {
        return
    }
    let subStr = line.split(separator: semicolonSeparator)

    let startIndex = subStr.startIndex
    guard
        let newEndDate = dateFormatter.date(from: String(subStr[startIndex + 1])),
        let newStartDate = dateFormatter.date(from: String(subStr[startIndex + 3])),
        let newValue = Double(String(subStr[startIndex + 2])) else {
            print("Error create step metrics: \(line)")
            return
    }

    let newPersonNumber = String(subStr[subStr.startIndex + 4])
    let trimmingString = newPersonNumber.trimmingCharacters(in: .newlines)
    if personStepMetrics[trimmingString] == nil {
        personStepMetrics[trimmingString] = []
    }
    personStepMetrics[trimmingString]?.append(StepMetrics(endDate: newEndDate, startDate: newStartDate, value: newValue, personNumber: trimmingString))
}

print("REr")
