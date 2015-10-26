//
//  LogInViewController.h
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class LogInViewController;
@protocol LogInViewControllerDelegate <NSObject>

- (void)showWelcomeAgain:(LogInViewController *) controller;

@end

@interface LogInViewController : UIViewController

@property (nonatomic,strong) id<LogInViewControllerDelegate> delegate;

@end
