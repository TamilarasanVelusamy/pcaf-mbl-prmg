//
//  Constants.swift
//  DeviceManagerApp
//
//  Created by ketan on 30/09/22.
//

import Foundation
import SwiftUI

struct PMAConstants {
    static let peripheralDisconnectedDevices = "fwDisconnectedDevices"
    static let peripheralFileDataModel = "firmwareFileDataModel"
}

extension PMAConstants {
    struct ScreenSize {
        static let height = UIScreen.main.bounds.size.height
        static let width = UIScreen.main.bounds.size.width
    }
}

extension PMAConstants {
    struct Titles {
        static let addNewPrinter = "Add a new Printer"
        static let backgroundProcess = "Background progress :"
        static let battery = "Battery :"
        static let brother = "Brother"
        static let brotherUnpairMsg = "To unpair Brother open the Bluetooth settings"
        static let cancel = "Cancel"
        static let charging = "Charging"
        static let connected = "Connected"
        static let currentFirmware = "Current firmware:"
        static let devicePin = "Device PIN"
        static let deviceStatistics = "Device Statistics"
        static let dex = "Dex"
        static let dexCapital = "DEX"
        static let dexFlashMode = "Prepare to Install"
        static let dexInFlashMode = "In Flash Mode" 
        static let dexPairedSuccessfully = "DEX adapter paired successfully"
        static let dexUnpairMsg = "To unpair DEX open the Bluetooth settings"
        static let disconnected = "Disconnected"
        static let downloadMessage = "Firmware download process is going on in background, please some time!!!"
        static let downloadedFileUrl = "Downloaded file's url is"
        static let downgradeFirmware = "Downgrade Firmware"
        static let downloadingFirmware = "Downloading firmware"
        static let downgradingFirmware = "Downgrading Firmware"
        static let downgradeSuccessfully = "Firmware downgrade successfully."
        static let downloadUpdate = "Download update"
        static let firmwareStarting = "Starting please wait"
        static let firmwareUptoDate = "Firmware is up to date"
        static let flashMode = "Setting flash mode successfully."
        static let fullCharged = "Full charged"
        static let fwisreadyToInstall = "is ready to install"
        static let fwFileData = "Firmware file data -"
        static let fwFileDownloded = "Firmware file downloaded"
        static let hardwareVersion = "Hardware Version :"
        static let honeywell = "Honeywell"
        static let infoFwInstallation = "Connect device to start firmware installation"
        static let installationInformation = "Installation Information"
        static let install = "Install"
        static let installing = "is installing"
        static let installingOnDevice = "Installing on device"
        static let installOnDevice = "Install on device"        
        static let isAvailble = "is available"
        static let loading = "Loading..."
        static let myPrinters = "MY PRINTERS"
        static let no = "NO"
        static let notPaired = "Not Paired"
        static let onBatteryPower = "On battery power"
        static let onePercent = "%.1f"
        static let okay = "Okay"
        static let pair = "Pair"
        static let pairBrother = "Pair Brother"
        static let pairingInfo = "Pairing requries Scanning NFC on DEX"
        static let percent = "%"
        static let peripheralManagement = "Device Management"
        static let pinCopied = "Pin Copied"
        static let plugged = "Plugged"
        static let printerTurnedOn = "Please ensure that the Printer is turned On"
        static let printerDetails = "Printer Details"
        static let printers = "Printers"
        static let readyToDowngrde = "Ready for Downgrade"
        static let readyToUpdate = "Ready for Upgrade"
        static let save = "Save"
        static let saveUpdates = "Save Updates"
        static let scan = "Scan"
        static let scanner = "Scanner"
        static let scannerEnsurePlugged = "Please ensure that the scanner is plugged in"
        static let selectAccessory = "Select An Accessory"
        static let serialNumber = "Serial number:"
        static let sortSerialNumber = "S/N:"
        static let settings = "Settings"
        static let submit = "Submit"
        static let twoDScanner = "2D Pocket Scanner"
        static let unitech = "Unitech"
        static let unPlugged = "UnPlugged"
        static let updateFirmware = "Updated Firmware"
        static let updateFirmwareTo = "Updated Firmware to"
        static let updateSuccessfully = "Firmware updated successfully."
        static let unableSaveFirmwareFile = "Unable to save firmware file details"
        static let unpairBrother = "Unpair Brother"
        static let unpair = "Unpair"
        static let unpairDex = "Unpair DEX"
        static let unzipFileIUrl = "Unzip file url is"
        static let warning = "Warning"
        static let yes = "YES"
        static let zeroPercent = "%.0f"
        static let zip = "zip"
    }
}

