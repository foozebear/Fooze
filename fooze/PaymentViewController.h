//
//  PaymentViewController.h
//  Fooze
//
//  Created by Alex Russell on 4/27/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

//#import "BillingViewController.h"
//
//@class PaymentViewController;
//@protocol PaymentViewControllerDelegate <NSObject>
//
//- (void)proceedToFoozeHome:(PaymentViewController *) controller;
//
//@end

@interface PaymentViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableDictionary *deliveryAddress;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) NSString *customerID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *phonenumber;
@property (strong, nonatomic) NSString *specialinstruction;

@property (strong, nonatomic) NSString *edit;

@property (nonatomic) BOOL updateMode;

@end
