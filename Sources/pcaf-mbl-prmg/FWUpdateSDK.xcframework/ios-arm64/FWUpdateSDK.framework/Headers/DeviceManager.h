//
//  DeviceManager.h
//  FWUpdateSDK
//
//  Created by Y.Oshiro on 2020/10/19.
//

#import <FWUpdateSDK/AsReaderDevieceInfoDefine.h>

typedef NS_ENUM(NSInteger, ReaderCompleted){
    ReaderCompleted_PowerOFF = 0,
    ReaderCompleted_PowerON,
    ReaderCompleted_ChangeModeON,
    ReaderCompleted_ChangeModeOFF,
};

@interface DeviceManager : NSObject

@property(nonatomic, assign)id delegate;
@property(nonatomic, assign, readonly)BOOL isConnected;

// DeviceInfo
@property(nonatomic, assign, readonly)NSString *modelNumber;
@property(nonatomic, assign, readonly)NSString *firmwareVersion;
@property(nonatomic, assign, readonly)NSString *manufacturer;
@property(nonatomic, assign, readonly)NSString *serialNumber;
@property(nonatomic, assign, readonly)NSString *hardwareVersion;
@property(nonatomic, assign, readonly)NSString *sessionID;
@property(nonatomic, assign, readonly)NSString *accessoryProtocol;


+ (instancetype)sharedInstance;

- (void)changeModuleTypeMode:(AsReaderModuleType)moduleType;

- (void)setPower:(BOOL)power;
- (void)setPower:(BOOL)power moduleType:(AsReaderModuleType)moduleType;
- (void)presetDeviceSettings:(BOOL)beep vibration:(BOOL)vibration illumination:(BOOL)illumination LED:(BOOL)LED;
- (BOOL)isOpen;
- (BOOL)isConnected;
- (void)disconnect;
- (void)connect;
@end

//---------------------------------------
#pragma mark - DeviceManagerDelegate
//---------------------------------------
@protocol DeviceManagerDelegate <NSObject>
@required
/**
 *  @brief      Notification about "Power Reset" from module.
 *  @details    It is a function that is called when change the reader's connect information
 *  @param      completedStatus : Connected (OxFF), Disconnected(0x00)
 */
- (void)DeviceManager:(DeviceManager *)manager completedReaderPower:(ReaderCompleted)completedStatus;

/**
 *  @brief      Response of plug state change
 *  @details    It is a function that is called when the plug state of reader and iPhone change
 *  @param      pluggedStatus : plugged (YES), unplugged (NO)
 */
- (void)DeviceManager:(DeviceManager *)manager changedPluggedStatus:(BOOL)pluggedStatus;

@optional
/**
 *  @brief      Response of trigger button on reader (Default)
 *  @details    This function is called when the trigger button of the reader is pressed or released.
 *  @param      strStatus : When device type is RFID, "RFID startScan"\n When device type is Barcode, "Barcode startScan"\n When device type is NFC, "NFC startScan"\n
 */
- (void)DeviceManager:(DeviceManager *)manager checkTriggerStatus:(NSString*)strStatus;

/**
 *  @brief   Response of invalid command
 *  @details
 *  @param manager : DeviceManager instance.
 *  @param error : payload(error code, command code, sub error code)
 */
- (void)DeviceManager:(DeviceManager *)manager receivedOccurredError:(NSError *)error;

/**
 *  @brief This function is called when receive a battery level of reader
 *  @param manager : DeviceManager instance.
 *  @param battery : Battery level
 */
- (void)DeviceManager:(DeviceManager *)manager receivedBattery:(NSInteger)battery;

/**
 *  @brief Response of  "Barcode Factory Reset"
 *  @details It is a function that is called when the reader sends a response code to "Barcode Factory Reset" in Barcode type
 *  @param manager : DeviceManager instance.
 *  @param status : reset start(0x00), reset complete(0xFF)
 */
- (void)DeviceManager:(DeviceManager *)manager receivedFactoryResetStatus:(uint8_t)status;

/**
 *  @brief ACK data according to user command
 *  @param manager : DeviceManager instance.
 *  @param rawData : Data
 */
- (void)DeviceManager:(DeviceManager *)manager ackUserCommandReceived:(NSData *)rawData;

/**
 *  @brief      [Customer Mode] Response of trigger button on reader
 *  @details    This function is called when the trigger button of the reader is pressed.
 *  @param manager : DeviceManager instance.
 *  @param buttonAction : 
 */
- (void)DeviceManager:(DeviceManager *)manager triggerButtonAction:(TriggerButton)buttonAction;

@end