extension PMAConstants {
    struct Messages {
        
        static let airShipConfigMsg = "The AirshipConfig.plist must be a part of the app bundle and include a valid appkey and secret for the selected production level."
        
        static let DexSuccessfullyMessage = """
                                                1. Go to settings
                                                2. Go to  bluetooth tab then forget the DEX Adapter device
                                                3. Connect to the DEX Adapter again
                                                """
        
        static let DexUpgradeSuccessfullyMessage = """
                                                1. Please scan the device and pair again then
                                                1. Go to settings
                                                2. Go to  bluetooth tab then forget the DEX Adapter device
                                                3. Connect to the DEX Adapter again
                                                4. OFF the honeywell device and ON again.
                                                """
        
        static let dexWarningAlert            = """
                                                Please read the instructions carefully.
                                                1. Go to settings
                                                2. Go to  bluetooth tab then forget the DEX Adapter device
                                                3. Connect to the DEX Adapter again
                                                
                                                """
        
        static let dexFlashModeInfomationMessage = """
                                    1. You have placed DEX in install mode.
                                    
                                    2. Please read carefully below steps:
                                        2.1 Go to Settings
                                        2.2 Go to Bluetooth and forget the DEX Adapter device
                                        2.3 then scan and pair the DEX Adapter again
                                    
                                    3. Updating firmware may take some time, do not stop this program until it has completed
                                    
                                    4. Please make sure:
                                        4.1 Your iPad/iPhone is fully charged and connected to adapter
                                        4.2 Avoid using or moving your devices while installation
                                    
                                    """
        
        static let DexWarningMessage = """
                            Avoid using or moving your devices as interruption in firmware installation can cause damage to your device
                            
                            Firmware installation may take few minutes to complete. Make sure your iPad/iPhone is fully charged and connected to Honeywell DEX Adapter
                            
                            Note:- If you don't wish to perform firmware upgrade
                                   Please follow the instructions.
                                   1. Go to settings
                                   2. Go to  bluetooth tab then forget the DEX Adapter device
                                   3. OFF the Honeywell device and ON again.
                            """
        static let installInfoMessagePrinter = """
                                    1. You are about to install the firmware to your Brother RJ-42308 Label Printer  
                                    2. Updating firmware may take some time, do not stop this program until it has completed. 
                                    3. Interrupting this firmware installation can result in following outcomes: 3.1 May cause damage to your printer 3.2 May affect the device performance 3.3 May cause some technical issues. 
                                    4. Please make sure: 4.1 Your iPad/iPhone is fully charged and connected to Printer 4.2 Avoid using or moving your devices while installation
                                    """
        static let installInfoMessageScanner = """
                                    1. You are about to install the firmware to your 2D Pocket Scanner
                                    
                                    2. Updating firmware may take some time, do not stop this program until it has completed
                                    
                                    3. Interrupting this firmware installation can result in following outcomes:
                                        3.1 May cause damage to your scanner
                                        3.2 May affect the device performance
                                        3.3 May cause some technical issues
                                    
                                    4. Please make sure:
                                        4.1 Your iPad/iPhone is fully charged and connected to Scanner
                                        4.2 Avoid using or moving your devices while installation
                                    """
        static let warning = "Warning: Avoid using or moving your devices as intrruption in firmware installation can cause damage to your device. "
 
        static let warningMessageDex = """
                            Avoid using or moving your devices as interruption in firmware installation can cause damage to your device
                            
                            Firmware installation may take few minutes to complete. Make sure your iPad/iPhone is fully charged and connected to Honeywell DEX Adapter
                            """
        
        static let warningMessageDexBattery = """
                            The dex battery level is below the recommended percentage. Please charge prior to performing firmware upgrade.
                            """
        
        static let warningMessageBatteryiOS = """
                            The iOS device battery level is below the recommended percentage. Please charge prior to performing firmware upgrade.
                            """
        
        static let warningMessageFirmwareFile = """
                             The downloaded firmware file is not compatible with current hardware or file is corrupted.
                             """
        
        static let warningMessagePrinter = """
                            Avoid using or moving your devices as interruption in firmware installation can cause damage to your device
                            
                            Firmware installation may take few minutes to complete. Make sure your iPad/iPhone is fully charged and connected to Brother RJ-42308 Label Printer
                            """
        
        static let warningMessagePrinterBattery = """
                            The printer battery level is below the recommended percentage. Please charge prior to performing firmware upgrade.
                            """
        
