//
//  LogController.swift
//  Smart Power Scope
//
//  Created by 정다정 on 2016. 9. 22..
//  Copyright © 2016년 SHmobile Co., LTD. All rights reserved.
//

import Cocoa


class LogController
{
    func initLogDirectory() -> Void
    {
        let fileManager = FileManager.default
        
        let strHomeDir = NSHomeDirectory()
        let strPowerDir = strHomeDir + "/PowerData"
        let strLogDir = strPowerDir + "/Log"
        
        //create directory
        do {
            try fileManager.createDirectory(atPath: strLogDir, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        //delete log file daily
        deleteLogFile(())
    }
    
    func saveLogData(_ strLogData:String) -> Void
    {
        let strHomeDir = NSHomeDirectory()
        let strPowerDir = strHomeDir + "/PowerData"
        let strLogDir = strPowerDir + "/Log"
        
        //set log title (date)
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone.current
        
        let localDate = dateFormatter.string(from: date)
        
        let strLogPath = strLogDir + "/ResultLog_" + localDate + ".log"
        
        //write log
        let outputStream:OutputStream = OutputStream(toFileAtPath: strLogPath, append: true)!
        
        let logDate = Date()
        let logDateFormatter = DateFormatter()
        
        logDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        logDateFormatter.timeZone = TimeZone.current
        
        let logLocalDate = logDateFormatter.string(from: logDate)
        
        let logData:String = "[" + logLocalDate + "] " + strLogData + "\r\n"
        
        print("\(strLogData)")
        
        let ptrLogData = [UInt8](logData.utf8)
        
        outputStream.open()
        outputStream.write(ptrLogData, maxLength: ptrLogData.count)
        outputStream.close()
    }
    
    func deleteLogFile(_: Void) -> Void {
        
        let strHomeDir = NSHomeDirectory()
        let strPowerDir = strHomeDir + "/PowerData"
        let strLogDir = strPowerDir + "/Log"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone.current
        
        let localDate = dateFormatter.string(from: date)
        
        let fileManager = FileManager.default
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: strLogDir)!
        
        while let element = enumerator.nextObject() as? String {
            
            if(element.hasSuffix(".log")) {
                //print(element)
                
                var strDate = element
                strDate = strDate.replacingOccurrences(of: "ResultLog_", with: "")
                strDate = strDate.replacingOccurrences(of: ".log", with: "")
                
                if(strDate != localDate) {
                    
                    do {
                        try fileManager.removeItem(atPath: strLogDir + "/" + element)
                        
                        saveLogData("deleteLogFile() \(element)")
                    }
                    catch let error as NSError {
                        print("removeItem(\(strLogDir)/\(element)) error: \(error)")
                    }
                }
            }
        }
    }
}
