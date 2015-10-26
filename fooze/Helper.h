//
//  Helper.h
//  fooze
//
//  Created by RMBuerano on 6/25/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Extended.h"
#import "SCLAlertView.h"
#import "UIButton+Activity.h"
#import "Branch.h"
#import "Flurry.h"
#import "AppboyKit.h"

NSString* const FONTSTYLE;

//DEFAULTS KEY
#define kLogged @"Logged"

@interface Helper : NSObject

+ (void)setPlaceholderColor:(UITextField *)txtField withColor:(UIColor *)color;
+ (void)showLocalNotification:(NSString *)message forRestaurant:(NSString *)restaurant andFood:(NSString *)food;
@end
