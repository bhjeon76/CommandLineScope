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
        writeMessage("\(executableName) -idn: return device info:ModelName/SerialNo")
        writeMessage("\(executableName) -batout on/off: batout on/off controll")
        writeMessage("\(executableName) -oubout on/off: usbout on/off controll")
        writeMessage("\(executableName) -time: return measute time infomation")
        writeMessage("\(executableName) -vol 4.25V: batout voltage control")
        writeMessage("\(executableName) -autopower on/off: autopower on/off controll")
        writeMessage("\(executableName) -uart on/off: uart path on/off controll")
        writeMessage("\(executableName) -scope start/stop: scope start/stop controll")
        writeMessage("\(executableName) -get avr measurement/recent/filename: retrun data")
        writeMessage("\(executableName) -file: return result file list")
        writeMessage("\(executableName) -execel: setting method for save execel file")
        writeMessage("\(executableName) -device: return device status infomation")
        writeMessage("\(executableName) -offset: setting for time offset")
    }
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        

        switch to {
        case .standard:
            print("\(message)") // print("\u{001B}[;m\(message)")
        case .error:
            fputs("\(message)\n", stderr) //fputs("\u{001B}[0;31m\(message)\n", stderr) //Red:31m, Green:32m, Yellow:33m, Blue:34m, Pink:35m, Cyon:36m,
        }

    }
    
    func getInput() -> String {
        
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: String.Encoding.utf8)
        
        return strData!.trimmingCharacters(in: CharacterSet.newlines)
    }
}
