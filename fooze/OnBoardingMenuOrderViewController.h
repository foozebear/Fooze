//
//  OnBoardingMenuOrderViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 10/10/15.
//  Copyright © 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Menu.h"

@class OnBoardingMenuOrderViewController;
@protocol OnBoardingMenuOrderViewControllerDelegate <NSObject>

- (void)showWelcomeFromOnboardingMenuOrder:(OnBoardingMenuOrderViewController *)controller;
- (void)goBackToMenuFromOnboardingMenuOrder:(OnBoardingMenuOrderViewController *)controller;
- (void)signupFromOnboardingMenuOrder:(OnBoardingMenuOrderViewController *)controller;

@end

@interface OnBoardingMenuOrderViewController : UIViewController

@property (nonatomic, strong) id<OnBoardingMenuOrderViewControllerDelegate> delegate;
@property (nonatomic, strong) Menu *menu;
@end
