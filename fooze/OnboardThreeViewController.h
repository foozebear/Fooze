//
//  OnboardThreeViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/17/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@class OnboardThreeViewController;
@protocol OnboardThreeViewControllerDelegate <NSObject>

- (void)continueToSignupFromOnboardThree:(OnboardThreeViewController *) controller;
- (void)backToOnboardTwo:(OnboardThreeViewController *) controller;

@end

@interface OnboardThreeViewController : UIViewController

@property (nonatomic,strong) id<OnboardThreeViewControllerDelegate> delegate;

@end
