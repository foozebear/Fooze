//
//  PreConfirmPromoViewController.h
//  Fooze
//
//  Created by Alex Russell on 5/28/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmViewController.h"
#import "SuccessViewController.h"
#import "Menu.h"
#import "PromoCodeViewController.h"

@interface PreConfirmPromoViewController : UIViewController <PromoCodeViewControllerDelegate>

@property (strong, nonatomic) NSString *ordertext;
@property (strong, nonatomic) NSString *deliverystring;

@property (strong, nonatomic) NSString *addresstext;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) Menu *menu;
@property (strong, nonatomic) NSString *customerID;
@property (nonatomic) float credit;
@property (nonatomic) float freefood;
@end
