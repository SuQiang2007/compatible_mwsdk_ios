//
//  MWLoginPage.m
//  MWSDK
//
//  Created by squall on 2023/12/7.
//

#import <Foundation/Foundation.h>


#ifndef MWLoginPage_h
#define MWLoginPage_h

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWLoginPage : SFSafariViewController

@property (nonatomic, copy) void (^finsh)(void);
@property (nonatomic, copy) void (^done)(void);

@end

NS_ASSUME_NONNULL_END
#endif
