//
//  DeviceControl.swift
//  Smart Power Scope
//
//  Created by 전병학 on 3/2/16.
//  Copyright © 2016 SHmobile Co., LTD. All rights reserved.
//

// add define from GraphControl.swift/////////
let DIVISION_CNT:Double = 200.0 //Time(X) Axe One Division(1/10 of Total X Sacale) Display Data Counts
let GRAPH_BUFFER_PAGE:Int = 1 //3   //Graph Buffer Page Count
let ADC1_SEND_TIME = 10
let SCOPE_DATA_FULL_SIZE = 400
let SCOPE_DATA_HALF_SIZE = 200

let READ_BUF_MAX = 200
let LOAD_READ_BUF_MAX = (READ_BUF_MAX * 10)
let RAW_DATA_PARSING_CNT = (ADC1_SEND_TIME * 2)
let LOAD_DATA_SHIFT_TIME = 120 //2 min
let LOAD_DATA_MAX_TIME = 12000    //2 min 120*(LOAD_READ_BUF_MAX/20.0)
let RAW_BUF_CNT    = 6 //82*6= 492byte <= 512byte

let RAW_BUFFER_FULL_SIZE = (LOAD_DATA_MAX_TIME * RAW_DATA_PARSING_CNT)
//////////////////////////////////////////////

let CMD_SIZE = 8
let WaitRetryCnt = 3
let CommandRetryCnt = 3

//let ADC1_SEND_TIME = 10 //Trnsmit every 10 times (10ms)
let ONE_DATA_SIZE = 8
let RAW_DATA_SIZE = 82
let CMD_BUFFER_MAX = 512

let SAVE_DATA_FULL_SIZE = (RAW_DATA_SIZE * (READ_BUF_MAX / RAW_DATA_PARSING_CNT))

let CMD_CONNECT         = "$CONNECT"
let CMD_IDN             = "$CMD_IDN"
let CMD_STOP            = "$STOP__P"
let CMD_START           = "$START_P"
let CMD_SELF_STOP       = "$SELF_OF"
let CMD_SELF_START      = "$SELF_ON"
let CMD_STATUS          = "$STATUS_"
let CMD_PROTECT         = "$PROTECT"
let CMD_INIT            = "$CM_INIT"
let CMD_CHARGE_BAT      = "$CHG_BAT"
let CMD_CHECK_BAT       = "$CHK_BAT"
let CMD_LIMIT_ON        = "$LIMITON"
let CMD_LIMIT_OFF       = "$LIMITOF"
let CMD_MEASURE_NONE_MODE = "$MMODE--"
let CMD_VBAT_MODE       = "$MMODE01"
let CMD_VBUS_MODE       = "$MMODE02"
let CMD_VBUS_CHAGE_MODE = "$MMODE04"
let CMD_VBAT_DVM_MODE   = "$MMODE05"
let CMD_VBUS_DVM_MODE   = "$MMODE06"
let CMD_LEACKAGE_MODE   = "$MMODE00"
let CMD_VBAT_VBUS_MODE  = "$MMODE03"
let CMD_POWER_TEST_MODE = "$MMODE06"
let CMD_CHARGING_TEST_MODE  = "$MMODE07"
let CMD_TA_POWER_TEST_MODE  = "$MMODE08"
let CMD_TA_CABLE_TEST_MODE  = "$MMODE09"
let CMD_IR_LED_TEST_MODE    = "$MMODE10"
let CMD_EXT_CH1_TEST_MODE = "$MMODE11"
let CMD_EXT_CH2_TEST_MODE = "$MMODE12"
let CMD_ADC_AVG         = "$ADC_AVG"
let CMD_ADC_MAX         = "$ADC_MAX"
let CMD_ADC_MIN         = "$ADC_MIN"

let CMD_VBAT_ON         = "$VBAT_ON"
let CMD_VBAT_OFF        = "$VBAT_OF"
let CMD_VBUS_ON         = "$VBUS_ON"
let CMD_VBUS_OFF        = "$VBUS_OF"
let CMD_UART_ON         = "$UART_ON"
let CMD_UART_OFF        = "$UART_OF"
let CMD_JIG_ON          = "$JIG__ON"
let CMD_JIG_OFF         = "$JIG__OF"
let CMD_CHG_ON          = "$CHG__ON"
let CMD_CHG_OFF         = "$CHG__OF"
let CMD_VBAT_OCP        = "$VBATOCP"
let CMD_VBAT_ON_OCP     = "$VBATONP"
let CMD_VBAT_ON_TIME    = "$VBATONT"
let CMD_VBUS_OCP        = "$VBUSOCP"
let CMD_VBUS_ON_OCP     = "$VBUSONP"
let CMD_VBUS_ON_TIME    = "$VBUSONT"
let CMD_OCP_DATA        = "$OCP"
let CMD_ON_OCP_DATA     = "$ONP"
let CMD_ON_TIME_DATA    = "$ONT"
let CMD_VBAT_OVP        = "$VBATOVP"
let CMD_VBAT_DVP        = "$VBATDVP"
let CMD_VBUS_OVP        = "$VBUSOVP"
let CMD_VBUS_DVP        = "$VBUSDVP"
let CMD_OVP_DATA        = "$OVP"
let CMD_DVP_DATA        = "$DVP"
let CMD_PWR_START       = "$PWSTART"
let CMD_PWR_STOP        = "$PW_STOP"
let CMD_PWR_ONT         = "$PWODATA"
let CMD_PWR_OFT         = "$PWFDATA"
let CMD_PWR_CNT         = "$PWCDATA"
let CMD_PWR_CTRL_PATH   = "$PWPATH0"
let CMD_PWR_SELF_RESULT = "$RESULT0"
let CMD_CHARGING_SELF_RESULT = "$RESULT1"
let CMD_TA_POWER_SELF_RESULT = "$RESULT2"
let CMD_TA_CABLE_SELF_RESULT = "$RESULT3"
let CMD_IR_LED_SELF_RESULT = "$RESULT4"
let CMD_ID_RUNTIME      = "$RUNTIME"
let CMD_FINE_ON         = "$FINE_ON"
let CMD_FINE_OFF        = "$FINE_OF"

//SS100 Raw Data Bit Field Info

// Data High Word
let DATA_MODE_MASK                  = 0x01	// Data Mode Status: 1bit(31)
let DATA_MODE_SHIFT_VAL             = 31

let DATA_VOL_MASK                   = 0xFF	// Voltage Reference Data: 16bit(30:23)
let DATA_VOL_SHIFT_VAL              = 23

let DATA_REF_CUR_MASK               = 0x7FFFFF// Current Reference Data: 23bit(22:0)
let DATA_REF_CUR_SHIFT_VAL          = 0

// Data Low Word
let DATA_DELTA_CUR_MASK             = 0xFFFF	//Delta Current Data: 16bit (31:16)
let DATA_DELTA_CUR_SHIFT_VAL        = 16

let DATA_DELTA_STATE_MASK           = 0x01	// Delta Current Increase/Decrease Status: 1bit(15)
let DATA_DELTA_STATE_SHIFT_VAL      = 15

let DATA_VOLTAGE_STATE_MASK         = 0x01	// Voltage High/Low Status: 1bit(14)
let DATA_VOLTAGE_STATE_SHIFT_VAL    = 14

let DATA_VOLTAGE_DELTA_STATE_MASK   = 0x01	// Delta Voltage Increase/Decrese Status: 1bit(13)
let DATA_VOLTAGE_DELTA_STATE_SHIFT_VAL = 13

let DATA_DELTA_VOLTAGE_MASK         = 0x0F	// Delta Voltage Data: 4bit(12:9)
let DATA_DELTA_VOLTAGE_SHIFT_VAL    = 9

let DATA_MODE_SUB_MASK              = 0x1F	// Data Mode Sub Status: 5bit(8:4)
let DATA_MODE_SUB_SHIFT_VAL         = 4

