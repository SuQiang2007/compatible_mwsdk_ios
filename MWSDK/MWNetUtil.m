#import "MWNetUtil.h"

@implementation MWNetUtil

+ (void)requestWithURL:(NSString *)url
                 method:(NSString *)method
                 params:(NSDictionary<NSString *, id> *)params
                apiKey:(NSString *)apiKey
     authorizationToken:(NSString *)authorizationToken
           accessToken:(NSString *)accessToken
                success:(void (^)(NSString *response))success
                  faild:(void (^)(NSInteger code, NSString *errorDesc))faild {
    
    NSURL *requestURL = [NSURL URLWithString:url];
    NSLog(@"mwsdk:request url is:%@", requestURL);
    
    NSURLSession *session = [self configURLSessionWithTimeout:60];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = method;
    [request setValue:apiKey forHTTPHeaderField:@"x-api-key"];  // Replace "your_api_key" with the actual API key
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    if (accessToken.length > 0) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    } else {
        NSLog(@"access_token is nil !");
    }
    
    if (authorizationToken.length > 0) {
        [request setValue:authorizationToken forHTTPHeaderField:@"x-authorization-token"];
    }
    
    if ([method isEqualToString:@"GET"]) {
        NSArray<NSString *> *keys = params.allKeys;
        if (keys.count > 0) {
            for (NSString *key in keys) {
                NSString *value = [params[key] isKindOfClass:[NSString class]] ? params[key] : @"";
                [request setValue:value forHTTPHeaderField:key];
            }
        }
    } else if ([method isEqualToString:@"POST"]) {
        NSString *bodyString = [self dictionaryToString:params];
        request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"Don't know the method:%@", method);
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && response) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"\n========================================\n");
            NSLog(@"%@", requestURL.absoluteString);
            NSLog(@"%@", dataString ?: @"null");
            NSLog(@"\n========================================\n");
            if (success) {
                success(dataString);
            }
        } else {
            if (faild) {
                faild(error.code, error.localizedDescription);
            }
        }
    }];
    [task resume];
}


+ (NSURLSession *)configURLSessionWithTimeout:(NSTimeInterval)timeout {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 可选：设置额外的HTTP头部
    // [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json"}];
    sessionConfiguration.timeoutIntervalForRequest = timeout;
    sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    return [NSURLSession sessionWithConfiguration:sessionConfiguration];
}


+ (NSString *)dictionaryToString:(NSDictionary<NSString *, id> *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    if (jsonData && !error) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
}

@end
