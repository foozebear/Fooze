//
//  LoginSignupViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/16/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//


#import "LoginSignupViewController.h"
#import "ChooseViewController.h"
#import "Helper.h"

@interface LoginSignupViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewFoozeButton;


@property (strong, nonatomic) IBOutlet UIButton *btnFoozeAway;


@end

@implementation LoginSignupViewController
-(void)listFonts{
    
    for(NSString *familyName in [UIFont familyNames]){
        NSLog(@"Family name: %@", familyName);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]){
            NSLog(@"    Font name: %@", fontName);
        }
    }
    
}

- (void)makeOrderLabel
{
    CGRect frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width * .1, self.view.frame.size.height/5, self.view.frame.size.width * .8, self.view.frame.size.height/4);
    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
    textView.textAlignment = NSTextAlignmentCenter;
//    textView.text = @"We select three delicious munchies each night. Simply tap to order and your Fooze is on its way.";
    textView.text = @" We select several delicious munchies each night. Simply tap to order and your Fooze is on its way.";
    //[textView setBackgroundColor:[UIColor whiteColor]];

    [textView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.341 blue:0.169 alpha:1.0]];
    [textView setFont:[UIFont fontWithName:@"Gotham-Medium" size:20]];
    textView.textColor = [UIColor whiteColor];
    
    [self.view addSubview:textView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
      _btnFoozeAway.layer.cornerRadius = _btnFoozeAway.frame.size.height/4.;
}
-(void)viewDidLayoutSubviews{
   // [self makeButton];
//    [self makeLoginButton];
 //   [self makeOrderLabel];
    
    
    _viewFoozeButton.layer.cornerRadius = _viewFoozeButton.frame.size.height/4.;
    [self listFonts];
}

-(void)makeButton
{

    NSLog(@"check");
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button addTarget:self
               action:@selector(goCreateAccount)
     forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width * .4, self.view.frame.size.height * .75, self.view.frame.size.width * .8, self.view.frame.size.width/5);
    button.frame = rect;
    button.layer.cornerRadius = button.frame.size.height/4;
    
    button.backgroundColor = [UIColor colorWithRed:0 green:0.655 blue:0.655 alpha:1.0];
    [button setTitle:@"Go" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont fontWithName:@"Luckiest Guy" size:20]];

    
    [self.view addSubview:button];
     */
    
  
    
}

-(void)makeLoginButton
{
    
    NSLog(@"check");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button addTarget:self
               action:@selector(goLogin)
     forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height * .75 + self.view.frame.size.width/5, self.view.frame.size.width, self.view.frame.size.width/8);
    button.frame = rect;
    
    
    [button setTitle:@"Already have an account?" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Gotham-Medium" size:20]];
    [button setTintColor:[UIColor whiteColor]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    // button.alpha = 1.0;
    
    [self.view addSubview:button];
    // [self.view bringSubviewToFront:button];
    
}
-(void)goLogin{
    [self performSegueWithIdentifier:@"showLogin" sender:self];

}
-(void)goCreateAccount
{
    //[self performSegueWithIdentifier:@"showCreateAccount" sender:self];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goCreateAccount:(id)sender {
   //  [self performSegueWithIdentifier:@"showCreateAccount" sender:self];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [_viewFoozeButton setBackgroundColor:[UIColor foozeOrange]];

       [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"signup"]) {
        ChooseViewController *viewController = segue.destinationViewController;
        viewController.track = @"signupfood1";
    }
    if ([segue.identifier isEqualToString:@"login"]) {
    
        
        
    }
    
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
