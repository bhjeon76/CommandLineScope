//
//  FileController.swift
//  Smart Power Scope
//
//  Created by 전병학 on 3/18/16.
//  Copyright © 2016 SHmobile Co., LTD. All rights reserved.
//

import Cocoa

protocol FileControllerDelegate {
    
    func returnFileDataGraphProcess(_ controller:FileController, dVoltage:Double, dCurrent:Double, updateInfo:UpdateStatus)
    
    func returnFileDataProgressMsg(_ controller:FileController, strMsg:String)
}

let RAW_DATA_HEADER_SIZE = 128
let RAW_DATA_FOOTER_SIZE = 128

struct SaveFileStatus {
    
    var strFilePath:String
    var strFileName:String
    var strFileFullPath:String
    var strVersion:String
    var strSaveTime:String
    var strBatVolt:String
    var strDevice:String
    var strScale:String
    var strAverage:String
    var strRunTime:String
    
    var bExportCSV:Bool
    var strExportFilePath:String
    var ExportFileTime:DateComponents
    var ExportDivisionTime:UInt32
    var ExportCSVCount:UInt64
}

struct OpenFileStatus {
    
    var bUpdate:Bool
    var strSelectFilePath:String
    var nFileSize:UInt64
    var nHeaderSize:UInt64
    var nFooterSize:UInt64
    var dRunTime:Double
    var strVersionInfo:String
    var strTimeInfo:String
    var strFileName:String
    var strBatVolt:String
    var strDeviceInfo:String
    var scopeMode:scopeType
    var scaleMode:scaleType
    var strAverage:String
    var strRunTime:String
    
    var scopeVoltage:Double //Scope Voltage Average Every Packet Parsing
    var scopeCurrent:Double //Scope Current Average Every Packet Parsing
    var startPos:Double
    var endPos:Double
    var scopeCount:UInt64   //Scope Total Count
}

struct UpdateStatus {
    
    var bState:Bool
    var startPos:Double
    var endPos:Double
    var totalCount:UInt64
    var updateCount:UInt64
    var bPartial:Bool
    
    var nRawDataSize:UInt64
    var nStartPosition:UInt64
    var nEndPosition:UInt64
    
    var nFileLoadCnt:UInt64
    var nFileUpdateCnt:UInt64
    var nRemainCnt:UInt64
    
    var nStartUpdatePos:UInt64
    var nEndUpdatePos:UInt64
    
    var nGraphUpdateSize:UInt64
}

struct SpareCSV {
    
    var addCurrent:Double
    var addVoltage:Double
    var addPower:Double
    
    var addTimeDivision:UInt32
    var addCount:Int
    
    var addFileTime:DateComponents
    
}

struct RawDataParsingInfo {
    
    var fileHandle:FileHandle
    var readfileHeaderLocation:UInt64
    var readfileLocation:UInt64
    var readBufferCount:Int
    var garbageDataCount:UInt64
    var scopeUpdateSize:UInt64
    var scopeDataCount:Int
    var updateDataCount:UInt64
    var currentSum:Double
    var voltageSum:Double
}

let logController = LogController()

class FileController: FileManager {
    
    var fileControldelegate:FileControllerDelegate?
    
    var SaveInfo = SaveFileStatus(strFilePath: "", strFileName: "", strFileFullPath: "", strVersion: "Ver: 1.0.0", strSaveTime: "", strBatVolt: "", strDevice: "", strScale: "Coarse", strAverage: "", strRunTime: "", bExportCSV: false, strExportFilePath: "", ExportFileTime: DateComponents(), ExportDivisionTime: 1000000, ExportCSVCount: 0)
    
    var OpenInfo = OpenFileStatus(bUpdate: false, strSelectFilePath: "", nFileSize: 0, nHeaderSize: 0, nFooterSize: 0, dRunTime: 0, strVersionInfo: "", strTimeInfo: "", strFileName: "", strBatVolt: "", strDeviceInfo: "", scopeMode: .bat_OUT, scaleMode: .coarse, strAverage: "", strRunTime: "", scopeVoltage: 0.0, scopeCurrent: 0.0, startPos: 0.0, endPos: 0.0, scopeCount: 0)
    
    var OpenSlaveInfo = OpenFileStatus(bUpdate: false, strSelectFilePath: "", nFileSize: 0, nHeaderSize: 0, nFooterSize: 0, dRunTime: 0, strVersionInfo: "", strTimeInfo: "", strFileName: "", strBatVolt: "", strDeviceInfo: "", scopeMode: .bat_OUT, scaleMode: .coarse, strAverage: "", strRunTime: "", scopeVoltage: 0.0, scopeCurrent: 0.0, startPos: 0.0, endPos: 0.0, scopeCount: 0)
    
    var UpdateInfo = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
    
    var UpdateSlaveInfo = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
    
    var OpenParserInfo = OpenFileStatus(bUpdate: false, strSelectFilePath: "", nFileSize: 0, nHeaderSize: 0, nFooterSize: 0, dRunTime: 0, strVersionInfo: "", strTimeInfo: "", strFileName: "", strBatVolt: "", strDeviceInfo: "", scopeMode: .bat_OUT, scaleMode: .coarse, strAverage: "", strRunTime: "", scopeVoltage: 0.0, scopeCurrent: 0.0, startPos: 0.0, endPos: 0.0, scopeCount: 0)
    
    var UpdateParserInfo = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
    
    var rawDataParsingBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //
    var rawDataParsingBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //
    
    var fileToGraphBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전류
    var fileToGraphBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전압
    
    var slaveFileToGraphBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전류
    var slaveFileToGraphBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전압
    
    var spareCSV = SpareCSV(addCurrent: 0.0, addVoltage: 0.0, addPower: 0.0, addTimeDivision: 0, addCount: 0, addFileTime: DateComponents())
    
    var addCSVTime:UInt64 = 0
    
    //let graphControl = GraphControl()
    var m_FileCurrentUnit:Double = 1.0
    
