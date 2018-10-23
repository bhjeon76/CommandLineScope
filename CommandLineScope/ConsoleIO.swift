//
//  ConsoleIO.swift
//  CommandLineScope
//
//  Created by 전병학 on 23/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) -idn ???")
    }
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        
        switch to {
        case .standard:
            print("\u{001B}[;m\(message)")
        case .error:
            fputs("\u{001B}[0;31m\(message)\n", stderr) //Red:31m, Green:32m, Yellow:33m, Blue:34m, Pink:35m, Cyon:36m,
        }
    }
    
    func getInput() -> String {
        
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: String.Encoding.utf8)
        
        return strData!.trimmingCharacters(in: CharacterSet.newlines)
    }
}
