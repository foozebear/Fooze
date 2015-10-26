//
//  SignUpViewController.h
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GHWalkThroughView.h"

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@class SignUpViewController;
@protocol SignUpViewControllerDelegate <NSObject>

- (void)showOnboardFromSignup:(SignUpViewController *)controller;
- (void)showWelcomeAgainFromSignUp:(SignUpViewController *)controller;

@end

@interface SignUpViewController : UIViewController <GHWalkThroughViewDataSource, GHWalkThroughViewDelegate>

@property (nonatomic,strong) id<SignUpViewControllerDelegate> delegate;

//Walkthrough
@property (nonatomic, strong) GHWalkThroughView* ghView ;
@property (nonatomic, strong) NSArray* descStrings;
@property (nonatomic, strong) UILabel* welcomeLabel;
@property (nonatomic, strong) NSArray *walkthroughTitle;
//End

@end
