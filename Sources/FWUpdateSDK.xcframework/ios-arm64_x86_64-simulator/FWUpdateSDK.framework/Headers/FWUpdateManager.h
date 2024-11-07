//
//  UpdateManager.h
//  FWUpdateSDK
//
//  Created by SPS on 2020/10/07.
//

#import <Foundation/Foundation.h>
#import "BootloaderInfo.h"

typedef NS_ENUM(NSInteger, UpdateType){
    UpdateTypeUnknown = 0,
    UpdateTypeAsReader,
    UpdateTypeRFID,
    UpdateTypeIR
};

typedef NS_ENUM(NSInteger, UpdateContinue){
    UpdateContinueNone = 0,
    UpdateContinueCheck,
    UpdateContinueEnterBootlader,
    UpdateContinueCheckBootladerString,
    UpdateContinueCheckBootladerPacket,
    UpdateContinueStartUpdate,
    UpdateContinueStart,
    updateContinueUpdate
};

@interface FWUpdateManager : NSObject

@property(nonatomic, assign)id delegate;
@property(nonatomic, assign, readonly)enum UpdateContinue updateContinueStatus;
+ (instancetype)sharedInstance;
/**
 *  start update
 * @param  hexfile : hex file name
 * @param  updateType : (UpdateType)updateType ASReader,IR,RFID
*/
- (void)startUpdateWithHex:(NSString *)hexfile updateType:(UpdateType)updateType;
/**
 * get available Hex File List
 * @returns [String hexFileName]
*/
- (NSMutableArray *)getLocalHexListForDevice;
- (void)continueUpdate;
- (void)restartUpdate;
- (void)checkBootloaderVersionType:(UpdateType)updateType;
- (void)closeBootloaderModeWithHEXFile:(NSString *)fileName;
- (void)setPowerOnOff:(BOOL)isOn updateType:(UpdateType)updateType;

@end

@protocol FWUpdateManagerDelegate <NSObject>
- (void)FWUpdateManager:(FWUpdateManager *)manager updateProcessingStep:(float)progressStep currentStep:(NSInteger)currentStep endStep:(NSInteger)endStep;
- (void)FWUpdateManager:(FWUpdateManager *)manager bootloaderInfo:(BootloaderInfo *)info;
- (void)FWUpdateManager:(FWUpdateManager *)manager moduleVersion:(NSString *)version;
- (void)FWUpdateManager:(FWUpdateManager *)manager updateFinish:(NSError *)error;
- (void)FWUpdateManager:(FWUpdateManager *)manager occuredError:(NSError *)error;
- (void)FWUpdateManager:(FWUpdateManager *)manager rebootRequest:(NSError *)error;
- (void)FWUpdateManagerSuspendUpdate:(FWUpdateManager *)manager;

@end
