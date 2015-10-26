//
//  PromoCodeSuccessViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 8/1/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromoCodeSuccessViewController;
@protocol PromoCodeSuccessViewControllerDelegate <NSObject>

@optional
- (void)goBackToConfirmViewFromPromoCodeSuccess:(PromoCodeSuccessViewController *)controller withCredit:(float)credit;

@end

@interface PromoCodeSuccessViewController : UIViewController
@property (nonatomic,strong) id<PromoCodeSuccessViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *promo_amount;
@property (nonatomic) BOOL bSettings;
@property (nonatomic) long credit;
@end
