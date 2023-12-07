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
        [MWSDK setEnvironment:environment];
        [MWSDK setApiKey:apikey];
        [MWSDK setChain:chain];
//        MWEnvironment env = MWEnvironmentMainNet;
//        if (environment == 1){env = MWEnvironmentMainNet; }
//        if (environment == 2){env = MWEnvironmentDevNet; }
////        if (environment == 0){env = MWEnvironmentStagingDevNet; }
////        if (environment == 1){env = MWEnvironmentStagingMainNet; }
////        if (environment == 3){ env = MWEnvironmentDevNet; }
//        MWChain chainEnum = MWChainSolana;
//        if (chain == 1){ chainEnum = MWChainSolana; }
//        if (chain == 2){ chainEnum = MWChainEthereum; }
//        if (chain == 3){ chainEnum = MWChainPolygon; }
//        if (chain == 4){ chainEnum = MWChainBNB; }
//        NSLog(@"ios-environment:%ld",(long)env);
//        NSString *key = [NSString stringWithFormat:@"%s",apikey];
//        [[MirrorWorldSDK share] initSDKWithEnv:env chain:chainEnum apiKey:key];
    }
}

extern "C"
{
    typedef void (*IOSLoginCallback) (const char *object);
    extern void IOSStartLogin(IOSLoginCallback callback){
        NSLog(@"mwsdk:IOSStartLogin called");
        //Used for reference
//        [[MirrorWorldSDK share] startLoginOnSuccess:^(NSDictionary<NSString *,id> * userinfo) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userinfo options:NSJSONWritingPrettyPrinted error:nil];
//                NSString *user = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                const char *cString = [user UTF8String];
//                callback(cString);
//              });
//        } onFail:^{
//
//        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MWSDK startLogin:^(NSDictionary<NSString *, id> * _Nullable userInfo) {
                // 处理登录成功的情况，可以使用传入的 userInfo
                NSLog(@"mwsdk:Login successful. User info: %@", userInfo);
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
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
        NSLog(@"iOS_MWSDK_LOG: - IOSOpenWallet");
//        NSString *urlStr = [NSString stringWithFormat:@"%s",url];
//
//        [[MirrorWorldSDK share] mw_Unity_WalletWithUrl:urlStr onLogout:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                callback("wallet is logout.");
//            });
//        } loginSuccess:^(NSDictionary<NSString *,id> * userinfo) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userinfo options:NSJSONWritingPrettyPrinted error:nil];
//                NSString *user = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                const char *cString = [user UTF8String];
//                walletLoginCallback(cString);
//            });
//        }];
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