    func resultFolderInit() -> Void
    {
        let fileManager = FileManager.default
        let strHomeDir = NSHomeDirectory()
        let strPowerDir = strHomeDir + "/PowerData/"
        
        do {
            try fileManager.createDirectory(atPath: strPowerDir, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    func clearFileData() -> Void
    {
        SaveInfo = SaveFileStatus(strFilePath: "", strFileName: "", strFileFullPath: "", strVersion: "Ver: 1.0.0", strSaveTime: "", strBatVolt: "", strDevice: "", strScale: "Coarse", strAverage: "", strRunTime: "", bExportCSV: false, strExportFilePath: "", ExportFileTime: DateComponents(), ExportDivisionTime: 1000000, ExportCSVCount: 0)
        
        OpenInfo = OpenFileStatus(bUpdate: false, strSelectFilePath: "", nFileSize: 0, nHeaderSize: 0, nFooterSize: 0, dRunTime: 0, strVersionInfo: "", strTimeInfo: "", strFileName: "", strBatVolt: "", strDeviceInfo: "", scopeMode: .bat_OUT, scaleMode: .coarse, strAverage: "", strRunTime: "", scopeVoltage: 0.0, scopeCurrent: 0.0, startPos: 0.0, endPos: 0.0, scopeCount: 0)
        
        OpenSlaveInfo = OpenFileStatus(bUpdate: false, strSelectFilePath: "", nFileSize: 0, nHeaderSize: 0, nFooterSize: 0, dRunTime: 0, strVersionInfo: "", strTimeInfo: "", strFileName: "", strBatVolt: "", strDeviceInfo: "", scopeMode: .bat_OUT, scaleMode: .coarse, strAverage: "", strRunTime: "", scopeVoltage: 0.0, scopeCurrent: 0.0, startPos: 0.0, endPos: 0.0, scopeCount: 0)
        
        UpdateInfo = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
        UpdateSlaveInfo = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
        
        OpenParserInfo = OpenFileStatus(bUpdate: false, strSelectFilePath: "", nFileSize: 0, nHeaderSize: 0, nFooterSize: 0, dRunTime: 0, strVersionInfo: "", strTimeInfo: "", strFileName: "", strBatVolt: "", strDeviceInfo: "", scopeMode: .bat_OUT, scaleMode: .coarse, strAverage: "", strRunTime: "", scopeVoltage: 0.0, scopeCurrent: 0.0, startPos: 0.0, endPos: 0.0, scopeCount: 0)
        
        UpdateParserInfo = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
        
        rawDataParsingBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //
        rawDataParsingBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //
        
        fileToGraphBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전류
        fileToGraphBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전압
        
        slaveFileToGraphBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전류
        slaveFileToGraphBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE) //graph buffer에 들어갈 실 데이터: 전압
        
        spareCSV = SpareCSV(addCurrent: 0.0, addVoltage: 0.0, addPower: 0.0, addTimeDivision: 0, addCount: 0, addFileTime: DateComponents())
        
        addCSVTime = 0
    }
    
    func createPowerDataToBin(_ strTime:String, strScopeMode:String, strBatVolt:String, strDevice:String, strVersion:String, strScaleMode:String) -> Bool
    {
        var status:Bool = false
        
        let strModeName = strScopeMode.replacingOccurrences(of: "_", with: "")
        
        let strHomeDir = NSHomeDirectory()
        let strPowerDir = strHomeDir + "/PowerData"
        
        
        SaveInfo.strFilePath = strPowerDir
        SaveInfo.strFileName = NSString(format: "SmartPowerScope_%@_%@.bin", strTime, strModeName) as String
        SaveInfo.strVersion = strVersion
        SaveInfo.strBatVolt = strBatVolt
        SaveInfo.strDevice = strDevice
        SaveInfo.strSaveTime = strTime

        SaveInfo.strFileFullPath = SaveInfo.strFilePath + "/" + SaveInfo.strFileName
        let saveFullPath = SaveInfo.strFileFullPath
        
        let strHeader = NSString(format: "$Ver:%@,Time:%@,FileName:%@,%@,%@,%@",strVersion, strTime, SaveInfo.strFileName, strBatVolt, strDevice, strScaleMode) as String

        //writing
        do {
            try strHeader.write(toFile: saveFullPath, atomically: false, encoding: String.Encoding.utf8)
            
            status = true
            
        } catch {
            
            status = false
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        return status
    }
    
    func addPowerDataFooterToBin(_ strAverage:String, strRunTime:String) -> Bool
    {
        let status:Bool = false
        
        SaveInfo.strAverage = strAverage
        SaveInfo.strRunTime = strRunTime
        
        let saveFullPath = SaveInfo.strFileFullPath
        
        let strFooter = NSString(format: "$Avg:%@,RunTime:%@", strAverage, strRunTime) as String
        
        print("strFooter = \(strFooter)")
        
        let outputStream:OutputStream = OutputStream(toFileAtPath: saveFullPath, append: true)!
        
        let ptrData = [UInt8](strFooter.utf8)

        outputStream.open()
        outputStream.write(ptrData, maxLength: RAW_DATA_FOOTER_SIZE)//footer info는 무조건 128byte 저장되도록 변경
        outputStream.close()
        
        return status
    }

    
    func openPowerDataToBin() -> Bool
    {
        var status:Bool = false

        let strVersion = SaveInfo.strVersion
        let strTime = SaveInfo.strSaveTime
        let strBatVolt = SaveInfo.strBatVolt
        let strDevice = SaveInfo.strDevice
        
        let strHeader = NSString(format: "$%@,Time:%@,FileName:%@,%@,%@",strVersion, strTime, SaveInfo.strFileName, strBatVolt, strDevice) as String
        let saveFullPath = SaveInfo.strFileFullPath

        //writing
        do {
            try strHeader.write(toFile: saveFullPath, atomically: false, encoding: String.Encoding.utf8)
            
            status = true
            
        } catch {
            
            status = false
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        return status
    }
    
    func addPowerDataToBin(_ dataArray: [UInt8], size:Int) -> Void
    {
        let saveFullPath = SaveInfo.strFileFullPath
        
        let file = FileHandle(forReadingAtPath: saveFullPath)
        
        if (file == nil) {
            _ = openPowerDataToBin()
        }

        let outputStream:OutputStream = OutputStream(toFileAtPath: saveFullPath, append: true)!
        
        let ptrData = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        memcpy(ptrData, dataArray, size)
 
        //Enter Backgroud Processing
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        queue.async(execute: { () -> () in
            
            outputStream.open()
            outputStream.write(ptrData, maxLength: size)
            outputStream.close()
            
        }) //End Background Processing
    }
 
    func getUpdateInfo(_ openInfo:OpenFileStatus, startPos:Double, endPos:Double) -> UpdateStatus
    {
        var updateInfo:UpdateStatus = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
        
        updateInfo.bState = true
        updateInfo.nRawDataSize = openInfo.nFileSize - openInfo.nHeaderSize
        
        if (updateInfo.nRawDataSize <= 0) {
            updateInfo.bState = false
            return updateInfo
        }
        
        //1. Update 할 시간을 가져올 파일 위치로 변환 한다.
        updateInfo.nStartPosition = (UInt64)(startPos * ((Double)(LOAD_READ_BUF_MAX) / 20.0))
        updateInfo.nEndPosition = 0
        
        //2. EndPosition Calculate
        if (endPos > openInfo.dRunTime) { //endPosition 위치가 전체 Runtime 보다 크면 Runtime 까지만 Update 한다.
            updateInfo.nEndPosition = (UInt64)(openInfo.dRunTime * ((Double)(LOAD_READ_BUF_MAX) / 20.0))
        }
        else {
            updateInfo.nEndPosition = (UInt64)(endPos * ((Double)(LOAD_READ_BUF_MAX) / 20.0))
        }
        
        //시간 단위 좌표에서 계산된 Update 할 파일 위치가 실제 파일 크기보다 클 경우, 실제 파일 사이즈 만큼만 Update 한다.
        if (updateInfo.nEndPosition >= (UInt64)(updateInfo.nRawDataSize / (UInt64)(RAW_DATA_SIZE))) {
            updateInfo.nEndPosition = (UInt64)(updateInfo.nRawDataSize / (UInt64)(RAW_DATA_SIZE))
        }
        
        //3. Move 위치에 그래프 영역이 없을 경우 리턴 처리
        if (updateInfo.nStartPosition > updateInfo.nEndPosition) {
            
            NSLog("Position No Data failed")
            updateInfo.bState = false
            return updateInfo
        }
        
        //4. Graph에 Update 할 File Size를 계산 한다. 이미 앞에서 RAW_DATA_SIZE 나누어서 들어온다.
        updateInfo.nFileLoadCnt = (updateInfo.nEndPosition - updateInfo.nStartPosition) / (UInt64)(LOAD_DATA_MAX_TIME)
        updateInfo.nFileUpdateCnt = 0
        updateInfo.nRemainCnt = 0
        
        updateInfo.nStartUpdatePos = 0
        updateInfo.nEndUpdatePos = 0
        
        updateInfo.nGraphUpdateSize = 0
        
        if(updateInfo.nFileLoadCnt > 0) { //부분 업데이트 인지 전체 업데이트 인지 구분 하자.
            updateInfo.bPartial = true
        }
        else {
            updateInfo.bPartial = false
        }
        
        updateInfo.updateCount = 0
        updateInfo.totalCount = (updateInfo.nEndPosition - updateInfo.nStartPosition) * (UInt64)(RAW_DATA_PARSING_CNT)//Data 총 갯수
        
        return updateInfo
    }
    
    func getUpdateSize(_ updateInfo:UpdateStatus) -> UpdateStatus
    {
        var returnInfo:UpdateStatus = UpdateStatus(bState: false, startPos: 0.0, endPos: 0.0, totalCount: 0, updateCount: 0, bPartial: false, nRawDataSize: 0, nStartPosition: 0, nEndPosition: 0, nFileLoadCnt: 0, nFileUpdateCnt: 0, nRemainCnt: 0, nStartUpdatePos: 0, nEndUpdatePos: 0, nGraphUpdateSize: 0)
        
        returnInfo = updateInfo
            
        returnInfo.nRemainCnt = returnInfo.nFileLoadCnt - returnInfo.nFileUpdateCnt
        
        if (returnInfo.nRemainCnt != 0) { //1시간(LOAD_DATA_MAX_TIME) 이상의 Update가 있을때
            
            returnInfo.nStartUpdatePos = returnInfo.nStartPosition + (returnInfo.nFileUpdateCnt * (UInt64)(LOAD_DATA_MAX_TIME))
            returnInfo.nEndUpdatePos = returnInfo.nStartUpdatePos + (UInt64)(LOAD_DATA_MAX_TIME)
            
            returnInfo.nGraphUpdateSize = (UInt64)(LOAD_DATA_MAX_TIME * RAW_DATA_PARSING_CNT)
        }
        else { //1시간(LOAD_DATA_MAX_TIME) 미만의 Update가 있을때
            
            returnInfo.nStartUpdatePos = returnInfo.nStartPosition + (returnInfo.nFileUpdateCnt * (UInt64)(LOAD_DATA_MAX_TIME))
            returnInfo.nEndUpdatePos = returnInfo.nEndPosition
            
            if (returnInfo.nEndUpdatePos >= returnInfo.nStartUpdatePos) {
                returnInfo.nGraphUpdateSize = (returnInfo.nEndUpdatePos - returnInfo.nStartUpdatePos) * (UInt64)(RAW_DATA_PARSING_CNT)//Data 총 갯수
            }
            else {
                returnInfo.bState = false
            }
        }
        
        return returnInfo
    }
    
    func openInfoInit() -> Void
    {
        OpenInfo.scopeCurrent = 0.0
        OpenInfo.scopeVoltage = 0.0
        OpenInfo.scopeCount = 0
        
        OpenInfo.bUpdate = true
        
        OpenSlaveInfo.scopeCurrent = 0.0
        OpenSlaveInfo.scopeVoltage = 0.0
        OpenSlaveInfo.scopeCount = 0
        
        OpenSlaveInfo.bUpdate = true
    }
    
    func getGraphData(_ strMasterFilePath:String, strSlaveFilePath:String, startPos:Double, endPos:Double) -> Bool
    {
        let result:Bool = true

        UpdateInfo = getUpdateInfo(OpenInfo, startPos: startPos, endPos: endPos)
        UpdateSlaveInfo = getUpdateInfo(OpenSlaveInfo, startPos: startPos, endPos: endPos)
        
        if ((UpdateInfo.bState == false) && (UpdateSlaveInfo.bState == false)) {
            return false
        }
        
        //Initialize File Load/Update Count
        var nFileLoadCnt:UInt64 = UpdateInfo.nFileLoadCnt
        if (UpdateSlaveInfo.nFileLoadCnt > UpdateInfo.nFileLoadCnt) {
            nFileLoadCnt = UpdateSlaveInfo.nFileLoadCnt
        }
        
        var nFileUpdateCnt:UInt64 = 0
        
        //Enter Backgroud Processing
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)

        queue.async(execute: { () -> () in
        
        //OpenInfo Initial
        self.openInfoInit()
            
        repeat {

            if (self.UpdateInfo.nFileUpdateCnt <= self.UpdateInfo.nFileLoadCnt) {
                
                self.UpdateInfo = self.getUpdateSize(self.UpdateInfo)
                
                if ((self.UpdateInfo.nRemainCnt == 0) && (self.UpdateInfo.nGraphUpdateSize == 0)) { //딱 떨어지는 경우
                    self.UpdateInfo.bState = false
                }
                
                if (self.UpdateInfo.bState) {
                    
                    //부분 업데이트 할 정보를 갱신 한다.
                    self.OpenInfo.startPos = startPos + (Double)(self.UpdateInfo.nFileUpdateCnt * (UInt64)(LOAD_DATA_SHIFT_TIME))
                    self.OpenInfo.endPos = endPos
            
                    //Loading Master Info
                    let masterFileHandle:FileHandle = FileHandle(forReadingAtPath: strMasterFilePath)!
                    let parserInfo = RawDataParsingInfo(fileHandle:masterFileHandle, readfileHeaderLocation: self.OpenInfo.nHeaderSize, readfileLocation: self.UpdateInfo.nStartUpdatePos, readBufferCount: RAW_BUF_CNT, garbageDataCount: 0, scopeUpdateSize: self.UpdateInfo.nGraphUpdateSize, scopeDataCount: 0, updateDataCount: 0, currentSum: 0.0, voltageSum: 0.0)
                    
                    //Parser buffer, value Initialize
                    self.OpenParserInfo = self.OpenInfo
                    self.UpdateParserInfo = self.UpdateInfo

                    self.rawDataFileToGraphBuffer(parserInfo)
                    
                    //Copy RawData -> Master Buffer
                    self.fileToGraphBuffer1 = self.rawDataParsingBuffer1
                    self.fileToGraphBuffer2 = self.rawDataParsingBuffer2
                    
                    self.OpenInfo = self.OpenParserInfo
                    self.UpdateInfo = self.UpdateParserInfo
                    
                    masterFileHandle.closeFile()
                }
                
                self.UpdateInfo.nFileUpdateCnt += 1
            }
            else {
                self.fileToGraphBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE)
                self.fileToGraphBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE)
            }

            if (self.UpdateSlaveInfo.nFileUpdateCnt <= self.UpdateSlaveInfo.nFileLoadCnt) {
                
                self.UpdateSlaveInfo = self.getUpdateSize(self.UpdateSlaveInfo)
                
                if ((self.UpdateSlaveInfo.nRemainCnt == 0) && (self.UpdateSlaveInfo.nGraphUpdateSize == 0)) { //딱 떨어지는 경우
                    self.UpdateSlaveInfo.bState = false
                }
                
                if (self.UpdateSlaveInfo.bState) {
                    
                    //부분 업데이트 할 정보를 갱신 한다.
                    self.OpenSlaveInfo.startPos = startPos + (Double)(self.UpdateSlaveInfo.nFileUpdateCnt * (UInt64)(LOAD_DATA_SHIFT_TIME))
                    self.OpenSlaveInfo.endPos = endPos
                    
                    //Loading Slave Info
                    let slaveFileHandle:FileHandle = FileHandle(forReadingAtPath: strSlaveFilePath)!
                    let parserInfo = RawDataParsingInfo(fileHandle:slaveFileHandle, readfileHeaderLocation: self.OpenSlaveInfo.nHeaderSize, readfileLocation: self.UpdateSlaveInfo.nStartUpdatePos, readBufferCount: RAW_BUF_CNT, garbageDataCount: 0, scopeUpdateSize: self.UpdateSlaveInfo.nGraphUpdateSize, scopeDataCount: 0, updateDataCount: 0, currentSum: 0.0, voltageSum: 0.0)
                    
                    //Parser buffer, value Initialize
                    self.OpenParserInfo = self.OpenSlaveInfo
                    self.UpdateParserInfo = self.UpdateSlaveInfo
                    
                    self.rawDataFileToGraphBuffer(parserInfo)
                    
                    //Copy RawData -> Master Buffer
                    self.slaveFileToGraphBuffer1 = self.rawDataParsingBuffer1
                    self.slaveFileToGraphBuffer2 = self.rawDataParsingBuffer2
                    
                    self.OpenSlaveInfo = self.OpenParserInfo
                    self.UpdateSlaveInfo = self.UpdateParserInfo
                    
                    slaveFileHandle.closeFile()
                }
                
                self.UpdateSlaveInfo.nFileUpdateCnt += 1
            }
            else {
                self.slaveFileToGraphBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE)
                self.slaveFileToGraphBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE)
            }

            if ((self.UpdateInfo.bState == false) && (self.UpdateSlaveInfo.bState == false)) {
                break
            }
            
            DispatchQueue.main.async(execute: { () -> () in
                
                let strProgress:String = NSString(format: "Data Loading... %.2f %%", 100.0) as String
                self.fileControldelegate?.returnFileDataProgressMsg(self, strMsg: strProgress)
                
                self.fileControldelegate?.returnFileDataGraphProcess(self, dVoltage: self.OpenInfo.scopeVoltage, dCurrent: self.OpenInfo.scopeCurrent, updateInfo: self.UpdateInfo)
            })
            
            nFileUpdateCnt += 1
            //print("nFileUpdateCnt = \(nFileUpdateCnt)")
            
        } while(nFileUpdateCnt <= nFileLoadCnt)

        self.OpenInfo.bUpdate = false
        self.OpenSlaveInfo.bUpdate = false
            
        }) //End Background Processing

