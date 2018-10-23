//
//  ScopeShell.swift
//  CommandLineScope
//
//  Created by 전병학 on 23/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

enum OptionType: String {
    case help = "h"
    case unknown
    
    init(value: String) {
        switch value {
        case "h": self = .help
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
    }
    
    func getOption(_ option: String) -> (option: OptionType, value: String) {
        return (OptionType(value: option), option)
    }
   
}
