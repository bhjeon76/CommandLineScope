//
//  ScopeShell.swift
//  CommandLineScope
//
//  Created by 전병학 on 23/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

enum OptionType: String {
    case idn        = "idn"
    case batout     = "batout"
    case usbout     = "usbout"
    case usbtopc    = "usbtopc"
    case time       = "time"
    case vol        = "vol"
    case autopower  = "autopower"
    case uart       = "uart"
    case scope      = "scope"
    case get        = "get"
    case file       = "file"
    case excel      = "excel"
    case device     = "device"
    case offset     = "offset"
    
    case help       = "h"
    case quit       = "q"
    case unknown
    
    init(value: String) {
        switch value {
        case "idn": self = .idn
        case "batout":  self = .batout
        case "usbout":  self = .usbout
        case "usbtopc": self = .usbtopc
        case "time":    self = .time
        case "vol":     self = .vol
        case "autopower":   self = .autopower
        case "uart":    self = .uart
        case "scope":   self = .scope
        case "get":     self = .get
        case "file":    self = .file
        case "excel":   self = .excel
        case "device":  self = .device
        case "offset":  self = .offset
            
        case "h":       self = .help
        case "q":       self = .quit
        default:        self = .unknown
        }
    }
}

class ScopeShell {
    
    let consoleIO = ConsoleIO()
    
    func staticMode() {
//        consoleIO.printUsage()
        //let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        
        let (option, value) = getOption(argument.substring(from: argument.index(argument.startIndex, offsetBy: 1)))
        //let (option, value) = getOption(String(argument[argument.index(argument.startIndex, offsetBy: 1)]))
        
        //consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
        
        parsingAguemnt(option: option, value: value)
    }
    
    func interactiveMode() {

        consoleIO.writeMessage("Welcom to ScopeShell.")
        
        var shouldQuit = false
        while !shouldQuit {
            
            consoleIO.writeMessage("Type 'h' to help type 'q' to quit.")
            let (option, _) = getOption(consoleIO.getInput())
            
            //consoleIO.writeMessage("terminal input -> Option: \(option) value: \(value)")
            
            switch option {

            case .unknown, .quit:
                shouldQuit = true
            case .idn, .help, .batout, .usbout, .usbtopc, .time, .vol, .autopower, .uart, .scope, .get, .file, .excel, .device, .offset:
                parsingAguemnt(option: option, value: "")
            }
        }
    }
    
    func parsingAguemnt(option: OptionType, value: String) {
        
        switch option {
        case .idn:
            consoleIO.writeMessage("idn processing...")
        case .batout:
            consoleIO.writeMessage("batout processing...")
        case .usbout:
            consoleIO.writeMessage("usbout processing...")
        case .usbtopc:
            consoleIO.writeMessage("usbtopc processing...")
        case .time:
            consoleIO.writeMessage("time processing...")
        case .vol:
            consoleIO.writeMessage("vol processing...")
        case .autopower:
            consoleIO.writeMessage("autopower processing...")
        case .uart:
            consoleIO.writeMessage("uart processing...")
        case .scope:
            consoleIO.writeMessage("scope processing...")
        case .get:
            consoleIO.writeMessage("get processing...")
        case .file:
            consoleIO.writeMessage("file processing...")
        case .excel:
            consoleIO.writeMessage("execl processing...")
        case .device:
            consoleIO.writeMessage("device processing...")
        case .offset:
            consoleIO.writeMessage("offset processing...")
            
            
        case .help:
            consoleIO.printUsage()
        case .unknown, .quit:
            consoleIO.writeMessage("Unknown option \(value)", to: .error)
            consoleIO.printUsage()
        }
    }
    
    func getOption(_ option: String) -> (option: OptionType, value: String) {
        return (OptionType(value: option), option)
    }
   
}