        static let warningMessageScanner = """
                            Avoid using or moving your devices as interruption in firmware installation can cause damage to your device
                            
                            Firmware installation may take few minutes to complete. Make sure your iPad/iPhone is fully charged and connected to 2D Pocket Scanner
                            """
        
        static let warningMessageScannerBattery = """
                            The scanner battery level is below the recommended percentage. Please charge prior to performing firmware upgrade.
                            """
    }
    
    struct ErrorMessage {
        static let error = "Error is"
        static let flashModeError = "Setting flash mode failed!!!"
        static let invalidConfigration = "Invalid AirshipConfig.plist"
        static let invalidFile = "Invalid firmware file."
        static let notAvailable = "N/A"
        static let plistNotFound = "Plist file not found"
        static let rootURLNotSet = "Root URL not set in plist for this environment"
        static let unknown = "Unknown"
        static let updateFailed = "Firmware update failed. Please try again."
        
    }
}

extension PMAConstants {
    struct ImageName {
        static let backIcon:String = "chevron.left"
        static let checkmarkCircle = "checkmark.circle.fill"
        static let chevronForword = "chevron.forward"
        static let circle = "circle.fill"
        static let cloudArrow = "icloud.and.arrow.down"
        static let copyIcon = "copy"
        static let dex = "Dex"
        static let exclamationmarkCircle = "exclamationmark.circle"
        static let homeNavigationBg: String = "home_navigation_back_bg"
        static let homeNavigationBgIPad: String = "home_navigation_back_bg_iPad"
        static let infoCircle = "info.circle.fill"
        static let printer = "BrotherRJ42308"
        static let syncIcon: String = "arrow.triangle.2.circlepath"
        static let uteScanner = "UTEScanner"
        static let warning = "Warning: "
        static let xCircle = "multiply.circle.fill"
    }
}

extension PMAConstants {
    struct BackTitles {
        static let back = "Back"
    }
}

extension PMAConstants{
    enum Constants {
        static let dexInstall = "dexInstall"
        static let filePath = "FilePath"
        static let printerInstall = "printerInstall"
        static let printerModel = "printerModel"
        static let scannerInstall = "scannerInstall"
    }
}

extension PMAConstants{
    struct Button{
        static let borderWidth = 1
        static let cornerRadius = 10
    }
}

extension PMAConstants.Constants {
    enum FetchSize: Int {
        case tenThousand = 10000
        case hundred = 100
        case oneThousand = 1000
        case sixty = 60
        case fifty = 50
        case forty = 40
    }
}

extension PMAConstants.Constants {
    public enum Padding: CGFloat {
        case zero = 0
        case small = 5
        case standard = 10
        case medium = 15
        case large = 20
    }
}

extension PMAConstants.Constants {
    enum Radius: CGFloat {
        case five = 5
        case twelve = 12
    }
    
}

extension PMAConstants.Constants {
    enum Size: CGFloat {
        case one = 1
        case two = 2
        case eight = 8
        case forty = 40
        case fortyOne = 41
        case fortyFour = 44
        case oneHundredFifty = 150
        case threeHundredTwentyFive = 325
    }
}

extension PMAConstants {
    struct ApiEndPoint{
        static let getPeripheralData = "PeripheralManagement_Firmware.json"
        static let baseUrl = "https://shngprodfirmware.blob.core.windows.net/firmware-files/"
//        static let getPeripheralData = "PeripheralManagement_Firmware_Rollback.json"

    }
}

extension PMAConstants {
    struct UserDefaultskey{
        static let successFirmwareAlert = "SuccessFirmwareAlert"
        static let oldFirmwareVersion = "OldFirmwareVersion"
        static let accessToken = "accessToken"
    }
}


import Foundation
import OSLog

struct OKTAConfigurations {

    static func configs() -> [String: String] {
        guard let dict = Bundle.main.infoDictionary else {
            os_log("Unable to configure plist")
            return [:]
        }
        var oktaConfigs: [String: String] = [:]
        oktaConfigs["scopes"] = dict["OKTA_SCOPES"] as? String
        oktaConfigs["redirectUri"] = dict["OKTA_REDIRECT_URI"] as? String
        oktaConfigs["clientId"] = dict["OKTA_CLIENT_ID"] as? String
        oktaConfigs["issuer"] = dict["OKTA_ISSUER"] as? String
        oktaConfigs["logoutRedirectUri"] = dict["OKTA_LOGOUT_REDIRECT_URI"] as? String
        return oktaConfigs
    }
}
