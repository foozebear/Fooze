//
//  OnboardTwoViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/17/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@class OnboardTwoViewController;
@protocol OnboardTwoViewControllerDelegate <NSObject>

- (void)continueToOnboardThree:(OnboardTwoViewController *) controller;
- (void)backToOnboardOne:(OnboardTwoViewController *) controller;

@end


@interface OnboardTwoViewController : UIViewController

@property (nonatomic,strong) id<OnboardTwoViewControllerDelegate> delegate;

@end