let DATA_CURRENT_RANGE_STATE_MASK       = 0x01	// Current High/Low Status: 1bit(3)
let DATA_CURRENT_RANGE_STATE_SHIFT_VAL  = 3

let DATA_VOLTAGE_RANGE_STATE_MASK       = 0x07	// Voltage High/Low Status: 3bit(2:0)
let DATA_VOLTAGE_RANGE_STATE_SHIFT_VAL  = 0

let BAT_BASE_VOLTAGE         = 250		//CM200 VBAT Base Voltage(2.50V)
let USB_BASE_VOLTAGE         = 300		//CM200 VBUS Base Voltage(3.00V)

let VOL_1525mV  = 1525
let VOL_1270mV  = 1270
let VOL_1015mV  = 1015
let VOL_0760mV  = 760
let VOL_0505mV  = 505
let VOL_0250mV  = 250

enum VOL_RangeStatus:Int {
    case vol_RANGE1 = 0
    case vol_RANGE2
    case vol_RANGE3
    case vol_RANGE4
    case vol_RANGE5
    case vol_RANGE6
}

let DATA_ADC_MIN_MASK             = 0x01	//ADC Min Delta Data: 1bit (0)
let DATA_ADC_MIN_MASK_SHIFT_VAL   = 0

let DATA_ADC_MAX_MASK             = 0x02	//ADC Min Delta Data: 1bit (1)
let DATA_ADC_MAX_MASK_SHIFT_VAL   = 1

let DATA_ADC_AVG_MASK             = 0x04	//ADC Min Delta Data: 1bit (3)
let DATA_ADC_AVG_MASK_SHIFT_VAL   = 2

let DATA_USB_CHG_MASK             = 0x08	//USB Charger Data: 1bit (4)
let DATA_USB_CHG_MASK_SHIFT_VAL   = 3

let DATA_LEAKAGE_MASK             = 0x10	//Fine(Leakage) Scale Data: 1bit (4)
let DATA_LEAKAGE_MASK_SHIFT_VAL   = 4

let DATA_USB_OUT_MASK             = 0x20	//USB Out Data: 1bit (4)
let DATA_USB_OUT_MASK_SHIFT_VAL   = 5

let DATA_BAT_OUT_MASK             = 0x40	//BAT Out Data: 1bit (4)
let DATA_BAT_OUT_MASK_SHIFT_VAL   = 6

struct ScopeStatus {
    
    var bADC_MIN:Bool
    var bADC_MAX:Bool
    var bADC_AVG:Bool
    var bUSB_CHG:Bool
    var bLEAKAGE:Bool
    var bUSB_OUT:Bool
    var bBAT_OUT:Bool
    
}

import Cocoa

protocol DeviceControlDelegate {
    
    func returnDeviceIDN(_ controller:DeviceControl, strDeviceIDN:String)
    func returnDeviceStatus(_ controller:DeviceControl, strDeviceStatus:String)
    func returnScopeDataGraphProcess(_ controller:DeviceControl, location:Int, dVoltage:Double, dCurrent:Double, nCount:UInt64)
    func returnRawDataSaveProcess(_ controller:DeviceControl)
    func returnDeviceCommStart(_ controller:DeviceControl)
    func returnDeviceCommStop(_ controller:DeviceControl)
    func returnDeviceProtectEvent(_ controller:DeviceControl)
    func returnDeviceProtectNotify(_ controller:DeviceControl, strMessage:String)
    func returnDeviceErrorEvent(_ controller:DeviceControl)
}

enum scopeType:Int {
    case bat_OUT = 1
    case usb_OUT
    case usb_CHG
    case usb_Probe
    case ext_Ch1
    case ext_Ch2
    case bat_OUT_WITH_USB_LINK
    case none_MODE
}

enum dataType:Int {
    case adc_MIN = 1
    case adc_MAX
    case adc_AVG
    case none_MODE
}

enum scaleType:Int {
    case coarse = 1
    case fine
    case none_MODE
}

enum ifCableType:Int {
    case not_CON = 1
    case micro_USB
    case normal
    case USB_Type_C
    case error
}

enum commState:Int {
    case comm_START = 1
    case cmd_RECEIVE
    case data_RECEIVE
    case state_ERROR
}

struct DeviceStatus {
    
    var online:Bool     //Device connect online/offline
    var bOldFirmware:Bool
    var strDeviceName:String
    var strDeviceIDN:String
    var strDeviceVersion:String
    
    var dBatVolMinLimit:Double //Device Bat Voltage Minimum
    var dBatVolMaxLimit:Double //Device Bat Voltage Maximum
    
    var scopeMode:scopeType
    var dataMode:dataType
    var scaleMode:scaleType

    var batPwrOn:Bool   //true: Power On, false: Power Off
    var usbPwrOn:Bool   //true: Power On, false: Power Off
    var uartOn:Bool     //true: Switch On, false: Switch Off
    var jigOn:Bool      //true: Switch On, false: Switch Off
    var chargerOn:Bool  //true: Power On, false: Power Off
    var limitOn:Bool    //true: Protect Check Skip, false: Protect Check
    var ifType:ifCableType
    var batVolt:Double  //BAT_Out Setting Voltage, Unit: V
    var batOCP:Double   //BAT_Out Over Current Protect Limit Value, Unit: A
    var usbOCP:Double   //USB_Out Over Current Protect Limit Value, Unit: A
    var batONP:Double   //BAT_Out Power On Over Current Protect Limit Value, Unit: mA
    var usbONP:Double   //USB_Out Power On Over Current Protect Limit Value, Unit: mA
    var batONT:Double   //BAT_Out Power On Protect Limit Check Time Value, Unit: ms
    var usbONT:Double   //USB_Out Power On Protect Limit Check Time Value, Unit: ms
    var batOVP:Double   //BAT_Out Over Voltage Protect Limit Value, Unit: mV
    var usbOVP:Double   //USB_Out Over Voltage Protect Limit Value, Unit: mV
    var batDVP:Double   //BAT_Out Drop Voltage Protect Limit Value, Unit: mV
    var usbDVP:Double   //USB_Out Drop Voltage Protect Limit Value, Unit: mV
    
    var scopeVoltage:Double //Scope Voltage Average Every Packet Parsing
    var scopeCurrent:Double //Scope Current Average Every Packet Parsing
    var scopeCount:UInt64   //Scope Total Count
}

struct RawDataInfo {
    var dwScope_Low:UInt32
    var dwScope_High:UInt32
}

struct ProtectParserInfo {
    var strBatPwrOnOCP:String   //Bat Power On Over Current Protect
    var strUSBPwrOnOCP:String   //USB Power On Over Current Protect
    var strBatOCP:String        //Bat Running Over Current Protect
    var strUSBOCP:String        //USB Running Over Current Protect
    var strBatOVP:String        //Bat Over Voltage Protect
    var strUSBOVP:String        //USB Over Voltage Protect
    var strBatDVP:String        //Bat Drop Voltage Protect
    var strUSBDVP:String        //USB Drop Voltage Protect
}
class DeviceControl: NSObject, ORSSerialPortDelegate {

    var deviceControldelegate:DeviceControlDelegate?
    
    var serialPort: ORSSerialPort? {
    /*
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
      */
        willSet {
            if let port = serialPort {
                port.close()
                port.delegate = nil
            }
        }
        didSet {
            if let port = serialPort {
                port.baudRate = 115200
                port.rts = true
                port.delegate = self
                port.open()
            }
        }
    }
    
    struct DeviceInfo {
        
        var serialPort:ORSSerialPort? {
            willSet {
                if let port = serialPort {
                    port.close()
                    port.delegate = nil
                }
            }
            didSet {
                if let port = serialPort {
                    port.baudRate = 115200
                    port.rts = true
                    //port.delegate = self
                    port.open()
                }
            }
        }
        var strName:String
        var strVersion:String
        var strIDN:String
    }

    var m_DeviceInfoArray:[DeviceInfo] = []

