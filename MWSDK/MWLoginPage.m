//
//  MWLoginPage.m
//  MWSDK
//
//  Created by squall on 2023/12/7.
//

#import <Foundation/Foundation.h>
#import "MWLoginPage.h"

@interface MWLoginPage () <SFSafariViewControllerDelegate>

@end

@implementation MWLoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // self.preferredBarTintColor = [UIColor blackColor];
    self.preferredControlTintColor = [UIColor colorWithRed:166/255.0 green:226/255.0 blue:46/255.0 alpha:1];
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    if (self.done) {
        self.done();
    }
}

- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL {
    NSLog(@"start loading");
}

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    NSLog(@"load finish");
}

- (void)safariViewControllerWillOpenInBrowser:(SFSafariViewController *)controller {
    NSLog(@"open with safari");
}

@end
