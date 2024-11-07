//
//  BootloaderInfo.h
//  FWUpdateSDK
//
//  Created by Yasutaka Oshiro on 2022/10/03.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BootloaderInfo : NSObject

typedef NS_ENUM(NSInteger, BootloaderType){
    BootloaderTypeUnknown = 0,
    BootloaderTypeP0,
    BootloaderTypeP1,
    BootloaderTypeS0,
    BootloaderTypeS1,
    BootloaderTypeS2,
    BootloaderTypeS3,
    BootloaderTypeS4,
    BootloaderTypeS5,
    BootloaderTypeIR,
};

@property(nonatomic, assign, readonly)BootloaderType type;
@property(nonatomic, weak, readonly)NSString *versionText;
@property(nonatomic, weak, readonly)NSString *versionNameText;

- (void)setBootloaderType:(BootloaderType)type;
- (void)setVersionText:(NSString *)versionText;
- (void)setVersionNameText:(NSString *)versionNameText;
@end

NS_ASSUME_NONNULL_END