    var DeviceStatusInfo = DeviceStatus(online: false, bOldFirmware: false, strDeviceName: "", strDeviceIDN: "", strDeviceVersion: "", dBatVolMinLimit: 1.7, dBatVolMaxLimit: 4.55,scopeMode:.none_MODE, dataMode: .adc_AVG, scaleMode: .coarse, batPwrOn:false, usbPwrOn:false, uartOn:false, jigOn:false, chargerOn:false, limitOn:false, ifType:.not_CON, batVolt:4.00, batOCP:4.5, usbOCP:3.2, batONP:1500, usbONP:1000, batONT:100, usbONT:100, batOVP:1000, usbOVP:1000, batDVP:1000, usbDVP:1000, scopeVoltage:0.0, scopeCurrent:0.0, scopeCount:0)
    
    var DeviceProtectInfo = ProtectParserInfo(strBatPwrOnOCP: "0mA", strUSBPwrOnOCP: "0mA", strBatOCP: "0mA", strUSBOCP: "0mA", strBatOVP: "0mA", strUSBOVP: "0mA", strBatDVP: "0mA", strUSBDVP: "0mA")
    
    var m_cmdReqData = NSMutableData()
    var m_strReqCmd:String = ""
    var m_strRspMsg:String = ""
    var m_nCmdError:Int = 0
    
    var m_nTaskComm:commState = .comm_START
    
    var m_nReceiveCnt:Int = 0
    var m_ReceiveBuffer = [UInt8](repeating: 0x00, count: RAW_DATA_SIZE)
    var m_CmdReceiveBuffer = [UInt8](repeating: 0x00, count: CMD_BUFFER_MAX)
    var m_ReceiveChecksum:UInt8 = 0
    
    var m_nScopeCnt:Int = 0
    var scopeToGraphBuffer1 = [Double](repeating: 0.00, count: SCOPE_DATA_FULL_SIZE)
    var scopeToGraphBuffer2 = [Double](repeating: 0.00, count: SCOPE_DATA_FULL_SIZE)

    var m_nSaveCnt:Int = 0
    var m_SaveBuffer = [UInt8](repeating: 0x00, count: SAVE_DATA_FULL_SIZE)
    
    var m_ScopeVoltageSum:Double = 0.0
    var m_ScopeCurrentSum:Double = 0.0

    var m_ScopeCurrentUnit:Double = 1.0
    
    func setDeviceScopeDataInit() -> Void
    {
        m_nTaskComm = .comm_START
        
        m_nReceiveCnt = 0
        m_ReceiveBuffer = [UInt8](repeating: 0x00, count: RAW_DATA_SIZE)
        m_ReceiveChecksum = 0
        
        m_nScopeCnt = 0
        scopeToGraphBuffer1 = [Double](repeating: 0.00, count: SCOPE_DATA_FULL_SIZE)
        scopeToGraphBuffer2 = [Double](repeating: 0.00, count: SCOPE_DATA_FULL_SIZE)
        
        m_nSaveCnt = 0
        m_SaveBuffer = [UInt8](repeating: 0x00, count: SAVE_DATA_FULL_SIZE)
        
        m_ScopeVoltageSum = 0.0
        m_ScopeCurrentSum = 0.0
        
        DeviceStatusInfo.scopeVoltage = 0.0
        DeviceStatusInfo.scopeCurrent = 0.0
        DeviceStatusInfo.scopeCount = 0
    }
    
    func setCurrentUnit(_ strUnit:String) -> Void
    {
        switch(strUnit)
        {
        case "uA":
            m_ScopeCurrentUnit = 1000.0 //0.001
        case "mA":
            m_ScopeCurrentUnit = 1.0
        default:
            m_ScopeCurrentUnit = 1.0
            break
        }
    }
    
