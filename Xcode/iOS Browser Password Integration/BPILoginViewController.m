//
//  BPIViewController.m
//  Password Browser Extension
//
//  Created by Nathan Greenstein on 12/28/12.
//  Copyright (c) 2012 Nathan Greenstein. All rights reserved.
//

#import "BPILoginViewController.h"
#import "BPIAppDelegate.h"

@interface BPILoginViewController ()

@end

@implementation BPILoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//An acutal password app would actually check the pasword and decrypt things here.
- (IBAction)logInTapped:(id)sender {
	[self.passwordField resignFirstResponder];
	self.loginView.alpha = 0;
	self.loggedInView.alpha = 1;
	BPIAppDelegate *delegate = (BPIAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.unlocked = YES;
	[delegate handlePendingUrl];
}

@end