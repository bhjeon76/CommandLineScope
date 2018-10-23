//
//  ScopeShell.swift
//  CommandLineScope
//
//  Created by 전병학 on 23/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

enum OptionType: String {
    case idn = "idn"
    case help = "h"
    case quit = "q"
    case unknown
    
    init(value: String) {
        switch value {
        case"idn": self = .idn
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
    }
}

class ScopeShell {
    
    let consoleIO = ConsoleIO()
    
    func staticMode() {
//        consoleIO.printUsage()
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        
        let (option, value) = getOption(argument.substring(from: argument.index(argument.startIndex, offsetBy: 1)))

        consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
        
        switch option {
        case .idn:
            consoleIO.writeMessage("idn processing...")
        case .help:
            consoleIO.printUsage()
        case .unknown, .quit:
            consoleIO.writeMessage("Unknown option \(value)", to: .error)
            consoleIO.printUsage()
        }
    }
    
    func interactiveMode() {

        consoleIO.writeMessage("Welcom to ScopeShell.")
        
        var shouldQuit = false
        while !shouldQuit {
            
            consoleIO.writeMessage("Type 'h' to help type 'q' to quit.")
            let (option, value) = getOption(consoleIO.getInput())
            
            consoleIO.writeMessage("terminal input -> Option: \(option) value: \(value)")
            
            switch option {
            case .idn:
                consoleIO.writeMessage("idn processing...")
            case .help:
                consoleIO.printUsage()
            case .unknown, .quit:
                shouldQuit = true
            }
        }
    }
    
    func getOption(_ option: String) -> (option: OptionType, value: String) {
        return (OptionType(value: option), option)
    }
   
}
