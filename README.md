# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)


# Integrating pcaf-mbl-prmg Framework and Dependencies


# Supported Devices and Firmware Frameworks.
######
    Brother Printer : BRLMPrinterKit.xcframework
    Unitech Scanner : FWUpdateSDK.xcframework
    HoneyWell Dex : frameworkDEXUpgradeSDK.xcframework
    

# 1.Add Peripheral Device Management (pcaf-mbl-prmg) Package  :
######
    Go to your project target settings.
    Navigate to the "Swift Packages" tab.
    Click the "+" button and choose "Add Package Dependency."
    Paste the URL https://PepsiCoIT@dev.azure.com/PepsiCoIT/Commercial_IT/_git/pcaf-mbl-prmg in the search bar and click "Add Package."

    
# 2. Airship Package Dependency:
######
    Go to your project target settings.
    Navigate to the "Swift Packages" tab.
    Click the "+" button and choose "Add Package Dependency."
    Paste the URL https://github.com/urbanairship/ios-library.git in the search bar and click "Add Package."

    
# 3. Register for Package Logs and Airship Notifications

# a) Add The below highlighted Changes in AppDelegate.swift

    Add the lines of code in AppDelegate.swift inside function didFinishLaunchingWithOptions

 Copy Code Contents for AppDelegate
######     
import pcaf_mbl_prmg
import AirshipCore

class AppDelegate: NSObject, RegistrationDelegate, UIApplicationDelegate {
 
 
     private(set) var pmComposer: PMComposer!
    private(set) var pmPackageLogger: PMPackageLoggerProtocol!
    var window: UIWindow?
    let pushHandler = PushHandler()
    static private(set) var instance: AppDelegate! = nil
    

 
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
    
            AppDelegate.instance = self
            
                    func makePMPackageLogger() -> PMPackageLoggerProtocol {
            PMPackageLogger(logComposer: logComposer, fileName: LogFileNames.pmLogFileName.rawValue)
        }
        self.pmPackageLogger = makePMPackageLogger()
        
        func makePMComposer() -> PMComposer {
            PMComposer(logLevel: .verbose, logFileMessages: pmPackageLogger.logAuthFileMessages)
        }
        self.pmComposer = makePMComposer()
        // Airship - Call Configure Airship function from AppDelegate extention class
        configureAirship(launchOptions: launchOptions)
    }
}

// pcaf_mbl_prmg Extension
######
extension AppDelegate {
    
    /**
     * This methods called when Airship configuration failed
     * called from within your application delegate's `configureAirship(launchOptions:` method
     * to show invalid config alert
     */

    func configureAirship(launchOptions: [UIApplication.LaunchOptionsKey : Any]?){
        /// Creates an instance using the values set in the `AirshipConfig.plist` file.
        let config = AirshipConfig.default()
        
        config.developmentAppKey = SPEnvironment.airshipDevAppKey
        config.developmentAppSecret = SPEnvironment.airshipDevAppSecretKey
        config.productionAppKey = SPEnvironment.airshipProdAppKey
        config.productionAppSecret = SPEnvironment.airshipProdAppSecretKey
        
        if (config.validate() != true) {
            self.showInvalidConfigAlert()
            return
        }
        
//        config.enabledFeatures = .all
//        config.productionLogLevel = .verbose
//        config.developmentLogLevel = .verbose
        /// Log detailed tracing messages.
        Airship.logLevel = .debug
        /// Setting the Airship default message center style configuration file
        config.messageCenterStyleConfig = "UAMessageCenterDefaultStyle"
//         Log.info(("Airship Config:\n \(config)", app: .salesplusfl)

        /// Initalizes Airship with the use of take off function.
        Airship.takeOff(config, launchOptions: launchOptions)
//        Airship.privacyManager.enabledFeatures = .all
        /// setting Airship notification style and registring for delegate
        Airship.push.pushNotificationDelegate = pushHandler
        Airship.push.registrationDelegate = self
        Airship.push.defaultPresentationOptions = [.banner, .badge, .sound]
        Airship.push.userPushNotificationsEnabled = true
    }
    
    func showInvalidConfigAlert() {
        let alertController = UIAlertController.init(title: PMAErrorMessage.invalidConfigration, message: PMAErrorMessage.airShipConfigMsg, preferredStyle:.actionSheet)
        alertController.addAction(UIAlertAction.init(title: PMAErrorMessage.okayTitle, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        }))

