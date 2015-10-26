//
//  WelcomeViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/7/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHWalkThroughView.h"

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@class WelcomeViewController;
@protocol WelcomeViewControllerDelegate <NSObject>

- (void)continueFromWelcomeToOnboardingMenu:(WelcomeViewController *) controller;
- (void)continueFromWelcomeToOnboard:(WelcomeViewController *) controller;
- (void)continueFromWelcome:(WelcomeViewController *) controller;
- (void)continueFromWelcomeToSignUp:(WelcomeViewController *) controller;
- (void)continueFromWelcomeToLogin:(WelcomeViewController *) controller;

@end

@interface WelcomeViewController : UIViewController <GHWalkThroughViewDataSource, GHWalkThroughViewDelegate>

@property (nonatomic,strong) id<WelcomeViewControllerDelegate> delegate;

//Walkthrough
@property (nonatomic, strong) GHWalkThroughView* ghView ;
@property (nonatomic, strong) NSArray* descStrings;
@property (nonatomic, strong) UILabel* welcomeLabel;
@property (nonatomic, strong) NSArray *walkthroughTitle;
//End

@end
