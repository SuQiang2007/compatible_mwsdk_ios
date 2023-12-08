//
//  MWSDK.h
//  MWSDK
//
//  Created by squall on 2023/12/6.
//

#import <Foundation/Foundation.h>

//Defines
typedef void (^LoginCompletionBlock)(NSMutableDictionary<NSString *, id> * _Nullable loginResultDic);

//! Project version number for MWSDK.
FOUNDATION_EXPORT double MWSDKVersionNumber;

//! Project version string for MWSDK.
FOUNDATION_EXPORT const unsigned char MWSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MWSDK/PublicHeader.h>

@interface MWSDK : NSObject



//Parameters
+ (char*_Nullable)apiKey;
+ (int)environment;//1:mainnet;2:devnet;3:testnet
+ (int)chain;//1:Solana;2:Ethereum;3:Polygon;4:BNB

//Set functions
+ (void)setApiKey:(char *_Nullable)apiKey;
+ (void)setEnvironment:(int)environment;
+ (void)setChain:(int)chain;


//Test functions
+ (void)logMessage:(NSString *_Nullable)message;

//SDK functions
+ (void)startLogin:(LoginCompletionBlock _Nullable )completionBlock;
+ (void)handleOpen:(NSURL*_Nonnull) url;

//SDK callbacks
+ (LoginCompletionBlock _Nullable )loginOnCompletion:(LoginCompletionBlock _Nullable )completionBlock;




@end
