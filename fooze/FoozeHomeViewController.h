//
//  FoozeHomeViewController.h
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Helper.h"
#import "WelcomeViewController.h"
#import "SettingsViewController.h"
#import "LogInViewController.h"
#import "OnboardOneViewController.h"
#import "OnboardTwoViewController.h"
#import "OnboardThreeViewController.h"
#import "OnboardThreeViewController.h"
#import "SignUpViewController.h"
#import "PreConfirmPromoViewController.h"
#import "OnBoardingMenuViewController.h"
#import "OnBoardingMenuOrderViewController.h"

@interface FoozeHomeViewController : UIViewController <WelcomeViewControllerDelegate, SettingsViewControllerDelegate, LogInViewControllerDelegate, OnboardOneViewControllerDelegate, OnboardTwoViewControllerDelegate, OnboardThreeViewControllerDelegate, SignUpViewControllerDelegate, OnBoardingMenuViewControllerDelegate, OnBoardingMenuOrderViewControllerDelegate>

@property (nonatomic, strong) NSString *order1;
@property (nonatomic, strong) NSString *order2;
@property (nonatomic, strong) NSString *order3;

@property (nonatomic, strong) NSString *fax1;
@property (nonatomic, strong) NSString *fax2;
@property (nonatomic, strong) NSString *fax3;

@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *fax;

@property (nonatomic, strong) NSString *track;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) PFUser *admin;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property int currentButton;

@property BOOL laid;

//Walkthrough
//@property (nonatomic, strong) GHWalkThroughView* ghView ;
//@property (nonatomic, strong) NSArray* descStrings;
//@property (nonatomic, strong) UILabel* welcomeLabel;
//@property (nonatomic, strong) NSArray *walkthroughTitle;
//End

@end    