        DispatchQueue.main.async {
            alertController.popoverPresentationController?.sourceView = self.window?.rootViewController?.view

            self.window?.rootViewController?.present(alertController, animated:true, completion: nil)
        }
    }
    /// Airship Push Notification Handle Events For Background URLSession:
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
         Log.info(("Airship Push Notification Handle Events For Background URLSession: \(identifier)"), app: .salesproplus)
    }
    
}
######
## PMAErrorMessage
struct PMAErrorMessage {
    static let invalidConfigration = "Invalid AirshipConfig.plist"
    static let airShipConfigMsg = "The AirshipConfig.plist must be a part of the app bundle and include a valid appkey and secret for the selected production level."
    static let okayTitle = "Okay"

}
    
            
# b) Create a New Swift File: PushHandler.

        In Xcode, navigate to File > New > File....
    Select Swift File from the iOS section, then click Next.
    Choose a suitable location for the file  and name it PushHandler.

 Copy Code Contents for PushHandler
    Copy the code contents for PushHandler as Below
    
 ## PushHandler.swift Start
######

import Foundation
import AirshipCore

class PushHandler: NSObject, PushNotificationDelegate {
 
    ///  Application received a background notification
    func receivedBackgroundNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
      
         Log.info(("The application received a background notification"), app: .salesplusfl)
    // FW Update  - Call Firmware Update API Service Call in  pcaf_mbl_prmg
        AppDelegate.instance.pmComposer.launchFirmwareUpdates()
    }
    
    /// Application received a foreground notification
    func receivedForegroundNotification(_ userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
         Log.info(("The application received a foreground notification"), app: .salesplusfl)
    // FW Update  - Call Firmware Update API Service Call in  pcaf_mbl_prmg
        AppDelegate.instance.pmComposer.launchFirmwareUpdates()
    }
    
    /// Application received  notification
    func receivedNotificationResponse(_ notificationResponse: UNNotificationResponse, completionHandler: @escaping () -> Swift.Void) {
        completionHandler()
    }
    
    func extend(_ options: UNNotificationPresentationOptions = [], notification: UNNotification) -> UNNotificationPresentationOptions {
    #if !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            return options.union([.banner, .list, .sound])
        } else {
            return options.union([.alert, .sound])
        }
    #else
        return options.union([.alert, .sound])
    #endif
    }
}



## PushHandler.swift End


# c) Create a New Swift File: PMPackageLogger.

        In Xcode, navigate to File > New > File....
    Select Swift File from the iOS section, then click Next.
    Choose a suitable location for the file  and name it PushHandler.

     Copy Code Contents for PMPackageLogger
    Copy the code contents for PMPackageLogger as Below
    

 ## PMPackageLogger.swift Start
######

import Foundation
import pcaf_mbl_fwrk_alog
import pcaf_mbl_auth
import pcaf_mbl_prmg

typealias PMLogMetadata = pcaf_mbl_auth.LogMetadata

protocol PMPackageLoggerProtocol {
    func logAuthFileMessages(logType: PMLogLevel,
                             message: String)
    var fileLogger: LoggerProtocol? {get set}
}

class PMPackageLogger: PMPackageLoggerProtocol {
    
    internal var fileLogger: LoggerProtocol?
    let logComposer: LogComposerFactory
    let fileName: String

    init(logComposer: LogComposerFactory,
         fileName: String) {
        self.logComposer = logComposer
        self.fileName = fileName
        createAuthLogInstance()
    }
}

extension PMPackageLogger {
    // Log to file
    func logAuthFileMessages(logType: PMLogLevel,
                             message: String) {
        log(logType, message: message)
    }
}

// MARK: Create file destination
extension PMPackageLogger {
    private func createAuthLogInstance() {
        let loggerObj = logComposer.makeLogger(with: [SPConstant.authPrefix: [fileName]])
        fileLogger = loggerObj
    }
}

extension PMPackageLogger {
    func log(_ level: PMLogLevel, message: String) {
        let metaData = pcaf_mbl_fwrk_alog.LogMetadata(file: metaData.file, function: metaData.function,
                                                      line: metaData.line)
        switch level {
        case .verbose:
            fileLogger?.logVerbose(message: message, logFileName: fileName, context: nil, metadata:metaData)
        case .warning:
            fileLogger?.logWarning(message: message, logFileName: fileName, context: nil, metadata:metaData)
        case .error:
            fileLogger?.logCustom(level: .error, message: message, logFileName: fileName, context: nil, metadata:metaData)
        }
    }
}
## PMPackageLogger.swift End


# 4. Verify Info.plist Configuration:

  ##  Open your project's Info.plist file.
    Add the following key-value pairs under the Privacy dictionary:
    Privacy - Bluetooth Always Usage Description: "This app needs Bluetooth to communicate with printers, scanners, and other devices." (Replace with your specific description)
    Privacy - Bluetooth Peripheral Usage Description: "This app uses Bluetooth to connect to printers, scanners, and other devices." (Replace with your specific description)