        return result
    }
    
    var readBuffer = [UInt8](repeating: 0, count: (RAW_DATA_SIZE * RAW_BUF_CNT))
    var rawBuffer = [UInt8](repeating: 0, count: (ADC1_SEND_TIME * ONE_DATA_SIZE))

    func readRawDataFromFileLocation(_ fileHandle: FileHandle, readFilelocation: UInt64, readBufferCount: Int, fileHeaderLocation: UInt64, garbageDataCount: UInt64) ->(location:UInt64, readBufferCount:Int, garbageDataCount:UInt64)
    {
        let readBufferSize = RAW_DATA_SIZE * RAW_BUF_CNT
        
        var readData = Data()

        var read_buffer_count = readBufferCount
        var read_file_location = readFilelocation
        var garbage_data_count = garbageDataCount
        
        var bVaildSignature:Bool = false
        var bError:Bool = false
        
        repeat {
            
            //File Data Read
            if (read_buffer_count < RAW_BUF_CNT) {
                
            }
            else {
                
                let file_end_location = fileHandle.seekToEndOfFile()
                let file_location = ((read_file_location * (UInt64)(RAW_DATA_SIZE)) + fileHeaderLocation + garbage_data_count)
                
                if (file_location > file_end_location) {
                    //print("file end = \(file_end_location)")
                    bError = true
                    break
                }
                
                fileHandle.seek(toFileOffset: file_location)
                readData = (fileHandle.readData(ofLength: readBufferSize))
                (readData as NSData).getBytes(&readBuffer, length:readBufferSize * MemoryLayout<UInt8>.size)

                //print("readData = \(readData)")
                
                read_buffer_count = 0
            }
            
            //Check Signature
            if (readBuffer[read_buffer_count * RAW_DATA_SIZE] != 0x23) { //# //82 byte씩 증가.
                
                /* bhjeon Logic 이 이상하다 다시 생각해 보자.
                 if ((index > nUpdateSize) ||
                 ((nUpdateSize /*nEndPos*/ - index) < (UInt64)(RAW_BUF_CNT))) { //최소만 남아 있으면, 나가야 한다.
                 break
                 }*/
                
                garbage_data_count += 1
                //print("nGarbageDataCnt = \(nGarbageDataCnt)")
                
                read_buffer_count = RAW_BUF_CNT  //garbage data가 있으면, 다음 버퍼를 읽도록 한다.
                
                read_file_location += 1
                continue
            }
            else {
                //print("find signature")
                bVaildSignature = true
            }
  
        } while (bVaildSignature == false)
        
        if bError == true {
            return (location: read_file_location, readBufferCount: read_buffer_count, garbageDataCount: garbage_data_count)
        }
        
        //Checksum 계산
        var fileCheckSum:UInt8 = 0
        
        for i in 0 ..< (Int)((ADC1_SEND_TIME * ONE_DATA_SIZE)) {
            
            let UInt8_spare = 0xff - fileCheckSum
            
            let bufIndex = (read_buffer_count * RAW_DATA_SIZE) + i + 1 //82 byte씩 first Data 위치(# 다음) + index
            
            if (bufIndex > (RAW_DATA_SIZE * RAW_BUF_CNT - 1)) {
                break
            }
            
            if (readBuffer[bufIndex] > UInt8(UInt8_spare)) {
                
                fileCheckSum = UInt8(readBuffer[bufIndex]) - (UInt8_spare) - 1
            }
            else {
                fileCheckSum += UInt8(readBuffer[bufIndex])
            }
            
            //print("fileCheckSum = \(fileCheckSum), readBuffer[\(bufIndex)] = \(readBuffer[bufIndex])")
        }
        
        fileCheckSum = ~fileCheckSum
        
        if (fileCheckSum >= 0xff) {
            fileCheckSum = 0
        }
        else {
            fileCheckSum = fileCheckSum + 1
        }
        
        //Check Checksum Data
        let indexLast = (read_buffer_count * RAW_DATA_SIZE) + (ADC1_SEND_TIME * ONE_DATA_SIZE) + 1 //82번째 Last Data index
        
        if (readBuffer[indexLast] != fileCheckSum) {
            //이전 데이터를 사용한다.
            print("file checksum error readBuffer[\(indexLast)] = \(readBuffer[indexLast]), fileCheckSum = \(fileCheckSum)")
        }
        else {
            //Parser 가 들어가야 한다.
            //print("file checksum ok : \(fileCheckSum)")
            
            for setIndex in 0 ..< (ADC1_SEND_TIME * ONE_DATA_SIZE) {
                
                let getIndex = (read_buffer_count * RAW_DATA_SIZE) + (setIndex + 1)
                rawBuffer[setIndex] = readBuffer[getIndex]
            }
        }

        return (location:read_file_location, readBufferCount:read_buffer_count, garbageDataCount: garbage_data_count)
    }

    func rawDataParsing(_ scopeCount:Int, updateCount:UInt64, voltageSum:Double, currentSum:Double) -> (scopeCount:Int, updateCount:UInt64, voltageSum:Double, currentSum:Double)
    {
        var scope_count:Int = scopeCount
        var update_count:UInt64 = updateCount
        
        var voltage_sum:Double = voltageSum
        var current_sum:Double = currentSum
        
        //Data Parsing
        let rawBufferSize = rawBuffer.count

        let ptrReceiveData = UnsafeMutablePointer<RawDataInfo>.allocate(capacity: rawBufferSize)
        memcpy(ptrReceiveData, rawBuffer, rawBufferSize)

        for rawIndex in 0 ..< ADC1_SEND_TIME {
            
            var value = ptrReceiveData[rawIndex]
            
            value = self.SwappingData(value)
            
            var result_data:UInt32 = 0
            var mask_data:UInt32 = 0
            
            result_data = value.dwScope_High
            mask_data = (UInt32)(DATA_MODE_MASK)
            mask_data = mask_data << (UInt32)(DATA_MODE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_MODE_SHIFT_VAL)
            let result_MeasureModeState = (Int)(result_data)
            
            //Voltage Data Info
            result_data = value.dwScope_High
            mask_data = (UInt32)(DATA_VOL_MASK)
            mask_data = mask_data << (UInt32)(DATA_VOL_SHIFT_VAL)
            result_data &= mask_data;
            result_data = result_data >> (UInt32)(DATA_VOL_SHIFT_VAL)
            var result_Vol1 = (Double)(result_data)
            
            //Voltage Delta Data Info
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_DELTA_VOLTAGE_MASK)
            mask_data = mask_data << (UInt32)(DATA_DELTA_VOLTAGE_SHIFT_VAL)
            result_data &= mask_data;
            result_data = result_data >> (UInt32)(DATA_DELTA_VOLTAGE_SHIFT_VAL)
            let result_vol_delta = (Double)(result_data)
            
            //Voltage Delta State Info
            result_data = value.dwScope_Low;
            mask_data = (UInt32)(DATA_VOLTAGE_DELTA_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_VOLTAGE_DELTA_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_VOLTAGE_DELTA_STATE_SHIFT_VAL)
            let result_VoltageDeltaState = (Int)(result_data)
            
            //Voltage Data State Info
            result_data = value.dwScope_Low;
            mask_data = (UInt32)(DATA_VOLTAGE_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_VOLTAGE_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_VOLTAGE_STATE_SHIFT_VAL)
            let result_VoltageState = (Int)(result_data)
            
            if (result_Vol1 == 0) {
                result_Vol1 = 0
            }
            else {
                
                if (result_VoltageState == 1) { //2.50, 3.00 Voltage 이상.
                    
                    if (result_MeasureModeState == 1) { //USB Measure Mode
                        result_Vol1 += (Double)(USB_BASE_VOLTAGE)
                    }
                    else {
                        result_Vol1 += (Double)(BAT_BASE_VOLTAGE)
                    }
                }
            }
            
            //Voltage Range Data State Info
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_VOLTAGE_RANGE_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_VOLTAGE_RANGE_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_VOLTAGE_RANGE_STATE_SHIFT_VAL)
            let result_VoltageRangeState:Int = (Int)(result_data)
            
            switch (result_VoltageRangeState) {
                
            case 0: //0 ~ 2.50V
                result_Vol1 += (Double)(0.0)
                
            case 1: //2.50 ~ 5.05
                result_Vol1 += (Double)(VOL_0250mV)
                
            case 2: //5.05 ~ 7.60
                result_Vol1 += (Double)(VOL_0505mV)
                
            case 3: //7.60 ~ 10.15
                result_Vol1 += (Double)(VOL_0760mV)
                
            case 4: //10.15 ~ 12.70
                result_Vol1 += (Double)(VOL_1015mV)
                
            case 5: //12.70 ~ 15.25
                result_Vol1 += (Double)(VOL_1270mV)
                
            default:
                result_Vol1 += (Double)(0.0)
                break;
            }
            
            var result_Vol2 = 0.0
            if (result_VoltageDeltaState == 1) {
                result_Vol2 = result_Vol1 + result_vol_delta
            }
            else {
                result_Vol2 = result_Vol1 - result_vol_delta
            }
            
            //Measure Data Sub Info
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_MODE_SUB_MASK)
            mask_data = mask_data << (UInt32)(DATA_MODE_SUB_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_MODE_SUB_SHIFT_VAL)
            let result_MeasureModeSubState = (Int)(result_data)
            
            var mode:Int = 0
            
            var ScopeModeStatus = result_MeasureModeSubState;
            
            if (result_MeasureModeState == 1) {
                mode = 0x01;
                mode <<= 5;
            }
            else {
                mode = 0x01;
                mode <<= 6;
            }
            ScopeModeStatus |= mode;
            
            let scopeStatus:ScopeStatus = UpdateScopeMode(ScopeModeStatus)
            
            //Reference Current Data Info
            result_data = value.dwScope_High
            mask_data = (UInt32)(DATA_REF_CUR_MASK)
            mask_data = mask_data << (UInt32)(DATA_REF_CUR_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_REF_CUR_SHIFT_VAL)
            var result_Cur1 = (Double)(result_data)
            
            //Reference Current Data Range Info
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_CURRENT_RANGE_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_CURRENT_RANGE_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_CURRENT_RANGE_STATE_SHIFT_VAL)
            let result_RangeState = (Int)(result_data)
            
            if (result_RangeState == 1) {
                result_Cur1 += (Double)(DATA_REF_CUR_MASK)
            }
            
            //Delta State Info
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_DELTA_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_DELTA_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_DELTA_STATE_SHIFT_VAL)
            let result_DeltaState = (Int)(result_data)
            
            //Delta Current Data Info
            result_data = value.dwScope_Low;
            mask_data = (UInt32)(DATA_DELTA_CUR_MASK)
            mask_data = mask_data << (UInt32)(DATA_DELTA_CUR_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_DELTA_CUR_SHIFT_VAL)
            let result_Delta = (Double)(result_data)
            
            var result_Cur2 = 0.0
            if (result_DeltaState == 1) {
                result_Cur2 = result_Cur1 + result_Delta;
            }
            else {
                result_Cur2 = result_Cur1 - result_Delta;
            }

            rawDataParsingBuffer2[scope_count] = result_Vol1 / 100.0
            rawDataParsingBuffer2[scope_count+1] = result_Vol2 / 100.0
            
            //if (self.OpenInfo.scopeMode == .LEAKAGE) {
            if (scopeStatus.bLEAKAGE == true) {
                
                rawDataParsingBuffer1[scope_count] = (result_Cur1 / 10000.0) * m_FileCurrentUnit
                rawDataParsingBuffer1[scope_count+1] = (result_Cur2 / 10000.0) * m_FileCurrentUnit
            }
            else {
                
                rawDataParsingBuffer1[scope_count] = (result_Cur1 / 100.0) * m_FileCurrentUnit
                rawDataParsingBuffer1[scope_count+1] = (result_Cur2 / 100.0) * m_FileCurrentUnit
            }
            
            current_sum += rawDataParsingBuffer1[scope_count]
            current_sum += rawDataParsingBuffer1[scope_count+1]
            
            voltage_sum += rawDataParsingBuffer2[scope_count]
            voltage_sum += rawDataParsingBuffer2[scope_count+1]

            scope_count += 2
            update_count += 2
        }

        //bhjeon swift 4.0 update ptrReceiveData.deallocate(capacity: rawBufferSize)
        ptrReceiveData.deallocate()
        
        return (scopeCount:scope_count, updateCount:update_count, voltageSum:voltage_sum, currentSum:current_sum)
    }

    func rawDataFileToGraphBuffer(_ parserInfo:RawDataParsingInfo) -> Void
    {
        //Loading Parsing Info
        let fileHandle = parserInfo.fileHandle
        var read_buffer_count:Int = parserInfo.readBufferCount //RAW_BUF_CNT //최초 1회 진입 조건, 82byte buffer 사용 회수
        var read_file_location:UInt64 = parserInfo.readfileLocation //nStartPos
        let file_header_location:UInt64 = parserInfo.readfileHeaderLocation  //OpenInfo.nHeaderSize
        var garbage_data_count:UInt64 = parserInfo.garbageDataCount
        
        var voltage_sum:Double = parserInfo.voltageSum
        var current_sum:Double = parserInfo.currentSum
        var scope_count:Int = parserInfo.scopeDataCount
        var update_count:UInt64 = parserInfo.updateDataCount
        let scope_update_size:UInt64 = parserInfo.scopeUpdateSize

        self.rawDataParsingBuffer1 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE)
        self.rawDataParsingBuffer2 = [Double](repeating: -1.0, count: RAW_BUFFER_FULL_SIZE)
        
        readBuffer = [UInt8](repeating: 0, count: (RAW_DATA_SIZE * RAW_BUF_CNT))
        rawBuffer = [UInt8](repeating: 0, count: (ADC1_SEND_TIME * ONE_DATA_SIZE))
        
        repeat {
            
            // 0. Read Raw Power Data from file
            let (readFileLocation, readBufferCount, garbageDataCount) = readRawDataFromFileLocation(fileHandle, readFilelocation: read_file_location, readBufferCount: read_buffer_count, fileHeaderLocation: file_header_location, garbageDataCount: garbage_data_count)
            
            read_file_location = readFileLocation
            read_buffer_count = readBufferCount
            garbage_data_count = garbageDataCount

            //1. Raw Data Parsing from buffer
            let (scopeCount, updateCount, voltageSum, currentSum) = rawDataParsing(scope_count, updateCount: update_count, voltageSum: voltage_sum, currentSum: current_sum)
            scope_count = scopeCount
            update_count = updateCount
            voltage_sum = voltageSum
            current_sum = currentSum
            
            //3. Progressing
            OpenParserInfo.scopeCurrent = current_sum / (Double)(scope_count)
            OpenParserInfo.scopeVoltage = voltage_sum / (Double)(scope_count)

            var dProgress:Double = 0.0
            dProgress = (Double)(OpenParserInfo.scopeCount + (UInt64)(scope_count)) / (Double)(UpdateParserInfo.totalCount)
            dProgress *= 100.0
            
            //NSLog("scopeCount: %d, totalCount: %d",self.OpenInfo.scopeCount, self.UpdateInfo.totalCount)
            
            if (update_count > (UInt64)(LOAD_READ_BUF_MAX - RAW_DATA_PARSING_CNT)) {
                
                update_count = 0
                
                DispatchQueue.main.async(execute: { () -> () in
                    
                    let strProgress:String = NSString(format: "Data Loading... %.2f %%", dProgress) as String
                    self.fileControldelegate?.returnFileDataProgressMsg(self, strMsg: strProgress)
                })
            }
            
            //Signature OK -> Checsum OK index 증가
            read_file_location += 1
            read_buffer_count += 1
            
        } while((UInt64)(scope_count) < scope_update_size)
        
        OpenParserInfo.scopeCount += (UInt64)(scope_count)
        
        //Graph Update 한방에 Update 하는
        //부분 업데이트 할 정보
        UpdateParserInfo.updateCount = (UInt64)(scope_count)
        UpdateParserInfo.startPos = OpenParserInfo.startPos
        UpdateParserInfo.endPos = OpenParserInfo.endPos
    }
    
    func setCurrentUnit(_ strUnit:String) -> Void
    {
        switch(strUnit)
        {
        case "uA":
            m_FileCurrentUnit = 1000.0 //0.001
        case "mA":
            m_FileCurrentUnit = 1.0
        default:
            m_FileCurrentUnit = 1.0
            break
        }
    }
    
    func UpdateScopeMode(_ scopeMode:Int) -> ScopeStatus
    {
        var scopeStae:ScopeStatus = ScopeStatus(bADC_MIN: false, bADC_MAX: false, bADC_AVG: false, bUSB_CHG: false, bLEAKAGE: false, bUSB_OUT: false, bBAT_OUT: false)
        
        var mask_data:UInt8
        var scopeData:UInt8
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_ADC_MIN_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_ADC_MIN_MASK_SHIFT_VAL)
        let adcMinState = (Int)(scopeData)
        scopeStae.bADC_MIN = (adcMinState == 1) ? true : false
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_ADC_MAX_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_ADC_MAX_MASK_SHIFT_VAL)
        let adcMaxState = (Int)(scopeData)
        scopeStae.bADC_MAX = (adcMaxState == 1) ? true : false
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_ADC_AVG_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_ADC_AVG_MASK_SHIFT_VAL)
        let adcAvgState = (Int)(scopeData)
        scopeStae.bADC_AVG = (adcAvgState == 1) ? true : false
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_USB_CHG_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_USB_CHG_MASK_SHIFT_VAL)
        let usbCHGState = (Int)(scopeData)
        scopeStae.bUSB_CHG = (usbCHGState == 1) ? true : false
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_LEAKAGE_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_LEAKAGE_MASK_SHIFT_VAL)
        let leakageState = (Int)(scopeData)
        scopeStae.bLEAKAGE = (leakageState == 1) ? true : false
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_USB_OUT_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_USB_OUT_MASK_SHIFT_VAL)
        let usbOutState = (Int)(scopeData)
        scopeStae.bUSB_OUT = (usbOutState == 1) ? true : false
        
        scopeData = (UInt8)(scopeMode)
        mask_data = (UInt8)(DATA_BAT_OUT_MASK)
        scopeData &= mask_data
        scopeData = scopeData >> (UInt8)(DATA_BAT_OUT_MASK_SHIFT_VAL)
        let batOutState = (Int)(scopeData)
        scopeStae.bBAT_OUT = (batOutState == 1) ? true : false
        
        return scopeStae
    }
    
    func SwappingData(_ value:RawDataInfo) -> RawDataInfo
    {
        var NewValue:RawDataInfo = RawDataInfo(dwScope_Low: 0, dwScope_High: 0)
 
        NewValue.dwScope_Low = (value.dwScope_Low & 0x000000ff) << 24
        NewValue.dwScope_Low |= (value.dwScope_Low & 0x0000ff00) << 8
        NewValue.dwScope_Low |= (value.dwScope_Low & 0x00ff0000) >> 8
        NewValue.dwScope_Low |= (value.dwScope_Low & 0xff000000) >> 24
        
        NewValue.dwScope_High = (value.dwScope_High & 0x000000ff) << 24
        NewValue.dwScope_High |= (value.dwScope_High & 0x0000ff00) << 8
        NewValue.dwScope_High |= (value.dwScope_High & 0x00ff0000) >> 8
        NewValue.dwScope_High |= (value.dwScope_High & 0xff000000) >> 24
        
        return NewValue
    }
    
    func sizeForLocalFilePath(_ filePath:String) -> UInt64 {
        
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    func createPowerDataToCSV(_ strCSVFilePath:String) ->Bool
    {
        var status:Bool = false
        
        var strHeader:String = ""
        
        SaveInfo.strExportFilePath = strCSVFilePath
        
        strHeader += "====================================================\n"
        strHeader += "         Smart PowerScope Measurement Data          \n"
        strHeader += "====================================================\n"
        
        let strVersion = OpenInfo.strVersionInfo
        let strFileName = OpenInfo.strFileName
        let strTimeInfo = OpenInfo.strTimeInfo
        
        strHeader += "File Info:" + strVersion + ",Time:" + strTimeInfo + ",FileName:" + strFileName
        
        strHeader += "\n"
        let strFilePath = OpenInfo.strSelectFilePath
        strHeader += "File Path:" + strFilePath

        strHeader += "\n"
        strHeader += "Scope Start Time:" + strTimeInfo
        strHeader += "\n====================================================\n"
        
        if (OpenInfo.scaleMode == .fine) {
            strHeader += "Time(Sec),Time(Division), Voltage(V), Current(uA), Power(uW)\n";
        }
        else{
            strHeader += "Time(Sec),Time(Division), Voltage(V), Current(mA), Power(mW)\n";
        }
        
        strHeader += "------------------------------------------------------------\n";

        //writing
        do {
            try strHeader.write(toFile: strCSVFilePath, atomically: false, encoding: String.Encoding.utf8)

            status = true
            
        } catch {
            
            status = false
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        //Reading Export Excel Time Division
        let prefs = UserDefaults.standard
        let strDivision = prefs.value(forKey: "strExcelTimeDivision")
        if (strDivision != nil) {
            
            let strTimeDiv:NSString = strDivision as! NSString
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm:ss.SSS"
            
            if (dateFormatter.date(from: strTimeDiv as String) != nil) {
                
                //let date:NSDate = dateFormatter.dateFromString(strTimeDiv)!
                
                let strMinute:String = strTimeDiv.substring(with: NSRange(location: 0, length: 2)) as String
                let strSecond:String = strTimeDiv.substring(with: NSRange(location: 3, length: 2)) as String
                let strFraction:String = strTimeDiv.substring(with: NSRange(location: 6, length: 3)) as String
                
                //To nanoSecond
                var timeDivision:UInt32 = (UInt32)(atoi(strMinute) * 60 * 1000 * 1000)
                timeDivision += (UInt32)(atoi(strSecond) * 1000 * 1000)
                timeDivision += (UInt32)(atoi(strFraction) * 1000)
                
                SaveInfo.ExportDivisionTime = timeDivision
            }
        }
        
        return status
    }
    
    func addPowerDataFooterToCSV(_ strCSVFilePath:String) -> Bool
    {
        let status:Bool = false
        
        let strAverage = OpenInfo.strAverage;
        let strRunTime = OpenInfo.strRunTime;
        
        var strFooter = "\n====================================================\n"
        strFooter += NSString(format: "ResultInfo:Avg:%@,RunTime:%@", strAverage, strRunTime) as String

        let outputStream:OutputStream = OutputStream(toFileAtPath: strCSVFilePath, append: true)!

        let ptrData = [UInt8](strFooter.utf8)

        outputStream.open()
        outputStream.write(ptrData, maxLength: ptrData.count)
        outputStream.close()
        
        return status
    }
    
    func addTimeInfo(currentTime:DateComponents, nanoSecond:UInt32) -> DateComponents
    {
        var current_Time = currentTime
        var addTime:DateComponents = DateComponents()

        let addNanoSecond:Int = (Int)(nanoSecond % 1000000)
        let addSecond:Int = (Int)((nanoSecond / 1000000) % 60)
        let addMinute:Int = (Int)(((nanoSecond / 1000000) / 60) % 60)
        let addHour:Int = (Int)((((nanoSecond / 1000000) / 60) / 60) % 60)

        //print("addHour: \(addHour), addMinute: \(addMinute), addSecond: \(addSecond), addNanoSecond: \(addNanoSecond)")

        current_Time.nanosecond = current_Time.nanosecond! + addNanoSecond
        current_Time.second = current_Time.second! + addSecond
        current_Time.minute = current_Time.minute! + addMinute
        current_Time.hour = current_Time.hour! + addHour
        
        if (current_Time.nanosecond! >= 1000000) {
            current_Time.nanosecond = current_Time.nanosecond! - 1000000
            current_Time.second = current_Time.second! + 1
        }
        
        if (current_Time.second! >= 60) {
            current_Time.second = current_Time.second! - 60
            current_Time.minute = current_Time.minute! + 1
        }
        
        if (current_Time.minute! >= 60) {
            current_Time.minute = current_Time.minute! - 60
            current_Time.hour = current_Time.hour! + 1
        }
        
        if (current_Time.hour! >= 24) {
            current_Time.hour = current_Time.hour! - 24
            current_Time.day = current_Time.day! + 1
        }

        addTime = current_Time
        
        return addTime
    }
    
    func addPowerDataToCSV(_ strCSVfile:String, startTimeInfo:DateComponents, data1Array: [Double], data2Array: [Double], location: Int, nCount:UInt64) -> DateComponents
    {
        var addFileTime:DateComponents = startTimeInfo
        
        let saveTime:UInt32 = SaveInfo.ExportDivisionTime //1000000
        let timeStep:UInt32 = 500 // 500 nanoSecond (Double)(1.0/2000.0)
        
        var addCurrent:Double = spareCSV.addCurrent
        var addVoltage:Double = spareCSV.addVoltage
        var addPower:Double = spareCSV.addPower
        
        var addTimeDivision:UInt32 = (UInt32)(spareCSV.addTimeDivision)
        var addCount:Int = spareCSV.addCount
        
        var avgCurrent:Double = 0.0
        var avgVoltage:Double = 0.0
        var avgPower:Double = 0.0
        
        var strTimeInfo:NSString = NSString()
        
        var iDataIndex = 0
        
        for index in 0 ..< (Int)(nCount) {
            
            iDataIndex = location + index
            
            let current:Double = data1Array[iDataIndex]
            let voltage:Double = data2Array[iDataIndex]
            let power:Double = current * voltage

            addCurrent += current
            addVoltage += voltage
            addPower += power
            
            addCSVTime += UInt64(timeStep)
            addTimeDivision += timeStep
            
            addCount += 1
            
            if (addTimeDivision > (saveTime - timeStep)) {
                
                avgCurrent = addCurrent / (Double)(addCount)
                avgVoltage = addVoltage / (Double)(addCount)
                avgPower = addPower / (Double)(addCount)
                
                addFileTime = addTimeInfo(currentTime: addFileTime, nanoSecond: addTimeDivision)
                
                strTimeInfo = NSString(format: "'%02d-%02d %02d:%02d:%02d.%04d,%.04f", addFileTime.month!, addFileTime.day!, addFileTime.hour!, addFileTime.minute!, addFileTime.second!, Int(addFileTime.nanosecond! / 100), ((Double)(addCSVTime) / 1000000.0))
                
                //NSLog("addFileTime.second: %d, addFileTime.nanosecond: %d, iDataIndex: %d / %d", addFileTime.second, addFileTime.nanosecond, iDataIndex, nCount)
                writeCSVFile(strCSVfile, strAddTimeInfo: strTimeInfo, dVoltage: avgVoltage, dCurrent: avgCurrent, dPower: avgPower)
                
                var dProgress:Double = 0.0
                dProgress = (Double)(self.SaveInfo.ExportCSVCount + (UInt64)(iDataIndex)) / (Double)(self.UpdateInfo.totalCount)
                dProgress *= 100.0

                DispatchQueue.main.async(execute: { () -> () in
                    
                    let strProgress:String = NSString(format: "Data Exporting... %.2f %%", dProgress) as String
                    self.fileControldelegate?.returnFileDataProgressMsg(self, strMsg: strProgress)
                })

                addCurrent = 0.0
                addVoltage = 0.0
                addPower = 0.0
                
                addTimeDivision = 0
                addCount = 0
                
                spareCSV.addCurrent = 0.0
                spareCSV.addVoltage = 0.0
                spareCSV.addPower = 0.0
                
                spareCSV.addTimeDivision = 0
                spareCSV.addCount = 0
            }
            //print("addCSVTime:\(addCSVTime)")
        }
        
        SaveInfo.ExportCSVCount += (UInt64)(nCount)
        
        if (addCount > 0) { //Last Spare Data
            
            spareCSV.addCurrent = addCurrent
            spareCSV.addVoltage = addVoltage
            spareCSV.addPower = addPower
            
            spareCSV.addTimeDivision = addTimeDivision
            spareCSV.addCount = addCount
            
            spareCSV.addFileTime = addFileTime
        }

        return addFileTime
    }

    func exportScopeDataToCSV(_ data1Array: [Double], data2Array: [Double], location:Int, size:UInt64) ->Bool
    {
        var fileTime:DateComponents = SaveInfo.ExportFileTime

        let strCSVfile = SaveInfo.strExportFilePath
        
        //Enter Backgroud Processing
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        queue.async(execute: { () -> () in
            
            fileTime = self.addPowerDataToCSV(strCSVfile, startTimeInfo: fileTime, data1Array: data1Array, data2Array: data2Array, location: location, nCount: size)
            
            self.SaveInfo.ExportFileTime = fileTime
            
        }) //End Background Processing
   
        return true
    }
    
    func exportPowerDataToCSV(_ strExportFilePath:String) ->Bool
    {
        //var status = true
        let strCSVfile = strExportFilePath
        
        var nRawDataSize = OpenInfo.nFileSize - OpenInfo.nHeaderSize - OpenInfo.nFooterSize
        
        if (nRawDataSize <= 0) {
            
            NSLog("RawData Size failed")
            return false
        }
        
        let nStartPosition:UInt64 = 0
        let nEndPosition:UInt64 = (UInt64)(nRawDataSize / (UInt64)(RAW_DATA_SIZE))
        
        var nStartUpdatePos:UInt64 = 0
        var nEndUpdatePos:UInt64 = 0
        
        var nGraphUpdateSize:UInt64 = 0
        
        let strFilePath:String = OpenInfo.strSelectFilePath
        //var nStartPos:UInt64 = 0
        
        nRawDataSize = nRawDataSize / (UInt64)(RAW_DATA_SIZE)
        nRawDataSize *= (UInt64)(RAW_DATA_PARSING_CNT)
        
        let nFileLoadCnt:UInt64 = nEndPosition / (UInt64)(LOAD_DATA_MAX_TIME)
        
        var nFileUpdateCnt:UInt64 = 0
        var nRemainCnt:UInt64 = 0
        
        var fileTime:DateComponents = getFileTimeInfo(OpenInfo.strTimeInfo as NSString)
        SaveInfo.ExportFileTime = fileTime
        
        addCSVTime = 0
        
        //OpenInfo Initial
        OpenInfo.scopeCurrent = 0.0
        OpenInfo.scopeVoltage = 0.0
        OpenInfo.scopeCount = 0
        
        UpdateInfo.updateCount = 0
        UpdateInfo.totalCount = nRawDataSize //Data 총 갯수
        
        SaveInfo.ExportCSVCount = 0
        
        repeat {
            
            nRemainCnt = nFileLoadCnt - nFileUpdateCnt
            
            if (nRemainCnt != 0) {
                
                nStartUpdatePos = nStartPosition + (nFileUpdateCnt * (UInt64)(LOAD_DATA_MAX_TIME))
                nEndUpdatePos = nStartUpdatePos + (UInt64)(LOAD_DATA_MAX_TIME)
                
                nGraphUpdateSize = (UInt64)(LOAD_DATA_MAX_TIME * RAW_DATA_PARSING_CNT)
            }
            else {
                
                nStartUpdatePos = nStartPosition + (nFileUpdateCnt * (UInt64)(LOAD_DATA_MAX_TIME))
                nEndUpdatePos = nEndPosition
                
                nGraphUpdateSize = (nEndUpdatePos - nStartUpdatePos) * (UInt64)(RAW_DATA_PARSING_CNT)//Data 총 갯수
                
                if (nGraphUpdateSize == 0) { //딱 떨어지는 경우
                    break
                }
            }

            //Loading Master Info
            let parserInfo = RawDataParsingInfo(fileHandle:FileHandle(forReadingAtPath: strFilePath)!, readfileHeaderLocation: self.OpenInfo.nHeaderSize, readfileLocation: nStartUpdatePos, readBufferCount: RAW_BUF_CNT, garbageDataCount: 0, scopeUpdateSize: nGraphUpdateSize, scopeDataCount: 0, updateDataCount: 0, currentSum: 0.0, voltageSum: 0.0)
            
            //Parser buffer, value Initialize
            self.OpenParserInfo = self.OpenInfo
            self.UpdateParserInfo = self.UpdateInfo

            rawDataFileToGraphBuffer(parserInfo)
            
            //Save Master Buffer
            self.fileToGraphBuffer1 = self.rawDataParsingBuffer1
            self.fileToGraphBuffer2 = self.rawDataParsingBuffer2
            
            self.OpenInfo = self.OpenParserInfo
            self.UpdateInfo = self.UpdateParserInfo
            
            let addPowerDataSize:UInt64 = nGraphUpdateSize // * (UInt64)(RAW_DATA_PARSING_CNT)
            
            fileTime = addPowerDataToCSV(strCSVfile, startTimeInfo: fileTime, data1Array: fileToGraphBuffer1, data2Array: fileToGraphBuffer2, location:0, nCount: addPowerDataSize)
            SaveInfo.ExportFileTime = fileTime
            
            nFileUpdateCnt += 1
            
        } while(nFileUpdateCnt <= nFileLoadCnt)

        DispatchQueue.main.async(execute: { () -> () in

            let strProgress:String = NSString(format: "Data Exporting... %.2f %%", 100.0) as String
            self.fileControldelegate?.returnFileDataProgressMsg(self, strMsg: strProgress)
        })
        
        exportPowerDataSpareToCSV(strCSVfile)
        
        //add footer info to csv (total average & run time)
        _ = addPowerDataFooterToCSV(strCSVfile)
        
        return true
    }
    
    func exportPowerDataSpareToCSV(_ strExportFilePath:String) ->Void
    {
        let strCSVfile = strExportFilePath
        
        if(spareCSV.addCount > 0) {
            
            let avgCurrent = spareCSV.addCurrent / (Double)(spareCSV.addCount)
            let avgVoltage = spareCSV.addVoltage / (Double)(spareCSV.addCount)
            let avgPower = spareCSV.addPower / (Double)(spareCSV.addCount)
            
            let addFileTime = addTimeInfo(currentTime: spareCSV.addFileTime, nanoSecond: spareCSV.addTimeDivision)
            
            let strTimeInfo = NSString(format: "'%02d-%02d %02d:%02d:%02d.%04d,%.04f", addFileTime.month!, addFileTime.day!, addFileTime.hour!, addFileTime.minute!, addFileTime.second!, (addFileTime.nanosecond! / 100), ((Double)(addCSVTime) / 1000000.0))
            
            writeCSVFile(strCSVfile, strAddTimeInfo: strTimeInfo, dVoltage: avgVoltage, dCurrent: avgCurrent, dPower: avgPower)
        }
        
        spareCSV.addCurrent = 0.0
        spareCSV.addVoltage = 0.0
        spareCSV.addPower = 0.0
        
        spareCSV.addTimeDivision = 0
        spareCSV.addCount = 0
    }

    func writeCSVFile(_ strCSVFile:String, strAddTimeInfo:NSString, dVoltage:Double, dCurrent:Double, dPower:Double) -> Void
    {
        let strExportData = NSString(format: "%@, %.02f, %.02f, %.02f \n", strAddTimeInfo, dVoltage, dCurrent, dPower)

        //NSLog("strExportData = %@", strExportData)
  
        let saveData = strExportData.data(using: String.Encoding.utf8.rawValue)
        let dataSize = saveData?.count
        
        var buffer = [UInt8](repeating: 0,count: dataSize!)
        (saveData as NSData?)?.getBytes(&buffer, length: dataSize! * MemoryLayout<UInt8>.size)

        let outputStream:OutputStream = OutputStream(toFileAtPath: strCSVFile, append: true)!
        
        outputStream.open()
        outputStream.write(buffer, maxLength: dataSize!)
        outputStream.close()
    }
    
    //[20151028_171714]
    func getFileTimeInfo(_ strTimeInfo:NSString) -> DateComponents
    {
        var timeInfo:DateComponents = DateComponents()
        var strTimeInformation:NSString = strTimeInfo
        
        strTimeInformation = strTimeInfo.replacingOccurrences(of: "[", with: "") as NSString
        strTimeInformation = strTimeInfo.replacingOccurrences(of: "]", with: "") as NSString
        
        if (strTimeInformation.length < 15) {
            
            timeInfo.year = 1976
            timeInfo.month = 1
            timeInfo.day = 17
            timeInfo.hour = 0
            timeInfo.minute = 0
            timeInfo.second = 0
            timeInfo.nanosecond = 0

            return timeInfo
        }
        
        let strYear:String = strTimeInfo.substring(with: NSRange(location: 0, length: 4)) as String
        let strMonth:String = strTimeInfo.substring(with: NSRange(location: 4, length: 2)) as String
        let strDay:String = strTimeInfo.substring(with: NSRange(location: 6, length: 2)) as String
        let strHour:String = strTimeInfo.substring(with: NSRange(location: 9, length: 2)) as String
        let strMinute:String = strTimeInfo.substring(with: NSRange(location: 11, length: 2)) as String
        let strSecond:String = strTimeInfo.substring(with: NSRange(location: 13, length: 2)) as String
        
        timeInfo.year = (Int)(atoi(strYear))
        timeInfo.month = (Int)(atoi(strMonth))
        timeInfo.day = (Int)(atoi(strDay))
        timeInfo.hour = (Int)(atoi(strHour))
        timeInfo.minute = (Int)(atoi(strMinute))
        timeInfo.second = (Int)(atoi(strSecond))
        timeInfo.nanosecond = 0

        return timeInfo
    }
    
    
    func exportPowerDataPanel() -> Bool
    {
        var status = true
        
        let exportPanel = NSSavePanel()
        
        exportPanel.allowedFileTypes         = ["csv"]
        
        //exportPanel.beginWithCompletionHandler({(result:Int) in
        
        if (exportPanel.runModal() == NSApplication.ModalResponse.OK) {
            
            let result = exportPanel.url     //Path Name of the file
            
            if (result != nil) {
                
                let path = result!.path
                
                print("path = \(path)")
                status = exportPowerDataToCSVFile(path)
            }
            else {
                
                status = false
            }
        }
      
        return status
    }
    
    func exportPowerDataToCSVFile(_ csvFilePath:String) ->Bool
    {
        logController.saveLogData("exportPowerDataToCSVFile() csvFilePath = \(csvFilePath)")
        
        var status = true
        
        _ = createPowerDataToCSV(csvFilePath)
        
        //Enter Backgroud Processing
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        queue.async(execute: { () -> () in
            
            status = self.exportPowerDataToCSV(csvFilePath)
        }) //End Background Processing
        
        return status
    }
    
    func saveAsPowerDataPanel() -> Bool
    {
        var status = true
        
        let savePanel = NSSavePanel()
        
        savePanel.allowedFileTypes         = ["bin"]
        //savePanel.beginWithCompletionHandler({(result:Int) in
            
            if (savePanel.runModal() == NSApplication.ModalResponse.OK) {
                
                let result = savePanel.url     //Path Name of the file
                
                if (result != nil) {
                    
                    let path = result!.path
                    
                    print("path = \(path)")
                    
                    let fileManager = FileManager()
                    
                    do {
                        try fileManager.copyItem(at: URL(fileURLWithPath: self.OpenInfo.strSelectFilePath), to: result!)
                        
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                    
                }
                else {
                    
                    status = false
                }
            }
        //})

        return status
    }
    
    func openPowerDataPanel(_ strChannel:String) -> Bool
    {
        var status = true
        
        let openPanel = NSOpenPanel()
        
        openPanel.title                    = "Choose power data file"
        openPanel.showsResizeIndicator     = true
        openPanel.showsHiddenFiles         = false
        openPanel.canChooseDirectories     = true
        openPanel.canCreateDirectories     = false
        openPanel.allowsMultipleSelection  = false
        openPanel.allowedFileTypes         = ["bin"]

        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            
            let result = openPanel.url     //Path Name of the file
            
            if (result != nil) {
                
                let path = result!.path
                
                //print("path = \(path)")
                
                status = openPowerData(path, strChannel: strChannel)
            }
            else {
                
                status = false
            }
        }

        return status
    }
    
    func trashOldPowerDataFile(_ iTrashDay:Int) ->Int
    {
        var trashCnt = 0
        
        let today:Date = Date()

        let strHomeDir = NSHomeDirectory()
        let strPowerDir = strHomeDir + "/PowerData/"
        let fileManager = FileManager()
        
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: strPowerDir)!
        
        while let element = enumerator.nextObject() as? String {
            
            if (element.hasSuffix(".bin") || element.hasSuffix(".csv")) { // element is a bin file
                
                //NSLog("File: %@", element)
                let filePath = strPowerDir + element
                
                do {
                    
                    let attributes = try fileManager.attributesOfItem(atPath: filePath)
                    //print(attributes)
                    
                    let createDate: Date = attributes[FileAttributeKey.creationDate] as! Date
                    let trashDate = createDate.addingTimeInterval(60 * 60 * 24 * (Double)(iTrashDay))
                    
                    //print("Today:\(today), File Trash Date:\(trashDate)")
                    
                    let result = trashDate.compare(today)
                    
                    switch (result)
                    {
                    case .orderedAscending:
                        //print("OrderedAscending")
                        _ = moveOldPowerDataToTrash(filePath)
                        trashCnt += 1
//                    case .OrderedDescending:
//                        print("OrderedDescending")
//                    case .OrderedSame:
//                        print("OrderedSame")
                    default:
                        break
                    }
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
                
            }
        }
        
        return trashCnt
    }
    
    func moveOldPowerDataToTrash(_ strFilePath:String) -> Bool
    {
        var result:Bool = true
        
        let fileManager = FileManager()
        let toURL = URL(fileURLWithPath: strFilePath)
        
        do {

            try fileManager.trashItem(at: toURL, resultingItemURL: nil)

        } catch let error as NSError {
            print("moveOldPowerDataToTrash Error: \(error)")
            
            result = false
        }
        
        return result
    }
    
    func openPowerData(_ strFilePath:String, strChannel:String) -> Bool
    {
        logController.saveLogData("openPowerData()")
        logController.saveLogData("strFilePath = \(strFilePath)")
        logController.saveLogData("strChannel = \(strChannel)")
        
        var status = true
        var statusFooter = false
        
        switch(strChannel)
        {
            
        case "Master":
            
            self.OpenInfo.strSelectFilePath = strFilePath
            
            status = self.headerInfoParser(self.OpenInfo.strSelectFilePath)
            statusFooter = self.footerInfoParser(self.OpenInfo.strSelectFilePath)
            
            self.OpenInfo.nFileSize = self.sizeForLocalFilePath(self.OpenInfo.strSelectFilePath)
            self.OpenInfo.nHeaderSize = UInt64(getHeaderSize(self.OpenInfo.strSelectFilePath))
            self.OpenInfo.nFooterSize = UInt64(getFooterSize(self.OpenInfo.strSelectFilePath))
            
            logController.saveLogData("nFileSize = \(self.OpenInfo.nFileSize), nHeaderSize = \(self.OpenInfo.nHeaderSize), nFooterSize = \(self.OpenInfo.nFooterSize)")
            
            let nRawDataSize:UInt64
            
            if(statusFooter) {
                nRawDataSize = self.OpenInfo.nFileSize - self.OpenInfo.nHeaderSize - self.OpenInfo.nFooterSize
            }
            else {
                nRawDataSize = self.OpenInfo.nFileSize - self.OpenInfo.nHeaderSize
            }
            
            //Loading 되는 파일 전체 사이즈를 이용하여 Run Time을 구하고 Scroll Bar 위치를 갱신한다.
            self.OpenInfo.dRunTime = (Double)((Double)(nRawDataSize / (UInt64)(RAW_DATA_SIZE)) / ((Double)(LOAD_READ_BUF_MAX) / 20.0))
            
        case "Slave":
            
            self.OpenSlaveInfo.strSelectFilePath = strFilePath
            
            status = self.headerInfoParser(self.OpenSlaveInfo.strSelectFilePath)
            statusFooter = self.footerInfoParser(self.OpenSlaveInfo.strSelectFilePath)
            
            self.OpenSlaveInfo.nFileSize = self.sizeForLocalFilePath(self.OpenSlaveInfo.strSelectFilePath)
            self.OpenSlaveInfo.nHeaderSize = UInt64(getHeaderSize(self.OpenSlaveInfo.strSelectFilePath))
            self.OpenSlaveInfo.nFooterSize = UInt64(getFooterSize(self.OpenSlaveInfo.strSelectFilePath))

            logController.saveLogData("nFileSize = \(self.OpenSlaveInfo.nFileSize), nHeaderSize = \(self.OpenSlaveInfo.nHeaderSize), nFooterSize = \(self.OpenSlaveInfo.nFooterSize)")
            
            let nRawDataSize:UInt64
            
            if(statusFooter) {
                nRawDataSize = self.OpenSlaveInfo.nFileSize - self.OpenSlaveInfo.nHeaderSize - self.OpenSlaveInfo.nFooterSize
            }
            else {
                nRawDataSize = self.OpenSlaveInfo.nFileSize - self.OpenSlaveInfo.nHeaderSize
            }
            
            //Loading 되는 파일 전체 사이즈를 이용하여 Run Time을 구하고 Scroll Bar 위치를 갱신한다.
            self.OpenSlaveInfo.dRunTime = (Double)((Double)(nRawDataSize / (UInt64)(RAW_DATA_SIZE)) / ((Double)(LOAD_READ_BUF_MAX) / 20.0))
            
        default:
            break;
        }
        
        return status
    }
    
    func getHeaderSize(_ strFilePath:String) -> Int
    {
        var headerSize = 0
        
        let file = FileHandle(forReadingAtPath: strFilePath)
        
        if (file == nil) {
            return 0
        }
        
        file!.seek(toFileOffset: 0)
        let strData = (file?.readData(ofLength: RAW_DATA_HEADER_SIZE))!
        file?.closeFile()
        
        var buffer = [UInt8](repeating: 0, count: RAW_DATA_HEADER_SIZE)
        (strData as NSData).getBytes(&buffer, length:RAW_DATA_HEADER_SIZE * MemoryLayout<UInt8>.size)
        
        repeat {
            
            if (buffer[headerSize] == 0x23) { //#
                break
            }
            
            if (buffer[headerSize] == 0x00) { //Null
                break
            }
            
            headerSize += 1
        }while(headerSize < RAW_DATA_HEADER_SIZE)

        return headerSize
    }
    
    func getFooterSize(_ strFilePath:String) -> Int
    {
        var checkSize = 0
        var footerSize = 0
        
        let file = FileHandle(forReadingAtPath: strFilePath)
        
        if (file == nil) {
            return 0
        }
        
        var nFooterPosition:UInt64
        nFooterPosition = self.sizeForLocalFilePath(strFilePath)
        nFooterPosition -= UInt64(RAW_DATA_FOOTER_SIZE)
        
        file!.seek(toFileOffset: nFooterPosition)
        
        let strData = (file?.readData(ofLength: RAW_DATA_FOOTER_SIZE))!
        file?.closeFile()
        
        var buffer = [UInt8](repeating: 0, count: RAW_DATA_FOOTER_SIZE)
        (strData as NSData).getBytes(&buffer, length:RAW_DATA_FOOTER_SIZE * MemoryLayout<UInt8>.size)
        
        var bFooter = false
        
        repeat {
            
            if (buffer[checkSize] == 0x24           //$
                && buffer[checkSize + 1] == 0x41    //A
                && buffer[checkSize + 2] == 0x76    //v
                && buffer[checkSize + 3] == 0x67) { //g
                
                bFooter = true
            }

            if (bFooter) {
            
                if (buffer[checkSize] == 0x23) { //#
                    break
                }
            
                if (buffer[checkSize] == 0x00) { //Null
                    break
                }
            
                footerSize += 1
            }
            
            checkSize += 1
        } while(checkSize < RAW_DATA_FOOTER_SIZE)
        
        return footerSize
    }
    
    func headerInfoParser(_ strFilePath:String) -> Bool
    {
        logController.saveLogData("headerInfoParser()")
        
        var result = true
        
        let headerSize = getHeaderSize(strFilePath)
        
        let file = FileHandle(forReadingAtPath: strFilePath)
        
        if (file == nil) {
            
            NSLog("File open failed")
            result = false
        }
        else {
            
            file!.seek(toFileOffset: 0)
            let strData = (file?.readData(ofLength: headerSize))!

            var headerBuffer = [UInt8](repeating: 0, count: headerSize)
            (strData as NSData).getBytes(&headerBuffer, length:headerSize)
            let strHeaderInfo = String(bytes:headerBuffer, encoding: String.Encoding.utf8)
            
            if (strHeaderInfo == nil) {
                logController.saveLogData("Error! strHeaderInfo nil")
                result = false
            }
            else {
 
                logController.saveLogData("strHeaderInfo = \(String(describing: strHeaderInfo))")

                let strInfo = strHeaderInfo!.replacingOccurrences(of: "$", with: "")
                
                //bhjeon swift 4.0 update var strTmpArray = strInfo.characters.split{$0 == ","}.map(String.init)
                var strTmpArray = strInfo.components(separatedBy: ",")

                let strVerInfo = strTmpArray[0]
                if (strVerInfo.contains("Ver:") == true) {
                    OpenInfo.strVersionInfo = strVerInfo.replacingOccurrences(of: "Ver:", with: "")
                }
                else {
                    logController.saveLogData("Error! strVerInfo = \(strVerInfo)")
                    result = false
                }
                
                let strTimeInfo = strTmpArray[1]
                if (strTimeInfo.contains("Time:") == true) {
                    OpenInfo.strTimeInfo = strTimeInfo.replacingOccurrences(of: "Time:", with: "")
                }
                else {
                    logController.saveLogData("Error! strTimeInfo = \(strTimeInfo)")
                    result = false
                }
                
                let strFileName = strTmpArray[2]
                if (strFileName.contains("FileName:") == true) {
                    OpenInfo.strFileName = strFileName.replacingOccurrences(of: "FileName:", with: "")
                    
                    let strScopeMode = OpenInfo.strFileName
                    
                    if (strScopeMode.contains("BATOUT") == true) {
                        OpenInfo.scopeMode = .bat_OUT
                    }
                    else if (strScopeMode.contains("LEAKAGE") == true) {
                        OpenInfo.scopeMode = .bat_OUT
                        OpenInfo.scaleMode = .fine
                    }
                    else if (strScopeMode.contains("USBOUT") == true) {
                        OpenInfo.scopeMode = .usb_OUT
                    }
                    else if (strScopeMode.contains("USBCHG") == true) {
                        OpenInfo.scopeMode = .usb_CHG
                    }
                    else if (strScopeMode.contains("USBProbe") == true) {
                        OpenInfo.scopeMode = .usb_Probe
                    }
                    else {
                        OpenInfo.scopeMode = .bat_OUT
                    }
                }
                else {
                    logController.saveLogData("Error! strFileName = \(strFileName)")
                    result = false
                }
                
                if (strTmpArray.count < 5) { //Old Version Raw Data
                    
                    print("strHeaderInfo = \(String(describing: strHeaderInfo)), strTmpArray.count = \(strTmpArray.count)")
                }
                else {

                    let strBatVolt  = strTmpArray[3]
                    if (strBatVolt.contains(".") == true) {
                        OpenInfo.strBatVolt = strBatVolt
                    }
                    else {
                        logController.saveLogData("Error! strBatVolt = \(strBatVolt)")
                        result = false
                    }
                    
                    let strDeviceInfo = strTmpArray[4]
                    if (strDeviceInfo.contains("SHM") == true) {
                        OpenInfo.strDeviceInfo = strDeviceInfo
                    }
                    else {
                        logController.saveLogData("Error! strDeviceInfo = \(strDeviceInfo)")
                        result = false
                    }
                }
            }

            file?.closeFile()
        }
   
        return result
    }
    
    func footerInfoParser(_ strFilePath:String) -> Bool
    {
        logController.saveLogData("footerInfoParser()")
        
        var result = true
        
        let footerSize = getFooterSize(strFilePath)
        
        if(footerSize == 0) {
            
            NSLog("footerSize is 0")
            result = false
        }
        else {
            
            let file = FileHandle(forReadingAtPath: strFilePath)
        
            if (file == nil) {
            
                NSLog("File open failed")
                result = false
            }
            else {
            
                var nFooterPosition:UInt64
                nFooterPosition = self.sizeForLocalFilePath(strFilePath)
                nFooterPosition -= 128 // footer info는 무조건 128byte 저장되도록 변경 (UInt64)(footerSize)
            
                file!.seek(toFileOffset: nFooterPosition)
            
                let strData = (file?.readData(ofLength: footerSize))!
            
                var footerBuffer = [UInt8](repeating: 0, count: footerSize)
                (strData as NSData).getBytes(&footerBuffer, length:footerSize)
                let strFooterInfo = String(bytes:footerBuffer, encoding: String.Encoding.utf8)
            
                if (strFooterInfo == nil) {
                    logController.saveLogData("Error! strFooterInfo nil")
                    result = false
                }
                else {

                    logController.saveLogData("strFooterInfo = \(String(describing: strFooterInfo))")
                    
                    let strInfo = strFooterInfo!.replacingOccurrences(of: "$", with: "")
                
                    //bhjeon swift 4.0 update var strTmpArray = strInfo.characters.split{$0 == ","}.map(String.init)
                    var strTmpArray = strInfo.components(separatedBy: ",")
                
                    var strAvgInfo = strTmpArray[0]
                    if (strAvgInfo.contains("Avg:") == true) {
                        strAvgInfo = strAvgInfo.replacingOccurrences(of: "Avg:", with: "")
                        strAvgInfo = strAvgInfo.replacingOccurrences(of: "uA", with: "")
                        
                        OpenInfo.strAverage = strAvgInfo
                    }
                    else {
                        logController.saveLogData("Error! strAvgInfo = \(strAvgInfo)")
                        result = false
                    }
                    
                    let strRunTimeInfo = strTmpArray[1]
                    if(strRunTimeInfo.contains("RunTime:") == true) {
                        OpenInfo.strRunTime = strRunTimeInfo.replacingOccurrences(of: "RunTime:", with: "")
                    }
                    else {
                        logController.saveLogData("Error! strRunTimeInfo = \(strRunTimeInfo)")
                        result = false
                    }
                }
            
            
                file?.closeFile()
            }
        }
        
        return result
    }
}
