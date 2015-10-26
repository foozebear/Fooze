//
//  LogInViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "LogInViewController.h"
#import "Helper.h"
#import "Branch.h"

@interface LogInViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwEmail;
@property (strong, nonatomic) IBOutlet UIView *vwPassword;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UITextField *currentTextField;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.emailField.delegate = self;
    //self.passwordField.delegate = self;
    [Helper setPlaceholderColor:_tfEmail withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfPassword withColor:[UIColor foozePlaceHolder]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _btnLogin.useActivityIndicator = YES;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(done:)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex, doneButton, nil]];
    
    _tfEmail.inputAccessoryView = keyboardDoneButtonView;
    _tfPassword.inputAccessoryView = keyboardDoneButtonView;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Login", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [_tfEmail becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    _btnLogin.layer.cornerRadius = _btnLogin.frame.size.height/10.;
    _vwEmail.layer.cornerRadius = _vwEmail.frame.size.height/10.;
    _vwPassword.layer.cornerRadius = _vwPassword.frame.size.height/10.;
    
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        _btnLogin.enabled = YES;
        [_tfEmail becomeFirstResponder];
        [_btnLogin setBackgroundColor:[UIColor foozeOrange]];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfEmail)
    {
        [self.tfPassword becomeFirstResponder];
        [self adjustScrollToView:_vwPassword];
    }
    if (textField == self.tfPassword)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)login:(id)sender
{
    _btnLogin.enabled = NO;
    
    NSString *username = [self.tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length]== 0)
    {
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter the correct email and password!"];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
         {
             if (error)
             {
                 [[Appboy sharedInstance] logCustomEvent:@"Login - Failed"];
                 
                 [self showAlert:@"Sorry!" withMessage:[error.userInfo objectForKey:@"error"]];
                 _btnLogin.enabled = YES;
             }
             else
             {
                 [[Appboy sharedInstance] logCustomEvent:@"Login- Success"];
                 
                 PFUser *currentUser = [PFUser currentUser];
                 
                 if (currentUser)
                 {
                     //This is to register current user to AppBoy
                     [[Appboy sharedInstance] changeUser:currentUser.objectId];
                     [Appboy sharedInstance].user.firstName = [currentUser valueForKey:@"name"];
                     [Appboy sharedInstance].user.email = [currentUser valueForKey:@"email"];
                     [Appboy sharedInstance].user.country = @"US";
                     
                     if ([currentUser valueForKey:@"phoneNumber"])
                         [Appboy sharedInstance].user.phone = [currentUser valueForKey:@"phoneNumber"];
                     
                     NSDictionary *deliveryAddress = [currentUser valueForKey:@"deliveryAddress"];
                     if(deliveryAddress.count)
                     {
                         if (deliveryAddress[@"city"])
                             [Appboy sharedInstance].user.homeCity = deliveryAddress[@"city"];
    
                         if (deliveryAddress[@"streetaddress"])
                             [[Appboy sharedInstance].user setCustomAttributeWithKey:@"streetAddress" andStringValue:deliveryAddress[@"streetaddress"]];
                        
                         if (deliveryAddress[@"zip"])
                             [[Appboy sharedInstance].user setCustomAttributeWithKey:@"zipcode" andStringValue:deliveryAddress[@"zip"]];
                     }
                     
                     if ([currentUser valueForKey:@"cardNumber"])
                     {
                         NSString *card = [[currentUser valueForKey:@"cardNumber"] substringFromIndex:MAX((int)[[currentUser valueForKey:@"cardNumber"] length]-4, 0)];
                         [[Appboy sharedInstance].user setCustomAttributeWithKey:@"card" andStringValue:card];
                     }

                 }
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 [[Branch getInstance] setIdentity:_tfEmail.text];
             }
         }];
    }
    
    //BYPASS
    //    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:kLogged];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)back:(id)sender
{
    [self.delegate showWelcomeAgain:self];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)adjustScrollToView:(UIView *)view
{
    NSLog(@"y = %f", view.center.y);
    [_scrollView setContentOffset:CGPointMake(0,view.center.y - 50) animated:YES];
}

- (void)done:(id)sender
{
    if (_currentTextField == _tfEmail)
    {
        [_tfPassword becomeFirstResponder];
        [self adjustScrollToView:_vwPassword];
    }
    else
    {
        [_tfPassword resignFirstResponder];
    }
    
}

- (void)dismissKeyboard
{
    [_tfEmail resignFirstResponder];
    [_tfPassword resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    if (textField == _tfEmail)
    {
        _tfEmail.adjustsFontSizeToFitWidth = YES;
    }
    else if (textField == _tfPassword)
    {
        _tfPassword.adjustsFontSizeToFitWidth = YES;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self redefineFont:textField withString:string];
    
    return YES;
}

- (IBAction)touchDown:(id)sender
{
    [_btnLogin setBackgroundColor:[UIColor foozeBlue]];
}

- (IBAction)showForgotPassword:(id)sender
{
    [self performSegueWithIdentifier:@"segueToForgotPassword" sender:self];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField setFont:[UIFont fontWithName:@"Gotham-Book" size:23]];
    
    return YES;
}

- (void)redefineFont:(UITextField *)textField withString:(NSString *)string
{
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    int numChar = (int)textField.text.length;
    
    if (isBackSpace == -8) numChar--;
    else numChar++;
    if (numChar > 0) {
        [textField setFont:[UIFont fontWithName:@"Gotham-Medium" size:23]];
    }
    else
        [textField setFont:[UIFont fontWithName:@"Gotham-Book" size:23]];
}

@end
