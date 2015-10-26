//
//  OnboardOneViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/17/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@class OnboardOneViewController;
@protocol OnboardOneViewControllerDelegate <NSObject>

- (void)showWelcomeAgainFromOnboard:(OnboardOneViewController *) controller;
- (void)continueToSignupFromOnboardOne:(OnboardOneViewController *) controller;
- (void)continueToOnboardTwo:(OnboardOneViewController *) controller;

@end

@interface OnboardOneViewController : UIViewController

@property (nonatomic) int page;
@property (nonatomic,strong) id<OnboardOneViewControllerDelegate> delegate;

@end
