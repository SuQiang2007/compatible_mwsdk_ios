//
//  MirrorBridegForC.m
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/3.
//

#import "MirrorBridegForC.h"
#import <MWSDK/MWSDK.h>

@implementation MirrorBridegForC


extern "C"
{
    extern void IOSLogMessage(const char* logContent){
        NSString *message = [NSString stringWithUTF8String:logContent];
        [MWSDK logMessage:message];
    }
}

extern "C"
{
    extern void IOSInitSDK(int environment, int chain, char *apikey){
        [MWSDK initSDK:environment chain:chain apiKey:apikey];
    }
}

extern "C"
{
    typedef void (*IOSLoginCallback) (const char *object);
    extern void IOSStartLogin(IOSLoginCallback callback){
        NSLog(@"mwsdk:ios bridge IOSStartLogin called.");
        dispatch_async(dispatch_get_main_queue(), ^{
            [MWSDK startLogin:^(NSDictionary<NSString *, id> * _Nullable loginResponse) {
                NSLog(@"mwsdk:ios IOSStartLogin callback runs");
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:loginResponse options:NSJSONWritingPrettyPrinted error:nil];
                NSString *user = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                const char *cString = [user UTF8String];
                callback(cString);
            }];
            
        });
    }
}


extern "C"
{
    typedef void (*iOSWalletLogOutCallback)(const char *object);
    typedef void (*iOSWalletLoginTokenCallback)(const char *object);

    extern void IOSOpenWallet(const char *url,iOSWalletLogOutCallback callback,iOSWalletLoginTokenCallback walletLoginCallback){
        NSLog(@"mwsdk ios: - IOSOpenWallet in bridge runs.");
        [MWSDK openWallet:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (callback != nil) {
                        callback("No need this string param any more");
                    }
                });
            }];
    }

}

extern "C"
{
    extern void IOSOpenMarketPlace(char *url){
        NSString *urlStr = [NSString stringWithFormat:@"%s",url];
      
//        NSLog(@"iOS_MWSDK_LOG: - IOSOpenMarketPlace:%@",urlStr);
//        [[MirrorWorldSDK share] openMarketWithUrl:urlStr];
//        NSLog(@"iOS_MWSDK_LOG: - IOSOpenMarketPlace。");
    }
}


extern "C"
{
    extern void IOSOpenUrl(const char *object){
//        NSString *urlStr = [NSString stringWithFormat:@"%s",object];
//        [[MirrorSecurityVerificationShared share] openWebPage:urlStr];
//        NSLog(@"iOS_MWSDK_LOG: - IOSOpenURL");
    }
    typedef void (*IOSSecurityAuthCallback)(const char *object);
    extern void IOSOpenUrlSetCallBack(IOSSecurityAuthCallback callback){
//        [[MirrorSecurityVerificationShared share] getApproveCallBackWithFinish:^(NSString * uuid, NSString * authtoken) {
//                    const char *cString = [authtoken UTF8String];
//                    callback(cString);
//            NSLog(@"iOS_MWSDK_LOG: - IOSApproveCallBack");
//        }];
        
    }

    
    
    typedef void (*IOSSecurityCallback)(const char *object);
    extern void IOSGetSecurityToken(char *params,IOSSecurityCallback callback){
        NSString *paramStr = [NSString stringWithFormat:@"%s",params];
        NSData *data = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *paramJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        [[MirrorSecurityVerificationShared share] getSecurityTokenWithParams:paramJson config:[MirrorWorldSDK share].sdkConfig :^(BOOL, NSString * authToken) {
//            const char *cString = [authToken UTF8String];
//            callback(cString);
//        }];
    }

}

@end
