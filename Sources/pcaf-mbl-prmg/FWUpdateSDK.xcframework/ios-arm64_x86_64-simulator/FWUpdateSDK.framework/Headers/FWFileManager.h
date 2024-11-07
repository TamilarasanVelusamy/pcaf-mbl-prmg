//
//  FWFileManager.h
//  FWUpdateSDK
//
//  Created by sps on 2020/10/13.
//

#import <Foundation/Foundation.h>


@protocol FWFileManagerDelegate;

@interface FWFileManager : NSObject {
    }

+ (FWFileManager*)sharedInstance;

/**
 * get hex file list from server
 * @returns available hex Name List from server
 */
- (NSArray *) getServerList;

/**
 * get hex file list from lacal strage
 * @returns available hex Name List from local
 * */
- (NSArray *)getLocalAllHexList;
- (NSMutableArray *)getLocalHexListForDevice;
- (NSArray *)getLocalHexListForRFIDModule;
- (NSArray *)getLocalHexListForIFModule;

- (void)setHexFilePath:(NSString *)path;
- (NSString *)getHexFilePath;

/**
 *
 * delete Hex file from local storae
 * @param StrFileName : Hex File name
 * @returns (BOOL) YES:sucess  NO :fail
 */
- (BOOL)deleteLocalFile:(NSString *)StrFileName;

/**
 * download  HEX file From ServerURL
 * @param url  : Server URL
 * @param strFileName : Hex file name
 * @returns (BOOL) YES:sucess  NO :fail
 */
- (BOOL)downloadFromServerURL:(NSString *)url FileName:(NSString*)strFileName;



@property(nonatomic,strong) NSString *serverURL;

@end