## Under the Supported external accessory protocols key, add the protocols supported by your printers, scanners, and dex modules. (Refer to their documentation for specific protocol names)

    
## Info.Plist
######
<dict>
    <key>UISupportedExternalAccessoryProtocols</key>
    <array>
        <string>jp.co.asx.asreader.6dongle.ask</string>
        <string>jp.co.asx.asreader.gun</string>
        <string>kr.co.sps.sreader.universal.sr120</string>
        <string>com.brother.ptcbp</string>
        <string>jp.co.asx.asreader.6dongle.barcode</string>
        <string>jp.co.asx.asreader</string>
        <string>jp.co.asx.asreader.barcode</string>
        <string>jp.co.asx.asreader.0230D</string>
        <string>jp.co.asx.asreader.0240D</string>
        <string>jp.co.asx.asreader.nfc</string>
        <string>jp.co.asx.asreader.6dongle.rfid</string>
        <string>jp.co.asx.asreader.rfid</string>
    </array>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Please tap &quot;OK&quot; to help detect Display Equipment.</string>
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>Please allow Bluetooth peripherals to be used</string>
</dict>

######  
 
# 5. Device Management Enable Background Modes :
######
    Go to Project Target and check/enable the below options in Background Modes
    
    1.External accessory Communication
    2.Uses Bluetooth LE accessory
    3.Background Fetch
    4.Background Processing
    5.Remote Notification
    
# 6. Launch Device Management View Function :
   ### Function returns Device Management SwiftUI View. Can be used directly in Body of SwiftUI View
    
    AppDelegate.instance.pmComposer.launchDeviceManagement() 
    

    
# 7.  Airship Keys Configration based on Environment
######
## Add the keys in info.Plist and fetch from Config files based on environment 
        AIRSHIP_DEV_APPKEY = $(AIRSHIP_DEV_APPKEY)
        AIRSHIP_DEV_APPSECRETKEY = $(AIRSHIP_DEV_APPSECRETKEY)
        AIRSHIP_PROD_APPKEY = $(AIRSHIP_PROD_APPKEY)
        AIRSHIP_PROD_APPSECRETKEY = $(AIRSHIP_PROD_APPSECRETKEY)
######
## These keys are used to set up Airship in Appdelegate.
        config.developmentAppKey = SPEnvironment.airshipDevAppKey
        config.developmentAppSecret = SPEnvironment.airshipDevAppSecretKey
        config.productionAppKey = SPEnvironment.airshipProdAppKey
        config.productionAppSecret = SPEnvironment.airshipProdAppSecretKey
######     
## In Configs File (Prod/QA/Debug) :
        //Airship Keys
        AIRSHIP_DEV_APPSECRETKEY = RezdZQ4PSgyrAMjKF6HKjg
        AIRSHIP_DEV_APPKEY = uOUAFL2RTKuFlpxY7WB2Ew
        AIRSHIP_PROD_APPSECRETKEY = jrq4VEiMTtydxpx6axNDoA
        AIRSHIP_PROD_APPKEY = lfCxgSIeQTCxT6o7cAfK6Q
######
## Fetch Keys from Config Files based on Environment
    public enum SPEnvironment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            return [:]
        }
        return dict
    }()
       static let airshipDevAppKey: String? = {
        guard let appKey = infoDictionary["AIRSHIP_DEV_APPKEY"] as? String else {
            return nil
        }
        return appKey
    }()
    static let airshipDevAppSecretKey: String? = {
        guard let appSecretKey = infoDictionary["AIRSHIP_DEV_APPSECRETKEY"] as? String else {
            return nil
        }
        return appSecretKey
    }()
    static let airshipProdAppKey: String? = {
        guard let appKey = infoDictionary["AIRSHIP_PROD_APPKEY"] as? String else {
            return nil
        }
        return appKey
    }()
    static let airshipProdAppSecretKey: String? = {
        guard let appSecretKey = infoDictionary["AIRSHIP_PROD_APPSECRETKEY"] as? String else {
            return nil
        }
        return appSecretKey
    }()
    }
    
    Airship Notifications call back has been handled in PushHandler with function AppDelegate.instance.pmComposer.launchFirmwareUpdates()
    Function initiates the API to download Firmware updates if available.

        

# 8. Key Constants to be added :
 
### LogFileNames
######
enum LogFileNames: String, CaseIterable {
    case pmLogFileName = "FL_PMLog"
}
######