    func isBusyPort(_ selectPort:ORSSerialPort) ->Bool
    {
        serialPort = selectPort
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            if (sendCommand(strCmd: "$STOP__P") == false) {
                
                serialPort!.close()
                return false
            }

            serialPort!.close()
            return true
        }
        else {
            
            serialPort!.close()
            return false
        }
    }
    
    func setDeviceInit(_ selectPort:ORSSerialPort) ->Bool
    {
        var status:Bool = false
        
        //NSLog("selectPort.name = %@", selectPort.name)
        logController.saveLogData("setDeviceInit() selectPort.name = \(selectPort.name)")

        serialPort = selectPort
        
        serialPort!.open()

        if (serialPort!.isOpen == true) {
            
            if (sendCommand(strCmd: "$CM_INIT") == false) {
                
                serialPort!.close()
                return false
            }
            
            status = true
        }

        Thread.sleep(forTimeInterval: 0.7) //Wait 0.7 second
        serialPort!.close()
        
        print("setDeviceInit status = \(status)")
        
        return status
    }
    
    func getDeviceState(_ selectPort:ORSSerialPort) ->Bool
    {
        var status:Bool = false
        
        //NSLog("selectPort.name = %@", selectPort.name)
        logController.saveLogData("getDeviceState() selectPort.name = \(selectPort.name)")
        
        serialPort = selectPort
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            if (sendCommand(strCmd: CMD_STATUS) == false) {
                
                serialPort!.close()
                return false
            }
            
            _ = sendCommand(strCmd: CMD_START)
            
            status = true
        }
        
        //Thread.sleep(forTimeInterval: 0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("getDeviceState status = \(status)")
        
        return status
    }
    
    func getDeviceProtectState() ->Bool
    {
        var status:Bool = false
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            if (sendCommand(strCmd: "$PROTECT") == false) {
                
                serialPort!.close()
                return false
            }
            
            status = true
        }
        
        Thread.sleep(forTimeInterval: 0.7) //Wait 0.7 second
        serialPort!.close()
        
        print("getDeviceProtectState status = \(status)")
        
        return status
    }

    func getModelInfo(_ selectPort:ORSSerialPort) ->Bool
    {
        var status:Bool = false
        
        //NSLog("selectPort.name = %@", selectPort.name)
        logController.saveLogData("getModelInfo() selectPort.name = \(selectPort.name)")
        
        serialPort = selectPort
        
        serialPort!.open()

        if (serialPort!.isOpen == true) {

            if (sendCommand(strCmd: "$STOP__P") == false) {
            
                serialPort!.close()
                return false
            }

            if (sendCommand(strCmd: "$CMD_IDN") == false) {

                serialPort!.close()
                return false
            }
            
            status = true
        }

        //direct close after for command start  NSThread.sleepForTimeInterval(1.0) //Wait 1.0 second
        serialPort!.close()

        print("getModelInfo status = \(status)")
        
        return status
    }

    func setDeviceVoltage(_ nVoltage:Int) -> Bool
    {
        var strVoltage:String = ""
        var status:Bool = false
        
        if (nVoltage > 999) {
            strVoltage = NSString(format: "$TOL%04d",nVoltage) as String
        }
        else {
            strVoltage = NSString(format: "$VOLT%03d",nVoltage) as String
        }
        
        if (serialPort == nil) {
            return false
        }
        
        if (serialPort!.isOpen == false) {
            serialPort!.open()
        }
        
        if (serialPort!.isOpen == true) {
            
            _ = sendCommand(strCmd: strVoltage)
            status = true
        }
        
        print("setDeviceVoltage status = \(status)")

        DeviceStatusInfo.batVolt = (Double)(nVoltage) / 100.0
        
        return status
    }

    func Operation_None_Mode(_ old_ScopeMode:scopeType) -> Bool
    {
        
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        if (serialPort!.isOpen == false) {
            serialPort!.open()
        }
        
        if (serialPort!.isOpen == true) {
            
            _ = sendCommand(strCmd: CMD_STOP)
            _ = sendCommand(strCmd: CMD_JIG_OFF)
            _ = sendCommand(strCmd: CMD_MEASURE_NONE_MODE)
            
            status = true
        }
        
        Thread.sleep(forTimeInterval: 0.7) //Wait 0.7 second
        serialPort!.close()
        
        print("Operation_None_Mode status = \(status)")
        
        DeviceStatusInfo.scopeMode = .none_MODE
        
        return status
    }
    
    func Operation_DataMode(_ strDataMode:String) -> Bool
    {
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        switch(strDataMode)
        {
        case "Avg":
            DeviceStatusInfo.dataMode = .adc_AVG
            
        case "Peak":
            DeviceStatusInfo.dataMode = .adc_MAX
        default:
            break
        }
        
        if (serialPort!.isOpen == false) {
            serialPort!.open()
        }
        
        if (serialPort!.isOpen == true) {
            
            switch (DeviceStatusInfo.dataMode) {
                
            case .adc_AVG:
                _ = sendCommand(strCmd: CMD_ADC_AVG)
                
            case .adc_MAX:
                _ = sendCommand(strCmd: CMD_ADC_MAX)
                
            case .adc_MIN:
                _ = sendCommand(strCmd: CMD_ADC_MIN)
            default:
                break
            }
            
            status = true
        }
        
        print("Operation_DataMode status = \(status)")

        return status
    }
    
    func Operation_ScaleMode(_ strScaleMode:String) -> Bool
    {
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        switch(strScaleMode)
        {
            
        case "Coarse":
            DeviceStatusInfo.scaleMode = .coarse
            
        case "Fine":
            DeviceStatusInfo.scaleMode = .fine
        default:
            break
        }
        
        if (serialPort!.isOpen == false) {
            serialPort!.open()
        }
        
        if (serialPort!.isOpen == true) {
            
            switch (DeviceStatusInfo.scaleMode) {
                
            case .coarse:
                _ = sendCommand(strCmd: CMD_FINE_OFF)
                
            case .fine:
                _ = sendCommand(strCmd: CMD_FINE_ON)

            default:
                break
            }
            
            status = true
        }
        
        print("Operation_DataMode status = \(status)")
        
        return status
    }
    
    func Operation_BAT_OUT(_ old_ScopeMode:scopeType) -> Bool
    {

        var status:Bool = false

        if (serialPort == nil) {
            return false
        }
        
        if (serialPort!.isOpen == false) {
            serialPort!.open()
        }
        
        if (serialPort!.isOpen == true) {
            
            switch(old_ScopeMode)
            {
            case .usb_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBUS_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_CHG:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_CHG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_Probe:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .none_MODE:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_MODE)
                _ = sendCommand(strCmd: CMD_START)

            default:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_MODE)
                _ = sendCommand(strCmd: CMD_START)
                break
            }

            status = true
        }
        
        //NSThread.sleepForTimeInterval(0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("Operation_BAT_OUT status = \(status)")
        
        DeviceStatusInfo.scopeMode = .bat_OUT
        
        return status
    }
    
    func Operation_USB_OUT(_ old_ScopeMode:scopeType) -> Bool
    {
        
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            switch(old_ScopeMode)
            {
            case .none_MODE:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBUS_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_CHG:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_CHG_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_Probe:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .bat_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            default:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_MODE)
                _ = sendCommand(strCmd: CMD_START)
                break
            }
            
            status = true
        }
        
        //NSThread.sleepForTimeInterval(0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("Operation_USB_OUT status = \(status)")
        
        DeviceStatusInfo.scopeMode = .usb_OUT
        
        return status
    }
    
    func Operation_USB_CHG(_ old_ScopeMode:scopeType) -> Bool
    {
        
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            switch(old_ScopeMode)
            {
            case .usb_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBUS_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_CHAGE_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .none_MODE:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_CHG_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_CHAGE_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_Probe:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_CHAGE_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .bat_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_CHAGE_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            default:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_CHAGE_MODE)
                _ = sendCommand(strCmd: CMD_START)
                break
            }
            
            status = true
        }
        
        //NSThread.sleepForTimeInterval(0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("Operation_USB_CHG status = \(status)")
        
        DeviceStatusInfo.scopeMode = .usb_CHG
        
        return status
    }
    
    func Operation_USB_Probe(_ old_ScopeMode:scopeType) -> Bool
    {
        
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            switch(old_ScopeMode)
            {
            case .usb_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBUS_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_DVM_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_CHG:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_CHG_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_DVM_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .none_MODE:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_DVM_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .bat_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_DVM_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            default:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_DVM_MODE)
                _ = sendCommand(strCmd: CMD_START)
                break
            }
            
            status = true
        }
        
        //NSThread.sleepForTimeInterval(0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("Operation_USB_Probe status = \(status)")
        
        DeviceStatusInfo.scopeMode = .usb_Probe
        
        return status
    }
    
    func Operation_EXT_CH1(_ old_ScopeMode:scopeType) -> Bool
    {
        
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            switch(old_ScopeMode)
            {
            case .usb_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBUS_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH1_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_CHG:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_CHG_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH1_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .none_MODE:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH1_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .bat_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH1_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            default:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_EXT_CH1_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                break
            }
            
            status = true
        }
        
        //NSThread.sleepForTimeInterval(0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("Operation_EXT_CH1 status = \(status)")
        
        DeviceStatusInfo.scopeMode = .ext_Ch1
        
        return status
    }
    
    func Operation_EXT_CH2(_ old_ScopeMode:scopeType) -> Bool
    {
        
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            switch(old_ScopeMode)
            {
            case .usb_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBUS_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH2_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .usb_CHG:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_CHG_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH2_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .none_MODE:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH2_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            case .bat_OUT:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_VBAT_OFF)
                _ = sendCommand(strCmd: CMD_EXT_CH2_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                
            default:
                _ = sendCommand(strCmd: CMD_STOP)
                _ = sendCommand(strCmd: CMD_EXT_CH2_TEST_MODE)
                _ = sendCommand(strCmd: CMD_START)
                break
            }
            
            status = true
        }
        
        //NSThread.sleepForTimeInterval(0.7) //Wait 0.7 second
        //serialPort!.close()
        
        print("Operation_EXT_CHs status = \(status)")
        
        DeviceStatusInfo.scopeMode = .ext_Ch2
        
        return status
    }
    
    func Operation_USB_OnOff(_ bOnOff:Bool) -> Bool
    {
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            if (bOnOff == true) {
                _ = sendCommand(strCmd: CMD_JIG_OFF)
                _ = sendCommand(strCmd: CMD_VBUS_ON)
            }
            else {
                _ = sendCommand(strCmd: CMD_VBUS_OFF)
            }
            
            status = true
        }
        
        print("Operation_USB_OnOff status = \(status)")
        
        return status
    }
    
    func Operation_AutoPower_OnOff(_ bOnOff:Bool) -> Bool
    {
        var status:Bool = false
        
        if (serialPort == nil) {
            return false
        }
        
        serialPort!.open()
        
        if (serialPort!.isOpen == true) {
            
            if (bOnOff == true) {
                _ = sendCommand(strCmd: CMD_JIG_ON)
            }
            else {
                _ = sendCommand(strCmd: CMD_JIG_OFF)
            }
            
            status = true
        }
        
        print("Operation_AutoPower_OnOff status = \(status)")
        
        return status
    }
    
    func DeviceIDN_Updater(_ strIDN:String) -> Bool
    {
        var status:Bool = true
        
        var strIDNData = strIDN

        //bhjeon swift 4.0 update var strTmpArray = strIDNData.characters.split{$0 == "/"}.map(String.init)
        var strTmpArray = strIDNData.components(separatedBy: "/")
        strIDNData = strTmpArray[1]
        
        //bhjeon swift 4.0 update strTmpArray = strIDNData.characters.split{$0 == ";"}.map(String.init)
        strTmpArray = strIDNData.components(separatedBy: ";")
        
        if (strTmpArray.count != 3) { //비정상 IDN 응답 Data 발생시
            
            status = false
            return status
        }
        else {
            
            let strIDN:String = strTmpArray[2]
            //bhjeon swift 4.0 update print("IDN Length = \(strIDN.characters.count)")
            print("IDN Length = \(strIDN.count)")
            
            //bhjeon swift 4.0 update if (strIDN.characters.count < 10) {
            if (strIDN.count < 10) {
                
                status = false
                return status
            }
            else {
                
                let addInfo = DeviceInfo(serialPort: serialPort, strName: strTmpArray[0], strVersion: strTmpArray[1], strIDN: strTmpArray[2])
                m_DeviceInfoArray.append(addInfo)
                let index = m_DeviceInfoArray.count - 1
                print("Device[\(index)] Info = \(m_DeviceInfoArray[index].serialPort!.name), \(m_DeviceInfoArray[index].strName), \(m_DeviceInfoArray[index].strVersion), \(m_DeviceInfoArray[index].strIDN)")
            }
        }
        return status
    }
    
    func DeviceStatusUpdater(_ strStatus:String) -> Bool
    {
        var status:Bool = true
        
        let strStatusData:String = strStatus
        
        //bhjeon swift 4.0 update var strTmpArray = strStatusData.characters.split{$0 == "/"}.map(String.init)
        var strTmpArray = strStatusData.components(separatedBy: "/")
        
        let strRspData = strTmpArray[1] //Response data
        
        //bhjeon swift 4.0 update strTmpArray = strRspData.characters.split{$0 == ";"}.map(String.init)
        strTmpArray = strRspData.components(separatedBy: ";")
        
        if (strTmpArray.count < 19) {
            
            print("DeviceStatusUpdater() Error, strTmpArray.count = \(strTmpArray.count)")
            status = false
            return status
        }
        
        var strStatusArry:[String]
        var strStatus:String
        
        // MARK: -Scope Mode Status Parsing
        let strMode     = strTmpArray[0]
        //bhjeon swift 4.0 update strStatusArry = strMode.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strMode.components(separatedBy: "=")
        strStatus = strStatusArry[1]
        
        let nScopeMode:Int = strStatus.toInteger()!
        // to next let nScopeMode:Int = Int(strStatus) ?? 0

        switch(nScopeMode)
        {
        case 0: //BAT Out Leakage Mode
            DeviceStatusInfo.scopeMode = .bat_OUT
            DeviceStatusInfo.scaleMode = .fine
            
        case 1: //BAT Out Normal Mode
            DeviceStatusInfo.scopeMode = .bat_OUT
            
        case 2: //USB Out Mode
            DeviceStatusInfo.scopeMode = .usb_OUT
            
        case 3: //BAT Out & USB Link Mode
            DeviceStatusInfo.scopeMode = .bat_OUT_WITH_USB_LINK
        case 4: //USB Charger Mode
            DeviceStatusInfo.scopeMode = .usb_CHG
        case 6: //USB Probe Mode (Need firmware add!)
            DeviceStatusInfo.scopeMode = .usb_Probe
        case 9: //Measure Mode None
            DeviceStatusInfo.scopeMode = .none_MODE
        default:
            DeviceStatusInfo.scopeMode = .none_MODE
            break
        }

        // MARK: -BAT Power On/Off Status Parsing
        let strBATPwr   = strTmpArray[1]
        //bhjeon swift 4.0 update strStatusArry = strBATPwr.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strBATPwr.components(separatedBy: "=")
        strStatus = strStatusArry[1]

        if (strStatus.contains("1") == true) {
            DeviceStatusInfo.batPwrOn = true
        }
        else if (strStatus.contains("0") == true){
            DeviceStatusInfo.batPwrOn = false
        }
        else {
            status = false
        }
        
        // MARK: -USB Power On/Off Status Parsing
        let strUSBPwr   = strTmpArray[2]
        //bhjeon swift 4.0 update strStatusArry = strUSBPwr.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strUSBPwr.components(separatedBy: "=")
        strStatus = strStatusArry[1]
        
        if (strStatus.contains("1") == true) {
            DeviceStatusInfo.usbPwrOn = true
        }
        else if (strStatus.contains("0") == true){
            DeviceStatusInfo.usbPwrOn = false
        }
        else {
            status = false
        }
        
        // MARK: -UART_Switch Status Parsing
        let strUART     = strTmpArray[3]
        //bhjeon swift 4.0 update strStatusArry = strUART.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strUART.components(separatedBy: "=")
        strStatus = strStatusArry[1]
        
        if (strStatus.contains("1") == true) {
            DeviceStatusInfo.uartOn = true
        }
        else if (strStatus.contains("0") == true){
            DeviceStatusInfo.uartOn = false
        }
        else {
            status = false
        }
        
        // MARK: -Jig_On_Switch Status Parsing
        let strJigOn    = strTmpArray[4]
        //bhjeon swift 4.0 update strStatusArry = strJigOn.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strJigOn.components(separatedBy: "=")
        strStatus = strStatusArry[1]
        
        if (strStatus.contains("1") == true) {
            DeviceStatusInfo.jigOn = true
        }
        else if (strStatus.contains("0") == true){
            DeviceStatusInfo.jigOn = false
        }
        else {
            status = false
        }
        
        // MARK: -JCHG Power On/Off Status Parsing
        let strCHGPwr   = strTmpArray[5]
        //bhjeon swift 4.0 update strStatusArry = strCHGPwr.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strCHGPwr.components(separatedBy: "=")
        strStatus = strStatusArry[1]
        
        if (strStatus.contains("1") == true) {
            DeviceStatusInfo.chargerOn = true
        }
        else if (strStatus.contains("0") == true){
            DeviceStatusInfo.chargerOn = false
        }
        else {
            status = false
        }
        
        // MARK: -Limit_On Status Parsing
        let strLimitOn  = strTmpArray[6]
        //bhjeon swift 4.0 update strStatusArry = strLimitOn.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strLimitOn.components(separatedBy: "=")
        strStatus = strStatusArry[1]
        
        if (strStatus.contains("1") == true) {
            DeviceStatusInfo.limitOn = true
        }
        else if (strStatus.contains("0") == true){
            DeviceStatusInfo.limitOn = false
        }
        else {
            status = false
        }

        // MARK: -IF Cable Type Status Parsing
        let strIFtype   = strTmpArray[7]
        //bhjeon swift 4.0 update strStatusArry = strIFtype.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strIFtype.components(separatedBy: "=")
        strStatus = strStatusArry[1]

        if(strStatus.contains("NOT_CON") == true) {
            DeviceStatusInfo.ifType = .not_CON
        }
        else if(strStatus.contains("MICRO_USB") == true) {
            DeviceStatusInfo.ifType = .micro_USB
        }
        else if(strStatus.contains("NORMAL") == true) {
            DeviceStatusInfo.ifType = .normal
        }
        else if(strStatus.contains("USB_Type-C") == true) {
            DeviceStatusInfo.ifType = .USB_Type_C
        }
        else {
            DeviceStatusInfo.ifType = .error
        }

        // MARK: -BAT Out Voltage Status Parsing
        let strBATOUT   = strTmpArray[8]
        //bhjeon swift 4.0 update strStatusArry = strBATOUT.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strBATOUT.components(separatedBy: "=")
        strStatus = strStatusArry[1]

        var strBatOutVoltage = strStatus.replacingOccurrences(of: "V", with: "")
        strBatOutVoltage = strBatOutVoltage.replacingOccurrences(of: " ", with: "")
        
        DeviceStatusInfo.batVolt = strBatOutVoltage.toDouble()!
        // to next DeviceStatusInfo.batVolt = Double(strBatOutVoltage) ?? 4.00

        /*
        let strBATOCP   = strTmpArray[9]  //BAT Out Over Current Protect Limit Value
        let strUSBOCP   = strTmpArray[10] //USB Out Over Current Protect Limit Value
        let strBATONP   = strTmpArray[11] //BAT Out Power On Protect Limit Value
        let strUSBONP   = strTmpArray[12] //USB Out Power On Protect Limit Value
        let strBATONT   = strTmpArray[13] //BAT Out Power On Protect Limit Check Time Value
        let strUSBONT   = strTmpArray[14] //USB Out Power On Protect Limit Check Time Value
        let strBATOVP   = strTmpArray[15] //BAT Out Over Voltage Protect Limit Value
        let strUSBOVP   = strTmpArray[16] //USB Out Over Voltage Protect Limit Value
        let strBATDVP   = strTmpArray[17] //BAT Out Drop Voltage Protect Limit Value
        let strUSBDVP   = strTmpArray[18] //USB Out Drop Voltage Protect Limit Value
        */
        
        return status
    }
    
    func DeviceProtectParser(_ strStatus:String) -> (bVaild:Bool, strMessage:String)
    {
        var status:Bool = true
        var strMsg:String = ""
        
        var strStatusData:String = strStatus
        strStatusData = strStatusData.replacingOccurrences(of: " ", with: "")
        strStatusData = strStatusData.replacingOccurrences(of: "\r", with: "")
        //strStatusData = strStatusData.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        strStatusData = strStatusData.trim() //String extention
        
        //bhjeon swift 4.0 update var strTmpArray = strStatusData.characters.split{$0 == "/"}.map(String.init)
        var strTmpArray = strStatusData.components(separatedBy: "/")
        
        let strRspData = strTmpArray[1] //Response data
        
        //bhjeon swift 4.0 update strTmpArray = strRspData.characters.split{$0 == ";"}.map(String.init)
        strTmpArray = strRspData.components(separatedBy: ";")
        
        if (strTmpArray.count < 8) {
            
            logController.saveLogData("DeviceProtectParser() Error, strTmpArray.count = \(strTmpArray.count)")
            status = false
            return (status, strMsg)
        }
        
        if (DeviceStatusInfo.online == false) {
            status = true
            strMsg = "Device Protect, Re-start!(off->on)"
            logController.saveLogData("DeviceProtectParser() \(strMsg)")
            return (status, strMsg)
        }
        
        var strStatusArry:[String]
        var strStatusValue:String
        var strStatus:String
        
        // MARK: -Protect Mode Status Parsing
        strStatus = strTmpArray[0]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strBatPwrOnOCP = strStatusValue
        if (strStatusValue != "0mA") {
            strMsg = NSString(format: "Bat Out Over Current Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[1]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strUSBPwrOnOCP = strStatusValue
        if (strStatusValue != "0mA") {
            strMsg = NSString(format: "USB Out Over Current Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[2]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strBatOCP = strStatusValue
        if (strStatusValue != "0mA") {
            strMsg = NSString(format: "Bat Out Power On Over Current Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[3]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strUSBOCP = strStatusValue
        if (strStatusValue != "0mA") {
            strMsg = NSString(format: "USB Out Power On Over Current Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[4]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strBatOVP = strStatusValue
        if (strStatusValue != "0mV") {
            strMsg = NSString(format: "Bat Out Over Voltage Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[5]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strUSBOVP = strStatusValue
        if (strStatusValue != "0mV") {
            strMsg = NSString(format: "USB Out Over Voltage Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[6]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strBatDVP = strStatusValue
        if (strStatusValue != "0mV") {
            strMsg = NSString(format: "Bat Out Drop Voltage Protect(%@)", strStatusValue) as String
        }
        
        strStatus = strTmpArray[7]
        //bhjeon swift 4.0 update strStatusArry = strStatus.characters.split{$0 == "="}.map(String.init)
        strStatusArry = strStatus.components(separatedBy: "=")
        strStatusValue = strStatusArry[1]
        DeviceProtectInfo.strUSBDVP = strStatusValue
        if (strStatusValue != "0mV") {
            strMsg = NSString(format: "USB Out Drop Voltage Protect(%@)", strStatusValue) as String
        }
        
        logController.saveLogData("DeviceProtectParser() \(strMsg)")
        
        return (status, strMsg)
    }

        
    func sendCommand(strCmd:String) -> Bool
    {
        var status:Bool = false
        
        var sumValue:UInt8 = 0
        var checksum:UInt8 = 0x00
        
        let strData = strCmd.data(using: String.Encoding.utf8)!
        var buffer = [UInt8](repeating: 0, count: CMD_SIZE + 1)
        (strData as NSData).getBytes(&buffer, length:CMD_SIZE * MemoryLayout<UInt8>.size)
        
        m_strReqCmd = strCmd
        m_strRspMsg = ""
        m_nCmdError = 0
        
        for i in 0 ..< CMD_SIZE {
            
            //NSLog("buffer[%d] = 0x%x",i, buffer[i])

            let UInt8_spare = 0xff - sumValue
            
            if (UInt8(buffer[i]) > UInt8(UInt8_spare)) {
                sumValue = UInt8(buffer[i]) - (UInt8_spare) - 1
            }
            else {
                sumValue += UInt8(buffer[i])
            }
        }
        checksum = sumValue
        
        //NSLog("checksum = 0x%x", checksum)
        checksum = ~checksum
        
        if (checksum >= 0xff) {
            checksum = 0
        }
        else {
            checksum = checksum + 1
        }
        //NSLog("checksum = 0x%x", checksum)
        switch (checksum) //장치 Sig에 대한 CRC은 예외 처리
        {
            case 0x26: //"$"
                checksum = 0x00
            case 0x2A: //"*"
                checksum = 0x00
            case 0x40: //"@"
                checksum = 0x00
            
            default: break
        }
        
        //let cmdData = NSMutableData()
        var CR:UInt8 = 0x0D
        var LF:UInt8 = 0x0A
        
        m_cmdReqData = NSMutableData()
        m_cmdReqData.append(strData)
        m_cmdReqData.append(&checksum, length: 1)
        m_cmdReqData.append(&CR, length: 1)
        m_cmdReqData.append(&LF, length: 1)
        //print("m_cmdReqData = \(m_cmdReqData.description)")
        
        logController.saveLogData(">> \(strCmd)")
        
        status = (serialPort?.send(m_cmdReqData as Data))!
 
        self.deviceControldelegate?.returnDeviceCommStart(self)
        
        Thread.sleep(forTimeInterval: 0.2) //Wait 0.5 second
        
        return status
    }

    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        
        //NSLog("serialPort.name = %@, Open succeeds", serialPort.name)
        logController.saveLogData("serialPortWasOpened() \(serialPort.name)")
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        
        self.deviceControldelegate?.returnDeviceCommStop(self)
        //NSLog("serialPort.name = %@, Close succeeds", serialPort.name)
        logController.saveLogData("serialPortWasClosed() \(serialPort.name)")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {

        let nRxBytes = data.count
        var Rxbuffer = [UInt8](repeating: 0x00, count: nRxBytes)
        
        (data as NSData).getBytes(&Rxbuffer, length: nRxBytes  * MemoryLayout<UInt8>.size)
        
        for i in 0 ..< nRxBytes {
            
            let rxdata = Rxbuffer[i]
            
            switch(m_nTaskComm) {
                
            case .comm_START:
                
                if (rxdata == 0x24) { // $
                    
                    m_nReceiveCnt = 0
                    m_nTaskComm = .cmd_RECEIVE
                    m_CmdReceiveBuffer[m_nReceiveCnt] = rxdata
                    m_nReceiveCnt += 1
                    
                    print("Command Receive")
                }
                else if (rxdata == 0x23) {// #
                    
                    m_nReceiveCnt = 0
                    m_nTaskComm = .data_RECEIVE
                }
                else {
                    
                }
                
            case .cmd_RECEIVE:
                
                if (m_nReceiveCnt < CMD_BUFFER_MAX) {

                    m_CmdReceiveBuffer[m_nReceiveCnt] = Rxbuffer[i]

                    if (m_nReceiveCnt >= 9) {

                        var bRxEnd:Bool = false
                        
                         if ((m_CmdReceiveBuffer[m_nReceiveCnt - 1] == 0x0D) && (m_CmdReceiveBuffer[m_nReceiveCnt] == 0x0A)) {
                            bRxEnd = true
                         }
                        
                        if (bRxEnd == true) {
                            
                            let cmdData:Data = Data(bytes: UnsafePointer<UInt8>(m_CmdReceiveBuffer), count: m_nReceiveCnt)
                            let strCmd = NSString(data: cmdData, encoding: String.Encoding.utf8.rawValue)
                            //print("strCmd = \(strCmd)")
                            
                            if let strResponse:String = strCmd as String? {
                                
                                logController.saveLogData("<< \(strResponse)")

                                ReceiveCommandParser(strResponse)
                            }
                            m_nTaskComm = .comm_START
                        }
                    }
                    
                    m_nReceiveCnt += 1
                }
                else {
                    
                    m_nReceiveCnt = 0
                    m_nTaskComm = .comm_START
                }
                
            case .data_RECEIVE:
                
                m_ReceiveBuffer[m_nReceiveCnt] = Rxbuffer[i]
                
                if (m_nReceiveCnt < (ADC1_SEND_TIME * ONE_DATA_SIZE)) { //Calibration Check Sum
                    
                    let UInt8_spare = 0xff - m_ReceiveChecksum
                    
                    if (UInt8(m_ReceiveBuffer[m_nReceiveCnt]) > UInt8(UInt8_spare)) {
                        
                        m_ReceiveChecksum = UInt8(m_ReceiveBuffer[m_nReceiveCnt]) - (UInt8_spare) - 1
                    }
                    else {
                        m_ReceiveChecksum += UInt8(m_ReceiveBuffer[m_nReceiveCnt])
                    }
                }
                else {
                    
                    //print("ReceiveChecksum =\(m_ReceiveChecksum)")
                    
                    m_ReceiveChecksum = ~m_ReceiveChecksum
                    
                    if (m_ReceiveChecksum >= 0xff) {
                        m_ReceiveChecksum = 0
                    }
                    else {
                        m_ReceiveChecksum = m_ReceiveChecksum + 1
                    }
                    
                    if (m_ReceiveChecksum == m_ReceiveBuffer[m_nReceiveCnt]) {
                        //print("ReceiveChecksum OK!")
                        ReceiveDataParser(m_ReceiveChecksum)
                    }
                    else {
                        
                        print("ReceiveChecksum =\(m_ReceiveChecksum)")
                        print("m_ReceiveBuffer[\(m_nReceiveCnt)] =\(m_ReceiveBuffer[m_nReceiveCnt])")
                        print("ReceiveChecksum Error!")
                        
         
                    }
                    
                    m_ReceiveChecksum = 0
                    m_nTaskComm = .comm_START
                }
                
                m_nReceiveCnt += 1
                
            default:
                break
            }
        }
    }

    func ReceiveCommandParser(_ strResponse:String) -> Void
    {
        //print("ReceiveCommandParser = \(strResponse)")

        m_strRspMsg = strResponse
        
        if (m_strRspMsg.contains("$STOP")) {
            //print("$STOP response = \(m_strRspMsg)")
        }
        else if (m_strRspMsg.contains("$ERR")) {
            //print("$ERR response = \(m_strRspMsg)")
        }
        else if (m_strRspMsg.contains("$CM_INIT")) {
            //print("$CM_INIT response = \(m_strRspMsg)")
        }
        else if (m_strRspMsg.contains("$STATUS_")) {
            //print("$STATUS_ response = \(m_strRspMsg)")
            
            if (DeviceStatusUpdater(m_strRspMsg) == true) {
                
                self.deviceControldelegate?.returnDeviceStatus(self, strDeviceStatus: m_strRspMsg)
            }
            else {
                //print("$STATUS_ response Error!")
                logController.saveLogData("ReceiveCommandParser() $STATUS_ response Error!")
            }
        }
        else if (m_strRspMsg.contains("$CMD_IDN")) { //제품 정보 Response에 대한 처리
            
            m_strRspMsg = m_strRspMsg.replacingOccurrences(of: " ", with: "")
            
            if (DeviceIDN_Updater(m_strRspMsg) == true) {
                
                self.deviceControldelegate?.returnDeviceIDN(self, strDeviceIDN: m_strRspMsg)
            }
            else {
                //print("$CMD_IDN_ response Error!")
                logController.saveLogData("ReceiveCommandParser() $CMD_IDN_ response Error!")
            }
        }
        else if (m_strRspMsg.contains("$P__STOP")) {
            
            self.deviceControldelegate?.returnDeviceProtectEvent(self)
        }
        else if (m_strRspMsg.contains("$PROTECT")) {
            print("$PROTECT_ response = \(m_strRspMsg)")
            
            let (bVailid, strMsg) = DeviceProtectParser(m_strRspMsg)
            
            if (bVailid == true) {
                
                self.deviceControldelegate?.returnDeviceProtectNotify(self, strMessage: strMsg)
            }
            else {
                print("$PROTECT_ response Error!")
            }
        }
        else {
            print("Other response = \(strResponse), m_strRspMsg = \(m_strRspMsg)")
        }
        
        self.deviceControldelegate?.returnDeviceCommStop(self)
    }
    
    var bDataParser:Bool = false
    
    func ReceiveDataParser(_ checksum:UInt8) -> Void
    {
        if (bDataParser == true) {
            return
        }
        
        bDataParser = true
        
        let bufferSize = ADC1_SEND_TIME * ONE_DATA_SIZE

        let checksum_saved = checksum

        let ptrReceiveData = UnsafeMutablePointer<RawDataInfo>.allocate(capacity: bufferSize)
        memcpy(ptrReceiveData, m_ReceiveBuffer, bufferSize)
        
        //Save Buffer Signiture
        m_SaveBuffer[m_nSaveCnt] = 0x23   //"#"
        m_nSaveCnt += 1
        
        for rawIndex in 0 ..< ADC1_SEND_TIME {

            //let value = ptrReceiveData.memory
            let value = ptrReceiveData[rawIndex]

            //Save Buffer
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_Low >> 24) & (UInt32)(0xff))
            m_nSaveCnt += 1
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_Low >> 16) & (UInt32)(0xff))
            m_nSaveCnt += 1
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_Low >> 8) & (UInt32)(0xff))
            m_nSaveCnt += 1
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_Low >> 0) & (UInt32)(0xff))
            m_nSaveCnt += 1
            
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_High >> 24) & (UInt32)(0xff))
            m_nSaveCnt += 1
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_High >> 16) & (UInt32)(0xff))
            m_nSaveCnt += 1
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_High >> 8) & (UInt32)(0xff))
            m_nSaveCnt += 1
            m_SaveBuffer[m_nSaveCnt] = (UInt8)((value.dwScope_High >> 0) & (UInt32)(0xff))
            m_nSaveCnt += 1
            
            
            //print("memory = \(value)")
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
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_VOLTAGE_DELTA_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_VOLTAGE_DELTA_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_VOLTAGE_DELTA_STATE_SHIFT_VAL)
            let result_VoltageDeltaState = (Int)(result_data)
        
            //Voltage Data State Info
            result_data = value.dwScope_Low
            mask_data = (UInt32)(DATA_VOLTAGE_STATE_MASK)
            mask_data = mask_data << (UInt32)(DATA_VOLTAGE_STATE_SHIFT_VAL)
            result_data &= mask_data
            result_data = result_data >> (UInt32)(DATA_VOLTAGE_STATE_SHIFT_VAL)
            let result_VoltageState = (Int)(result_data)
            
            if (result_Vol1 == 0) {
                result_Vol1 = 0;
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

            //NSLog("result_vol1 = %.2f, result_Cur1 = %.2f", (Double)(result_Vol1)/100.0, (Double)(result_Cur1)/100.0)
            //NSLog("result_vol2 = %.2f, result_Cur2 = %.2f", (Double)(result_Vol2)/100.0, (Double)(result_Cur2)/100.0)

            scopeToGraphBuffer2[m_nScopeCnt] = result_Vol1 / 100.0
            scopeToGraphBuffer2[m_nScopeCnt+1] = result_Vol2 / 100.0
            
            //if (DeviceStatusInfo.scopeMode == .LEAKAGE) {
            if (scopeStatus.bLEAKAGE == true) {
            
                scopeToGraphBuffer1[m_nScopeCnt] = (result_Cur1 / 10000.0) * m_ScopeCurrentUnit
                scopeToGraphBuffer1[m_nScopeCnt+1] = (result_Cur2 / 10000.0) * m_ScopeCurrentUnit
            }
            else {
                
                scopeToGraphBuffer1[m_nScopeCnt] = (result_Cur1 / 100.0) * m_ScopeCurrentUnit
                scopeToGraphBuffer1[m_nScopeCnt+1] = (result_Cur2 / 100.0) * m_ScopeCurrentUnit
            }

            m_ScopeCurrentSum += scopeToGraphBuffer1[m_nScopeCnt]
            m_ScopeCurrentSum += scopeToGraphBuffer1[m_nScopeCnt+1]
            
            m_ScopeVoltageSum += scopeToGraphBuffer2[m_nScopeCnt]
            m_ScopeVoltageSum += scopeToGraphBuffer2[m_nScopeCnt+1]
        
            m_nScopeCnt += 2
            
            if (m_nScopeCnt == SCOPE_DATA_HALF_SIZE) {
                
                DeviceStatusInfo.scopeCurrent = m_ScopeCurrentSum / (Double)(m_nScopeCnt)
                DeviceStatusInfo.scopeVoltage = m_ScopeVoltageSum / (Double)(m_nScopeCnt)
                DeviceStatusInfo.scopeCount += (UInt64)(m_nScopeCnt)
                
                m_ScopeCurrentSum = 0.0
                m_ScopeVoltageSum = 0.0
                //m_nScopeCnt = 0
                
                self.deviceControldelegate?.returnScopeDataGraphProcess(self, location: 0, dVoltage: DeviceStatusInfo.scopeVoltage, dCurrent: DeviceStatusInfo.scopeCurrent, nCount: DeviceStatusInfo.scopeCount)
            }
            
            if (m_nScopeCnt >= SCOPE_DATA_FULL_SIZE) {
            
                DeviceStatusInfo.scopeCurrent = m_ScopeCurrentSum / (Double)(m_nScopeCnt - SCOPE_DATA_HALF_SIZE)
                DeviceStatusInfo.scopeVoltage = m_ScopeVoltageSum / (Double)(m_nScopeCnt - SCOPE_DATA_HALF_SIZE)
                DeviceStatusInfo.scopeCount += (UInt64)(m_nScopeCnt - SCOPE_DATA_HALF_SIZE)
                
                m_ScopeCurrentSum = 0.0
                m_ScopeVoltageSum = 0.0
                m_nScopeCnt = 0
                
                self.deviceControldelegate?.returnScopeDataGraphProcess(self, location: SCOPE_DATA_HALF_SIZE, dVoltage: DeviceStatusInfo.scopeVoltage, dCurrent: DeviceStatusInfo.scopeCurrent, nCount: DeviceStatusInfo.scopeCount)
            }
        }
        
        //Save Buffer Checksum
        m_SaveBuffer[m_nSaveCnt] = checksum_saved
        m_nSaveCnt += 1
        
        if (m_nSaveCnt >= SAVE_DATA_FULL_SIZE) {

            self.deviceControldelegate?.returnRawDataSaveProcess(self)
            m_nSaveCnt = 0
        }
        
        //bhjeon swift 4.0 update ptrReceiveData.deallocate(capacity: bufferSize)
        ptrReceiveData.deallocate()
        
        bDataParser = false
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

    let SS100_Firmware_Version = "1.3.7"
    let SS200_Firmware_Version = "1.0.5"
    let SS2000_Plus_Firmware_Version = "1.0.6"
    let SS2000_Firmware_Version = "1.0.6"       //SS2000+ Version과 동일
    
    func selectedDeviceInfo(_ index:Int) ->Void
    {
        DeviceStatusInfo.strDeviceName = m_DeviceInfoArray[index].strName
        DeviceStatusInfo.strDeviceIDN = m_DeviceInfoArray[index].strIDN
        DeviceStatusInfo.strDeviceVersion = m_DeviceInfoArray[index].strVersion
        
        switch(DeviceStatusInfo.strDeviceName)
        {
        case "SHM-SS100":
            DeviceStatusInfo.dBatVolMinLimit = 1.7
            DeviceStatusInfo.dBatVolMaxLimit = 4.55
            
            let bOldVersion = isFirmwareVersionOld(DeviceStatusInfo.strDeviceVersion, strLastVersion: SS100_Firmware_Version)
            DeviceStatusInfo.bOldFirmware = bOldVersion
            
        case "SHM-SS200":
            DeviceStatusInfo.dBatVolMinLimit = 0.5
            DeviceStatusInfo.dBatVolMaxLimit = 7.5
            
            let bOldVersion = isFirmwareVersionOld(DeviceStatusInfo.strDeviceVersion, strLastVersion: SS200_Firmware_Version)
            DeviceStatusInfo.bOldFirmware = bOldVersion
            
        case "SHM-SS2000":
            DeviceStatusInfo.dBatVolMinLimit = 0.5
            DeviceStatusInfo.dBatVolMaxLimit = 15.0
            
            let bOldVersion = isFirmwareVersionOld(DeviceStatusInfo.strDeviceVersion, strLastVersion: SS2000_Firmware_Version)
            DeviceStatusInfo.bOldFirmware = bOldVersion
            
        case "SHM-SS2000+":
            DeviceStatusInfo.dBatVolMinLimit = 0.5
            DeviceStatusInfo.dBatVolMaxLimit = 15.0
            
            let bOldVersion = isFirmwareVersionOld(DeviceStatusInfo.strDeviceVersion, strLastVersion: SS2000_Plus_Firmware_Version)
            DeviceStatusInfo.bOldFirmware = bOldVersion
            
        default:
            DeviceStatusInfo.dBatVolMinLimit = 1.7
            DeviceStatusInfo.dBatVolMaxLimit = 4.55
            
        }
        
        DeviceStatusInfo.online = true
    }
    
    func isFirmwareVersionOld(_ strDeviceVersion:String, strLastVersion:String) -> Bool
    {
        var bOldVersion = false
        
        let device_version = strDeviceVersion.replacingOccurrences(of: ".", with: "")
        let last_version = strLastVersion.replacingOccurrences(of: ".", with: "")
        
        let device_version_value = atoi(device_version)
        let last_version_value = atoi(last_version)
        
        if (device_version_value < last_version_value) {
            bOldVersion = true
        }
        
        logController.saveLogData("isFirmwareVersionOld() device: \(device_version_value), last: \(last_version_value)")
        
        return bOldVersion
        
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        
        logController.saveLogData("SerialPort \(serialPort) encountered an error: \(error)")
        DeviceStatusInfo.online = false
        
        self.deviceControldelegate?.returnDeviceErrorEvent(self)
    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        
        self.serialPort = nil
        
        m_DeviceInfoArray = [DeviceInfo]()
 
        DeviceStatusInfo = DeviceStatus(online: false, bOldFirmware: false, strDeviceName: "", strDeviceIDN: "", strDeviceVersion: "", dBatVolMinLimit: 1.7, dBatVolMaxLimit: 4.55,scopeMode:.none_MODE, dataMode: .adc_AVG, scaleMode: .coarse, batPwrOn:false, usbPwrOn:false, uartOn:false, jigOn:false, chargerOn:false, limitOn:false, ifType:.not_CON, batVolt:4.00, batOCP:4.5, usbOCP:3.2, batONP:1500, usbONP:1000, batONT:100, usbONT:100, batOVP:1000, usbOVP:1000, batDVP:1000, usbDVP:1000, scopeVoltage:0.0, scopeCurrent:0.0, scopeCount:0)
        
        logController.saveLogData("serialPortWasRemovedFromSystem")
    }
}
