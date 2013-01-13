//
//  BPILoginViewController.h
//  Password Browser Extension
//
//  Created by Nathan Greenstein on 12/28/12.
//  Copyright (c) 2012 Nathan Greenstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPILoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *loggedInView;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)logInTapped:(id)sender;

@end
