//
//  BPIAppDelegate.h
//  Password Browser Extension
//
//  Created by Nathan Greenstein on 12/28/12.
//  Copyright (c) 2012 Nathan Greenstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BPILoginViewController;

@interface BPIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BPILoginViewController *viewController;

@property (nonatomic) BOOL unlocked;

@property (nonatomic) BOOL hasPendingUrl;
@property (nonatomic) NSURL *pendingUrl;
@property (nonatomic) NSString *pendingUrlSource;

- (void) handlePendingUrl;

@end