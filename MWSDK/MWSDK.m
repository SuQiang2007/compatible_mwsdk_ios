// MWSDK.m

#import "MWSDK.h"
#import "MWLoginPage.h"

@implementation MWSDK

//Parameters
static char *apiKey = nil;
static int environment = 0;
static int chain = 0;

static LoginCompletionBlock _Nullable loginCompletionBlock;
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
        NSDictionary<NSString *, id> *userInfo = @{@"key": @"value"};
        loginBlock(userInfo);
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
    [[MWSDK getBaseViewController] presentViewController:safariViewController animated:YES completion:nil];
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
