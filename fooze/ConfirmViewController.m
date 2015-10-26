//
//  ConfirmViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/14/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnCool;
@property (strong, nonatomic) IBOutlet UIView *viewFoozeAway;
@property (strong, nonatomic) IBOutlet UIView *vwCool;

@end

@implementation ConfirmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Confirm Registration", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
}

- (void)viewDidLayoutSubviews
{
    _viewFoozeAway.layer.cornerRadius = _viewFoozeAway.frame.size.height/10.;
}

- (IBAction)actionNext:(id)sender
{
    [[Appboy sharedInstance] logCustomEvent:@"Signup - Completed"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.delegate proceedToFoozeHome:self];
}


- (IBAction)touchDown:(id)sender
{
    [_vwCool setBackgroundColor:[UIColor foozeYellow]];
}

@end
