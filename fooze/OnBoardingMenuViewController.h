//
//  OnBoardingMenuViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 10/9/15.
//  Copyright © 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Menu.h"

@class OnBoardingMenuViewController;
@protocol OnBoardingMenuViewControllerDelegate <NSObject>

- (void)showWelcomeFromOnboardingMenu:(OnBoardingMenuViewController *)controller;
- (void)showOnboardingMenuOrder:(OnBoardingMenuViewController *)controller withMenu:(Menu *)menu;

@end


@interface OnBoardingMenuViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<OnBoardingMenuViewControllerDelegate> delegate;
@end
