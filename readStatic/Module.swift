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
fileprivate var fileHandleWriter: Optional<FileHandle> = nil
fileprivate let newLine = "\n".data(using: .utf8)!

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

func writeLineFile(_ line: String) {
    if fileHandleWriter == nil {
        if !fileManager.fileExists(atPath: statisctics) {
            if !fileManager.createFile(atPath: statisctics, contents: nil, attributes: nil) {
               print("Ошибка создания файла")
            }
        }
        fileHandleWriter = FileHandle(forWritingAtPath: statisctics)
    }
    
    guard let data = line.data(using: .utf8) else {
        print("Ошибка записи в файл")
        return
    }
    
    fileHandleWriter?.write(data)
    fileHandleWriter?.write(newLine)
}

func closeFile() {
    fileHandleWriter?.closeFile()
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
    
    var hash = hashed.compactMap { String(format: "%02x", $0) }.joined()
    
    for _ in 0...5 {
        if(hash[hash.startIndex] == "0") {
            hash.removeFirst()
        }
    }
    
    return hash
}
