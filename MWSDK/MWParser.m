//
//  MWParser.m
//  MWSDK
//
//  Created by squall on 2023/12/7.
//

#import <Foundation/Foundation.h>

#import "MWParser.h"
@implementation MWParser

+ (NSDictionary<NSString *, NSString *> *)getParameters:(NSString *)paramsString {
    if (![paramsString hasPrefix:@"mwsdk:"]) {
        NSLog(@"mwsdk:ios-can not handle this scheme string:%@",paramsString);
        return nil;
    }
    
    NSArray<NSString *> *schemeComponents = [paramsString componentsSeparatedByString:@"mwsdk://"];
    
    if (schemeComponents.count <= 0) {
        return nil;
    }
    
    NSString *schemeValue = schemeComponents.lastObject;
    
    if ([schemeValue hasPrefix:@"userinfo"]) {
        NSString *data = [[schemeValue componentsSeparatedByString:@"userinfo?"] lastObject];
        NSArray<NSString *> *params = [data componentsSeparatedByString:@"&"];
        NSMutableDictionary<NSString *, NSString *> *paramDic = [NSMutableDictionary dictionary];
        
        for (NSString *item in params) {
            NSString *key = [[item componentsSeparatedByString:@"="] firstObject];
            NSString *value = [[item componentsSeparatedByString:@"="] lastObject];
            paramDic[key ?: @""] = value;
        }
        
        return paramDic;
    } else if ([schemeValue hasPrefix:@"data"]) {
        NSString *data = [[schemeValue componentsSeparatedByString:@"data?"] lastObject];
        NSArray<NSString *> *params = [data componentsSeparatedByString:@"&"];
        NSMutableDictionary<NSString *, NSString *> *paramDic = [NSMutableDictionary dictionary];
        
        for (NSString *item in params) {
            NSString *key = [[item componentsSeparatedByString:@"="] firstObject];
            NSString *value = [[item componentsSeparatedByString:@"="] lastObject];
            paramDic[key ?: @""] = value;
        }
        
        return paramDic;
    } else if ([schemeValue hasPrefix:@"wallet"]) {
//        [[MirrorWorldSDKAuthData share] clearToken];
//        if (self.onWalletLogOut) {
//            self.onWalletLogOut();
//        }
        return nil;
    } else if ([schemeValue hasPrefix:@"approve"]) {
        
        // Assuming schemeValue is an NSString
        NSString *approveDataString = [schemeValue componentsSeparatedByString:@"approve?data="].lastObject;
        
        NSData *jsonData = [approveDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

        if (error) {
            NSLog(@"mwsdk:Error parsing JSON: %@", error.localizedDescription);
            return nil;
        }
        
        
        NSString *authToken = jsonDictionary[@"authorization_token"];
        if(authToken == nil){
            authToken = @"";
        }
        
        NSString *actionJson = jsonDictionary[@"action"];
        if(actionJson == nil){
            actionJson = @"";
        }
        
        NSString *uuid = jsonDictionary[@"uuid"];
        if(uuid == nil){
            uuid = @"";
        }

        NSLog(@"wmsdk:uuid is %@ and authToken is:%@",uuid,authToken);
//        if (self.authorizationTokenBlock) {
//            self.authorizationTokenBlock(uuid, authToken);
//        }
    } else {
        NSLog(@"unSupport the schemeType :%@",schemeValue);
        return nil;
    }
    
    return nil;
}

@end


