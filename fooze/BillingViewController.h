//
//  BillingViewController.h
//  Fooze
//
//  Created by RMBuerano on 7/1/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
//#import "ConfirmViewController.h"
//
//@class BillingViewController;
//@protocol BillingViewControllerDelegate <NSObject>
//
//- (void)proceedToFoozeHome:(BillingViewController *) controller;
//
//@end

@interface BillingViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *customerID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *phonenumber;
@property (strong, nonatomic) NSString *specialinstruction;

@property (strong, nonatomic) NSString *cardname;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardCVC;
@property (strong, nonatomic) NSString *cardExpiry;

//@property (nonatomic,strong) id<BillingViewControllerDelegate> delegate;

@end
