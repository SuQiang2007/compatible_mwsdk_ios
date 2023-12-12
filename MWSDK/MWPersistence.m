//
//  MWPersistence.m
//  MWSDK
//
//  Created by squall on 2023/12/11.
//

#import <Foundation/Foundation.h>
#import "MWPersistence.h"

@implementation MWPersistence

+ (void)saveRefreshToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"mw_refresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *_Nullable)getSavedRefreshToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"mw_refresh_token"];
    return token;
}

+ (void)clearRefreshToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mw_refresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
