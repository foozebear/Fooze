//
//  DeliveryAddressViewController.h
//  Fooze
//
//  Created by Alex Russell on 4/17/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
//#import "PaymentViewController.h"
//
//@class DeliveryAddressViewController;
//@protocol DeliveryAddressViewControllerDelegate <NSObject>
//
//- (void)proceedToFoozeHome:(DeliveryAddressViewController *) controller;
//
//@end

@interface DeliveryAddressViewController : UIViewController
@property (strong, nonatomic) UITextField *streetaddress;
@property (strong, nonatomic) UITextField *unit;
@property (strong, nonatomic) UITextField *city;
@property (strong, nonatomic) UITextField *zip;

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phonenumber;

@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *streetNumber;
@property (strong, nonatomic) UISwitch *switchoutlet;
@property (strong, nonatomic) NSString *customerID;
@property (strong, nonatomic) NSMutableDictionary *delivery;
@property (strong, nonatomic) NSString *onFleetRecipientID;
@property (strong, nonatomic) NSString *onFleetDestinationID;
@property (strong, nonatomic) NSString *edit;

@property (strong, nonatomic) PFUser *potentialUser;

@property (nonatomic) BOOL updateMode;

@end
