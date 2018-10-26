//
//  main.swift
//  CommandLineScope
//
//  Created by 전병학 on 22/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

class SerialHandler : NSObject, ORSSerialPortDelegate {
    
    let standardInputFileHandle = FileHandle.standardInput
    var serialPort: ORSSerialPort?
    
    func runProcessingInput() {
        setbuf(stdout, nil)
        
        standardInputFileHandle.readabilityHandler = { (fileHandle: FileHandle!) in
            let data = fileHandle.availableData
            DispatchQueue.main.async(execute: { () -> Void in
                self.handleUserInput(dataFromUser: data as NSData)
            })
        }
        
        self.serialPort = ORSSerialPort(path: "/dev/cu.Repleo-PL2303-00401414") // please adjust to your handle
        self.serialPort?.baudRate = 9600
        self.serialPort?.delegate = self
        serialPort?.open()
        
        RunLoop.current.run() // loop
    }
    
    
    func handleUserInput(dataFromUser: NSData) {
        if let string = NSString(data: dataFromUser as Data, encoding: String.Encoding.utf8.rawValue) as String? {

            if string.hasPrefix("exit") ||
                string.hasPrefix("quit") {
                
                print("Quitting...")
                exit(EXIT_SUCCESS)
            }
            self.serialPort?.send(dataFromUser as Data)
        }
    }
    
    
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

print("Starting serial test program")
print("To quit type: 'exit' or 'quit'")
SerialHandler().runProcessingInput()

//let scopeShell = ScopeShell()
//
//if CommandLine.argc < 2 { // without argument
//    scopeShell.interactiveMode()
//} else { // with argument
//    scopeShell.staticMode()
//}

