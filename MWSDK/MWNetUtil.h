//
//  MWNetUtil.h
//  MWSDK
//
//  Created by squall on 2023/12/11.
//

#ifndef MWNetUtil_h
#define MWNetUtil_h


#endif /* MWNetUtil_h */


#import <Foundation/Foundation.h>

@interface MWNetUtil : NSObject

+ (void)requestWithURL:(NSString *)url
                 method:(NSString *)method
                 params:(NSDictionary<NSString *, id> *)params
                apiKey:(NSString *)apiKey
     authorizationToken:(NSString *)authorizationToken
           accessToken:(NSString *)accessToken
                success:(void (^)(NSString *response))success
                 faild:(void (^)(NSInteger code, NSString *errorDesc))faild ;

+ (NSURLSession *)configURLSessionWithTimeout:(NSTimeInterval)timeout;

@end
