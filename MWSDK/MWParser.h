//
//  MWParser.h
//  MWSDK
//
//  Created by squall on 2023/12/7.
//

#ifndef MWParser_h
#define MWParser_h

@interface MWParser : NSObject



+ (NSDictionary<NSString *, NSString *> *)getParameters:(NSString *)paramsString;

#endif /* MWParser_h */
@end
