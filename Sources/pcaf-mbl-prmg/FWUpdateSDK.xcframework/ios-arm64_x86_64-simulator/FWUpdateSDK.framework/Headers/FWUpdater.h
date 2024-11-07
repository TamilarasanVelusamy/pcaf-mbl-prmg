//
//  FWUpdater.h
//  FWUpdateSDK
//
//  Created by Y.Oshiro on 2020/10/22.
//

#import <Foundation/Foundation.h>
#import <FWUpdateSDK/FWUpdateManager.h>
#import <FWUpdateSDK/DeviceManager.h>
#import <FWUpdateSDK/FWFileManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWUpdater : NSObject

@property(nonatomic, weak, readonly)DeviceManager *deviceManager;
@property(nonatomic, weak, readonly)FWUpdateManager *updateManager;
@property(nonatomic, weak, readonly)FWFileManager *fileManager;
@property(nonatomic, weak, readonly)NSString *SDKVersion;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
