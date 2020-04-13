//
//  Module.swift
//  readStatic
//
//  Created by pleshkanev.a.a on 11.04.2020.
//  Copyright © 2020 pleshkanev.a.a. All rights reserved.
//

import Foundation
import CryptoKit

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
        if let index = data[currentIndex...data.endIndex - 1].firstIndex(where: { Character(UnicodeScalar($0)) == newLineSeparator }) {

            currentIndex = index
            //print(String(bytes: data[ofIndex...currentIndex], encoding: .utf8)!)

            guard let newLine = String(bytes: data[ofIndex...currentIndex], encoding: .utf8) else {
                print("Error read string line")
                handlerNewLine(nil)
                continue
            }

            handlerNewLine(newLine.trimmingCharacters(in: .newlines))

            ofIndex = index
            currentIndex += 1
        } else {
            break
        }
    } while true
}

func sha256(data: String) -> String {
    guard let personalNumber = data.data(using: .utf8) else {
        fatalError("*** This method should never fail - get hashed number***")
    }
    let hashed = SHA256.hash(data: personalNumber)
    //print(hashed.compactMap { String(format: "%02x", $0) }.joined())
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

func bugSHA(data: String) -> String {
    guard let personalNumber = data.data(using: .utf8) else {
        fatalError("*** This method should never fail - get hashed number***")
    }
    let hashed = SHA256.hash(data: personalNumber)
    var str2 = ""
    for item in hashed {
        str2 += String(format: "%02x", item)
    }
    if(str2[str2.startIndex] == "0") {
        str2.removeFirst();
    }
    if(str2[str2.startIndex] == "0") {
        str2.removeFirst();
    }
    if(str2[str2.startIndex] == "0") {
        str2.removeFirst();
    }
    if(str2[str2.startIndex] == "0") {
        str2.removeFirst();
    }
    return str2
    //return hashed.compactMap { String($0, radix: 16) }.joined()
}
