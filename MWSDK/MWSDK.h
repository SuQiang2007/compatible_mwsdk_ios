//
//  MWSDK.h
//  MWSDK
//
//  Created by squall on 2023/12/6.
//

#import <Foundation/Foundation.h>

//! Project version number for MWSDK.
FOUNDATION_EXPORT double MWSDKVersionNumber;

//! Project version string for MWSDK.
FOUNDATION_EXPORT const unsigned char MWSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MWSDK/PublicHeader.h>

@interface MWSDK : NSObject

/**
 Logs a message to the console.
 */
+ (void)logMessage;

@end
