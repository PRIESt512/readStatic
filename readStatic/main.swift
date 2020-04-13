//
//  main.swift
//  readStatic
//
//  Created by pleshkanev.a.a on 11.04.2020.
//  Copyright © 2020 pleshkanev.a.a. All rights reserved.
//

import Foundation

print("Start")

var people: [User] = []
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

    var newVsp = ""
    if(subStr.count > 2) {
        newVsp = String(subStr[subStr.startIndex + 2])
    }
    people.append(User(name: newName, vsp: newVsp, personNumber: newId, steps: []))
}

//test(person: person)
//print(bugSHA(data: "88b0fd3a654de2c23e5bd474f92443540f03cacb6a5649d4188c2a7bbf6c30ec"))
//exit(0)

//Читаем шаги по всем пользователям и собираем
var dateFormatter = DateFormatter()
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

var countStep = 0
var countPerson = 0
for indexPeople in people.indices {
    var personNumber = people[indexPeople].personNumber
    for index in 0...50 {
        var hash = ""
        if(index == 0) {
            hash = sha256(data: personNumber)
        } else {
            hash = bugSHA(data: personNumber)
        }
        let steps = personStepMetrics[hash]
        personNumber = hash

        guard let addSteps = steps else {
            //print("Нет - \(idPers)")
            continue
        }
        people[indexPeople].addSteps(addSteps)
        print("Person - \(people[indexPeople].name) added steps \(addSteps.count); index = \(index)")
        countStep += addSteps.count
        countPerson += 1

        personStepMetrics.remove(at: personStepMetrics.index(forKey: hash)!)
    }
}

print("Поиск по шагам окончен; всего добавлено - \(countStep) шагов для уникальный хешей - \(countPerson)")
print("Осталось - \(personStepMetrics.count)")

dateFormatter.dateFormat = "yyyy.MM"
let dateForm = DateFormatter()
dateForm.dateFormat = "yyyy.MM.dd"
for index in people.indices {
    
    var dateMonth = ""
    var dateDay = ""
    //var day: Date = Date(timeIntervalSince1970: 1577836800)//первое января 2020
    
    
    let histogram = people[index].steps.sorted().reduce(into: [:]) { (counts: inout [String: Int], personStep: StepMetrics) in
        
        let tempMonth = dateFormatter.string(from: personStep.startDate)
        let tempDay = dateForm.string(from: personStep.startDate)
        
        if dateMonth == tempMonth && tempDay != dateDay {
            counts[tempMonth, default: 0] += 1
            dateDay = tempDay
            return
        } else if dateMonth != tempMonth {
            counts[tempMonth, default: 0] += 1
            dateMonth = tempMonth
            //day = startDate
            dateDay = tempDay
            return
        }
        dateMonth = tempMonth
        dateDay = tempDay
    }
    people[index].setHistogram(histogram)
}

print("WriteToFile")
writeLineFile("Имя;Номер;Табельник;Январь (дн.);Февраль (дн.);Март (дн.);Апрель (дн.)")
let header: Set<String> = ["2020.01", "2020.02", "2020.03", "2020.04"]

for person in people {
    var line = "\(person.name);\(person.vsp);\(person.personNumber);"

    for item in header.sorted() {
        line += "\(person.histogramSteps[item, default: 0]);"
    }
    
    writeLineFile(line)
}

closeFile()

print("Finish")




