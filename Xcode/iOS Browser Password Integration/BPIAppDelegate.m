//
//  BPIAppDelegate.m
//  Password Browser Extension
//
//  Created by Nathan Greenstein on 12/28/12.
//  Copyright (c) 2012 Nathan Greenstein. All rights reserved.
//

#import "BPIAppDelegate.h"

#import "BPILoginViewController.h"

@implementation BPIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.unlocked = NO;
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[BPILoginViewController alloc] initWithNibName:@"BPILoginViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	self.hasPendingUrl = YES;
	self.pendingUrl = url;
	self.pendingUrlSource = sourceApplication;
	
	if (self.unlocked) {
		[self handlePendingUrl];
		return YES;
	}
	
	return NO;
}

- (void)handlePendingUrl {
	if (self.hasPendingUrl) {
	
		//Get the passed URL and cut off 'bpi://fillWebForm/' and URL-decode.
		NSString *pageUrlString = [[self.pendingUrl.absoluteString substringFromIndex:18] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *pageUrl = [NSURL URLWithString:pageUrlString];
		
		//Get the passed URL's hash if it has one.
		NSString *originalHash = @"";
		NSUInteger originalHashLength = 0;
		if (pageUrl.fragment) {
			originalHash = pageUrl.fragment;
			originalHashLength = originalHash.length + 1;
		}
		
		//Get the passed URL's scheme.
		NSString *scheme = pageUrl.scheme;
		
		//Clean up the passed URL
		//  Cut off 'scheme://' of the passed URL so that we can add the appropriate browser's scheme.
		//  Also cut off the original hash so we can add login info to it.
		NSUInteger schemeLength = pageUrl.scheme.length + 3;
		NSRange nakedRange = NSMakeRange(schemeLength, pageUrlString.length - originalHashLength - schemeLength);
		NSString *nakedUrlString = [pageUrlString substringWithRange:nakedRange];
		
		//If the bookmarklet was triggered from Chrome, use the appropriate Chrome scheme to take the user back.
		//Otherwise, keep the default http(s) and use Safari.
		if ([self.pendingUrlSource isEqualToString:@"com.google.chrome.ios"]) {
			if ([scheme isEqualToString:@"http"])		scheme = @"googlechrome";
			else if ([scheme isEqualToString:@"https"]) scheme = @"googlechromes";
		}
		
		//URL-encode the username and  password.
		//They are hard-coded here but would be fetched based on the URL, decrypted, etc by a real password manager.
		NSString *username = [@"someUser" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *password = [@"somePassword" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		//Add our login details to the end of the original hash.
		NSString *hash = [NSString stringWithFormat:@"%@?bpiUsername=%@&bpiPassword=%@", originalHash, username, password];
		
		//Make a string and URL combining all the parts we made.
		NSString *openString = [NSString stringWithFormat:@"%@://%@#%@", scheme, nakedUrlString, hash];
		NSURL *openUrl = [NSURL URLWithString:openString];
		
		[[UIApplication sharedApplication] openURL:openUrl];
		
		self.hasPendingUrl = NO;
		self.pendingUrl = nil;
		self.pendingUrlSource = nil;
	
	}
}

@end