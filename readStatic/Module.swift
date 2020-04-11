//
//  Module.swift
//  readStatic
//
//  Created by pleshkanev.a.a on 11.04.2020.
//  Copyright © 2020 pleshkanev.a.a. All rights reserved.
//

import Foundation

fileprivate let fileManager = FileManager.default

func readLineOfFile(for path: String, _ handlerNewLine: (String?) -> Void) {
    if !fileManager.fileExists(atPath: path) {
        print("File not exists for path: \(path)")
        handlerNewLine(nil)
        return
    }

    guard let data = fileManager.contents(atPath: path) else {
        print("Error get data of path: \(path)")
        handlerNewLine(nil)
        return
    }

    var currentIndex = data.startIndex
    var ofIndex = data.startIndex

    repeat {
        if let index = data[currentIndex...data.endIndex - 1].firstIndex(where: { Character(UnicodeScalar($0)) == newLineSeparator
        }) {
            currentIndex = index
            //print(String(bytes: data[ofIndex...currentIndex], encoding: .utf8)!)

            guard let newLine = String(bytes: data[ofIndex...currentIndex], encoding: .utf8) else {
                print("Error read string line")
                handlerNewLine(nil)
                continue
            }

            handlerNewLine(newLine)

            ofIndex = index
            currentIndex += 1
        } else {
            break
        }
    } while true
}
