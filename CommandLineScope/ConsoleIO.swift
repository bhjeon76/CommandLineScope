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
        writeMessage("\(executableName) -a string1 string2")
    }
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
}
