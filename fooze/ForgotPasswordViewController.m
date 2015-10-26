//
//  ForgotPasswordViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/20/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Helper.h"
#import <Parse/Parse.h>

@interface ForgotPasswordViewController ()
@property (strong, nonatomic) IBOutlet UIView *vwEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnEmailMe;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) BOOL bSuccess;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Helper setPlaceholderColor:_tfEmail withColor:[UIColor foozePlaceHolder]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _bSuccess = NO;
    _btnEmailMe.useActivityIndicator = YES;
    [_tfEmail becomeFirstResponder];

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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Forgot Password", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adjustScrollToView:_vwEmail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewDidLayoutSubviews
{
    _btnEmailMe.layer.cornerRadius = _btnEmailMe.frame.size.height/10.;
    _vwEmail.layer.cornerRadius = _vwEmail.frame.size.height/10.;
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    [self dismissKeyboard];
    
    [alert alertIsDismissed:^{
        if (_bSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            _btnEmailMe.enabled = YES;
            [_tfEmail becomeFirstResponder];
            [_btnEmailMe setBackgroundColor:[UIColor foozeOrange]];
        }
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)done:(id)sender
{
    [_tfEmail resignFirstResponder];
}

- (void)dismissKeyboard
{
    [self.tfEmail resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _tfEmail.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchDownEmailMe:(id)sender
{
    [_btnEmailMe setBackgroundColor:[UIColor foozeBlue]];
}

- (IBAction)emailMe:(id)sender
{
    if (_tfEmail.text.length < 5)
    {
        [self showAlert:@"Oops" withMessage:@"Please enter a valid email address."];
        return;
    }
    
    if ([_tfEmail.text rangeOfString:@"@"].location == NSNotFound)
    {
        [self showAlert:@"Oops" withMessage:@"Please enter a valid email address."];
        return;
    }
    
    _btnEmailMe.enabled = NO;

    //[PFUser requestPasswordResetForEmailInBackground:_tfEmail.text];
    [PFUser requestPasswordResetForEmailInBackground:_tfEmail.text block:^(BOOL succeeded, NSError *error)
    {
        if(!error)
        {
            _bSuccess = TRUE;
            [self showAlert:@"Success!" withMessage:@"Please check your email for your password reset link."];
        }
        else
        {
            _bSuccess = FALSE;
            [self showAlert:@"Oops" withMessage:@"Error reseting email. Please enter the email address you registered."];
            NSLog(@"Error = %@", [error description]);
           //NSLog(@"%@-%@", [error description], error.code]);
        }
    }];
    
}

- (void)adjustScrollToView:(UIView *)view
{
    [_scrollView setContentOffset:CGPointMake(0,view.center.y - 50) animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self redefineFont:textField withString:string];
    
    return YES;
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
