//
//  SettingsViewController.h
//  Fooze
//
//  Created by Alex Russell on 5/27/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "PromoCodeViewController.h"

@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>

- (void)showWelcomeScreen:(SettingsViewController *) controller;

@end

@interface SettingsViewController : UIViewController <PromoCodeViewControllerDelegate>

@property (strong, nonatomic) id<SettingsViewControllerDelegate> delegate;
@property (nonatomic) int iSettingsMode;
@end
