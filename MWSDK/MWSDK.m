// MWSDK.m

#import "MWSDK.h"
#import "MWLoginPage.h"
#import "MWParser.h"

@implementation MWSDK

//Parameters
static char *apiKey = nil;
static int environment = 0;
static int chain = 0;

static LoginCompletionBlock _Nullable loginCompletionBlock;
static MWLoginPage  * _Nullable loginPage;
static NSString *const loginUrl = @"https://auth-next.mirrorworld.fun/v1/auth/login";




///Get set functions
+ (void)setApiKey:(char *)newApiKey {
    NSLog(@"mwsdk:ios-apikey set to:%s",newApiKey);
    apiKey = newApiKey;
}

+ (void)setEnvironment:(int)newEnvironment {
    NSLog(@"mwsdk:ios-environment set to:%d",newEnvironment);
    environment = newEnvironment;
}

+ (void)setChain:(int)newChain {
    NSLog(@"mwsdk:ios-chain set to:%d",newChain);
    chain = newChain;
}

+ (void)setLoginCompletionBlock:(LoginCompletionBlock _Nullable)block {
    loginCompletionBlock = block;
}

+ (LoginCompletionBlock _Nullable)loginOnCompletion {
    return loginCompletionBlock;
}

+ (void)setLoginPage:(MWLoginPage* _Nullable)newLoginPage {
    loginPage = newLoginPage;
}

+ (MWLoginPage* _Nullable)loginPage {
    return loginPage;
}

+ (char *)apiKey {
    return apiKey;
}

+ (int)environment {
    return environment;
}

+ (int)chain {
    return chain;
}


//Test functions
+ (void)logMessage:(NSString *)message{
    NSLog(@"logMessage:This is my message:%@",message);
//    NSDictionary<NSString *,id> * _Nullable userInfo;
    
    LoginCompletionBlock loginBlock = [MWSDK loginOnCompletion];

    if (loginBlock) {
        // 创建一个空的 NSMutableDictionary
        NSMutableDictionary<NSString *, id> *fakeDictionary = [NSMutableDictionary dictionary];

        // 添加一些假数据
        [fakeDictionary setObject:@"John" forKey:@"Name"];
        [fakeDictionary setObject:@25 forKey:@"Age"];
        [fakeDictionary setObject:@"user@example.com" forKey:@"Email"];

        loginBlock(fakeDictionary);
    } else {
        NSLog(@"Login completion block is not set");
    }
}


////SDK functions
+ (void)startLogin:(LoginCompletionBlock)completionBlock {
    [MWSDK setLoginCompletionBlock:completionBlock];
    //MWSDK loginOnCompletion should be called when webview finish the login flow

    NSURL *url = [NSURL URLWithString:loginUrl];
    MWLoginPage *safariViewController = [[MWLoginPage alloc] initWithURL:url];
    [MWSDK setLoginPage:safariViewController];
    [[MWSDK getBaseViewController] presentViewController:safariViewController animated:YES completion:nil];
}


+ (void)handleOpen:(NSURL *)url {
    NSString *urlString = [url.absoluteString stringByRemovingPercentEncoding];
    if (!urlString) {
        NSLog(@"mwsdk:ios UrlScheme Decode failed !");
        return;
    }
    NSLog(@"%@", [NSString stringWithFormat:@"mwsdk:ios received:%@", urlString]);

    NSDictionary<NSString *, id> *result = [MWParser getParameters:urlString];
    NSArray<NSString *> *keys = result.allKeys;

    if (keys.count > 0) {
        NSString *access_tokenKey = @"";
        NSString *refresh_tokenKey = @"";
        NSDictionary<NSString *, id> *userInfoObject;
        NSString *authorization_token = @"";

        for (NSString *key in keys) {
            id value = result[key];

            if ([key isEqualToString:@"access_token"]) {
                NSString *accToken = [NSString stringWithFormat:@"%@", value ?: @""];
                accToken = [accToken substringWithRange:NSMakeRange(1, accToken.length - 2)];
                access_tokenKey = accToken;
                [self _handleAccessToken:accToken];
            }
            else if ([key isEqualToString:@"refresh_token"]) {
                NSString *refreToken = [NSString stringWithFormat:@"%@", value ?: @""];
                refreToken = [refreToken substringWithRange:NSMakeRange(1, refreToken.length - 2)];
                refresh_tokenKey = refreToken;
                [self _handleRefreshToken:refreToken];
            }

            if ([key isEqualToString:@"data"]) {
                NSData *userInfoObject = [value dataUsingEncoding:NSUTF8StringEncoding];
                //todo set user info
                [self _handleUserInfo:userInfoObject];
            }

            if ([key isEqualToString:@"authorization_token"]) {
                authorization_token = value ?: @"";
            }
        }

        NSMutableDictionary<NSString *, id> *loginResponse = [NSMutableDictionary dictionary];
        loginResponse[@"user"] = userInfoObject;
        loginResponse[@"refresh_token"] = refresh_tokenKey;
        loginResponse[@"access_token"] = access_tokenKey;

        NSLog(@"%@", [NSString stringWithFormat:@"mwsdk:ios scheme parse result:%@", loginResponse]);
        //todo
        
        if (self.loginOnCompletion) {
            self.loginOnCompletion(loginResponse);
            [self.loginPage dismissViewControllerAnimated:YES completion:^{
                NSLog(@"SafariViewController dismissed");
            }];
        } else {
            NSLog(@"loginOnCompletion is nil");
        }
    } else {
        NSLog(@"mwsdk:ios UrlScheme No parameters.");
    }
}

+(void) _handleAccessToken:(NSString *) accessToken{
    //todo set access token
//                [MirrorWorldSDKAuthData share].access_token = accToken;
//                if (self.accessTokenBlock) {
//                    self.accessTokenBlock(accToken);
//                }
}

+(void) _handleRefreshToken:(NSString *) refreshToken{
    
    //todo set refresh token
//                [MirrorWorldSDKAuthData share].refresh_token = refreToken;
//                [[MirrorWorldSDKAuthData share] saveRefreshToken];
//                if (self.refreshTokenBlock) {
//                    self.refreshTokenBlock(refreToken);
//                }
}

+(void) _handleUserInfo:(NSData *) userInfo{
    
//                [MirrorWorldSDKAuthData share].userInfo = userInfoObject;
}


+ (UIViewController *)getBaseViewController {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    UIViewController *rootViewController = window.rootViewController;

    if (!rootViewController) {
        return nil;
    }

    UIViewController *topController = rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

@end
