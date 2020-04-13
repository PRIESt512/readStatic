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
    let newId = String(subStr[subStr.startIndex + 1])
    person.append(User(name: newName, personNumber: newId, steps: []))
}

//print(newLines[newLines.startIndex])

//test(person: person)
//print(bugSHA(data: "88b0fd3a654de2c23e5bd474f92443540f03cacb6a5649d4188c2a7bbf6c30ec"))
//exit(0)

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
    if personStepMetrics[newPersonNumber] == nil {
        personStepMetrics[newPersonNumber] = []
    }
    personStepMetrics[newPersonNumber]?.append(StepMetrics(endDate: newEndDate, startDate: newStartDate, value: newValue, personNumber: newPersonNumber))
}

print("Поиск совпадений")

var personNumber = ""
var countStep = 0
var countPerson = 0
for var item in person {
    personNumber = item.personNumber
    for index in 0...50 {
        var hash = ""
        if(index <= 28) {
            hash = sha256(data: personNumber)
        } else {
            hash = bugSHA(data: personNumber)
        }
        let steps = personStepMetrics[hash]
        personNumber = hash

//        if(item.name == "Саша Вдовина"){
//            print(personNumber)
//        }

        guard let addSteps = steps else {
            //print("Нет - \(idPers)")
            continue
        }
        item.addSteps(addSteps)
        print("Person - \(item.name) added steps \(addSteps.count); index = \(index)")
        countStep += addSteps.count
        countPerson += 1

        personStepMetrics.remove(at: personStepMetrics.index(forKey: hash)!)
    }
}

print("Поиск по шагам окончен; всего добавлено - \(countStep) шагов для уникальный хешей - \(countPerson)")
print("Осталось - \(personStepMetrics.count)")

//var start = "01690451"
//var personNumber = start
//for index in 0...20 {
//    let hash = sha256(data: personNumber)
//    personNumber = hash
//    let pers = personStepMetrics[hash]
//    guard let id = pers else {
//        continue
//    }
//    print("Pers - \(hash) - \(id.count) - \(index)")
//}


