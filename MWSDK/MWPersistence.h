//
//  MWPersistence.h
//  MWSDK
//
//  Created by squall on 2023/12/11.
//

#ifndef MWPersistence_h
#define MWPersistence_h

#endif /* MWPersistence_h */

@interface MWPersistence : NSObject;

+ (void)saveRefreshToken : (NSString *_Nonnull)token;

+ (NSString*_Nullable)getSavedRefreshToken;

+ (void)clearRefreshToken;

@end
