//
//  main.swift
//  CommandLineScope
//
//  Created by 전병학 on 22/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

class SerialHandler : NSObject, ORSSerialPortDelegate {
    
    var serialPort: ORSSerialPort?
    
    // ORSSerialPortDelegate
    
    
    
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        if let string = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
            print("\(string)")
        }
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was remove")
    }
   
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        
        print("serialPortWasOpened() \(serialPort.name)")
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        
        print("serialPortWasClosed() \(serialPort.name)")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        
        if let string = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
            print("\(string)")
        }
    }
}
//print("Hello, World! Command Line Scope")

let scopeShell = ScopeShell()

if CommandLine.argc < 2 { // without argument
    scopeShell.interactiveMode()
} else { // with argument
    scopeShell.staticMode()
}

