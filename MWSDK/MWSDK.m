// MWSDK.m

#import "MWSDK.h"
#import "MWLoginPage.h"
#import "MWParser.h"
#import "MWPersistence.h"
#import "MWNetUtil.h"

@implementation MWSDK

//Parameters
static char *apiKey = nil;
static int environment = 0;
static int chain = 0;
static bool initialized = false;

static NSString *accessToken = nil;
static NSString *refreshToken = nil;

static LoginCompletionBlock _Nullable loginCompletionBlock;//Called when login flow is successed
static WalletLogoutBlock walletLogoutBlock;
static MWLoginPage  * _Nullable loginPage;//Pointer of the opening login page
static MWLoginPage * _Nullable walletPage;//Pointer of the opening wallet page

static NSString *const loginUrl = @"https://auth-next.mirrorworld.fun/v1/auth/login";
static NSString *const walletUrl = @"https://auth-next.mirrorworld.fun/v1/assets/tokens";




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

+ (void)setAccessToken:(NSString *)newAccToken {
    NSLog(@"mwsdk:ios-access token set to:%@",newAccToken);
    accessToken = newAccToken;
}

+ (void)setRefreshToken:(NSString *)newRefreshToken {
    NSLog(@"mwsdk:ios-refresh token set to:%@",newRefreshToken);
    refreshToken = newRefreshToken;
}

+ (NSString *)accessToken{
    return accessToken;
}

+ (NSString *)refreshToken{
    return refreshToken;
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
+ (MWLoginPage* _Nullable)walletPage {
    return walletPage;
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

        // 想要查看的数据
        [fakeDictionary setObject:accessToken forKey:@"AccessToken"];
        [fakeDictionary setObject:refreshToken forKey:@"RefreshToken"];
        [fakeDictionary setObject:@"user@example.com" forKey:@"Email"];

        loginBlock(fakeDictionary);
    } else {
        NSLog(@"Login completion block is not set");
    }
}


////SDK functions

+ (void)mwRequestWithURL:(NSString *)url
                  isPost:(BOOL)isPost
                 dataDic:(NSDictionary<NSString *, id> *_Nullable)dataDic
                successBlock:(void (^)(NSString *responseString))successBlock
                failBlock:(void (^)(NSInteger code, NSString *errorDesc))failBlock
{
    
    NSString *method = isPost ? @"POST" : @"GET";
    NSString *apiKeyString = [NSString stringWithUTF8String:apiKey];

    [MWNetUtil requestWithURL:url method:method params:dataDic apiKey:apiKeyString authorizationToken:nil accessToken:accessToken success:^(NSString *response) {
            if(successBlock) successBlock(response);
        } faild:^(NSInteger code, NSString *errorDesc) {
            if(failBlock) failBlock(code,errorDesc);
        }
    ];
}

+ (void)autoLogin:(LoginCompletionBlock)completionBlock {
    if (!initialized) {
        NSLog(@"mwsdk ios: please call MWSDK initSDK first!");
        return;
    }
    
    if(!accessToken){
        NSLog(@"mwsdk ios: there is no access token, please login first.");
        return;
    }
    
    if(!refreshToken){
        refreshToken = [MWPersistence getSavedRefreshToken];
    }
    if(!refreshToken){
        [self startLogin:completionBlock];
        return;
    }
    NSString *url = @"https://api.mirrorworld.fun/v2/auth/refresh-token";
    NSDictionary<NSString *, id> *tokenDictionary = @{@"x-refresh-token": refreshToken};
    [self mwRequestWithURL:url
                    isPost:false
                   dataDic:tokenDictionary
              successBlock:^(NSString * responseString) {
        
                    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *jsonError;

                    NSMutableDictionary<NSString *, id> *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

                    if (jsonError) {
                        NSLog(@"Error parsing JSON: %@", jsonError.localizedDescription);
                    } else {
                        NSLog(@"Parsed JSON: %@", jsonDict);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionBlock) {
                            completionBlock(jsonDict);
                        }
                    });
              }
                 failBlock:^(NSInteger code, NSString * errorDesc) {
                     NSLog(@"mwsdk ios:auto login failed, opening login page...");
                     
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self startLogin:completionBlock];
                    });
                 }];
}


+ (void)startLogin:(LoginCompletionBlock)completionBlock {
    if(!initialized){
        NSLog(@"mwsdk ios: please call MWSDK initSDK first!");
        return;
    }
    [MWSDK setLoginCompletionBlock:completionBlock];
    //MWSDK loginOnCompletion should be called when webview finish the login flow

    NSURL *url = [NSURL URLWithString:loginUrl];
    MWLoginPage *safariViewController = [[MWLoginPage alloc] initWithURL:url];
    [MWSDK setLoginPage:safariViewController];
    [[MWSDK getBaseViewController] presentViewController:safariViewController animated:YES completion:nil];
}

+ (void)initSDK:(int)env chain:(int)chain apiKey:(char * _Nonnull)apiKey {
    NSLog(@"mwsdk:ios:init %d,%d,%s",env,chain,apiKey);
    initialized = true;
    [self setEnvironment:env];
    [self setChain:chain];
    [self setApiKey:apiKey];
    
    NSString * oldRefreshToken = [MWPersistence getSavedRefreshToken];
    NSLog(@"mwsdk:ios oldRefreshToken is %@",oldRefreshToken);
    if(oldRefreshToken != nil){
        [self setRefreshToken:oldRefreshToken];
    }
    
}

+ (void)clearMWCache {
    NSLog(@"mwsdk:ios clear cache>>>>>>");
    accessToken = nil;
    refreshToken = nil;
    [MWPersistence clearRefreshToken];
}

+ (void)openWallet:(WalletLogoutBlock)callback {
    
    NSURL *url = [NSURL URLWithString:walletUrl];
    MWLoginPage *safariViewController = [[MWLoginPage alloc] initWithURL:url];
    walletPage = safariViewController;
    [[MWSDK getBaseViewController] presentViewController:safariViewController animated:YES completion:nil];
    
    walletLogoutBlock = ^{
        NSLog(@"mwsdk:ios logout called and mw cache will be clean.");
        [self clearMWCache];
        if (callback) {
            callback();
        }
    };
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
            else if ([key isEqualToString:@"data"]) {
                NSData *userInfoObject = [value dataUsingEncoding:NSUTF8StringEncoding];
                //todo set user info
                [self _handleUserInfo:userInfoObject];
            }
            else if ([key isEqualToString:@"authorization_token"]) {
                authorization_token = value ?: @"";
            }
            else if ([key isEqualToString:@"walletLogout"]) {
                walletLogoutBlock();
                [self.walletPage dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"walletPage dismissed");
                }];
                return;
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
    [self setAccessToken:accessToken];
}

+(void) _handleRefreshToken:(NSString *) refreshToken{
    [self setRefreshToken:refreshToken];
    [MWPersistence saveRefreshToken:refreshToken];
}

+(void) _handleUserInfo:(NSData *) userInfo{
    //todo persistence userInfo if needed
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
