//
//  PromoCodeViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/31/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Branch.h"
#import "PromoCodeSuccessViewController.h"

@class PromoCodeViewController;
@protocol PromoCodeViewControllerDelegate <NSObject>

@optional
- (void)goBackToConfirmView:(PromoCodeViewController *)controller withCredit:(float)credit;

@end

@interface PromoCodeViewController : UIViewController <PromoCodeSuccessViewControllerDelegate>
@property (nonatomic,strong) id<PromoCodeViewControllerDelegate> delegate;
@property (nonatomic) BOOL bSettings;
@end
