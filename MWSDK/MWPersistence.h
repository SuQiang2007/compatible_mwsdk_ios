//
//  MWPersistence.h
//  MWSDK
//
//  Created by squall on 2023/12/11.
//

#ifndef MWPersistence_h
#define MWPersistence_h


@interface MWPersistence : NSObject;

+ (void)saveRefreshToken : (NSString *_Nonnull)token;
#endif /* MWPersistence_h */

+ (NSString*_Nullable)getSavedRefreshToken;

@end
