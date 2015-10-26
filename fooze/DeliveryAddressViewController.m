//
//  DeliveryAddressViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/17/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import "PaymentViewController.h"
//#import "AFNetworking.h"
#import <Parse/Parse.h>
#import "Helper.h"
#import "UIColor+Extended.h"

@interface DeliveryAddressViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwStreet;
@property (strong, nonatomic) IBOutlet UIView *vwUnit;
@property (strong, nonatomic) IBOutlet UIView *vwZipcode;
@property (strong, nonatomic) IBOutlet UIView *vwPhone;
@property (strong, nonatomic) IBOutlet UIView *vwInstruction;
@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfUnit;
@property (strong, nonatomic) IBOutlet UITextField *tfZip;
@property (strong, nonatomic) IBOutlet UITextField *tfPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UITextField *tfInstruct;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

@property (strong, nonatomic) IBOutlet UIButton *btnInstruct;
//@property (strong, nonatomic) UITextField *activeField;
@end

@implementation DeliveryAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Helper setPlaceholderColor:_tfName withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfUnit withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfZip withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfPhone withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfInstruct withColor:[UIColor foozePlaceHolder]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
       
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swiperight];

    _btnNext.useActivityIndicator = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
//        [currentUser fetch];
        NSDictionary *dicAddress = [currentUser valueForKey:@"deliveryAddress"];
        
        if(dicAddress.count)
        {
            _tfName.text = dicAddress[@"streetaddress"];
            _tfUnit.text = dicAddress[@"unit"];
            _tfZip.text = dicAddress[@"zip"];
            _tfPhone.text = [currentUser valueForKey:@"phoneNumber"];
            _tfInstruct.text = [currentUser valueForKey:@"specialInstruction"];
        }
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Delivery Address", @"Page", nil];
        [Flurry logEvent:@"Settings" withParameters:params];
    }
    else
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Delivery Address", @"Page", nil];
        [Flurry logEvent:@"Views" withParameters:params];
    }
    
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
    
    _tfName.inputAccessoryView = keyboardDoneButtonView;
    _tfUnit.inputAccessoryView = keyboardDoneButtonView;
    _tfPhone.inputAccessoryView = keyboardDoneButtonView;
    _tfZip.inputAccessoryView = keyboardDoneButtonView;
    _tfInstruct.inputAccessoryView = keyboardDoneButtonView;
    
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_updateMode)
    {
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    }
    else
    {
        [_tfName becomeFirstResponder];
        [_btnNext setBackgroundColor:[UIColor foozeOrange80]];
    }
}

- (void)viewDidLayoutSubviews
{
    _vwStreet.layer.cornerRadius = _btnNext.frame.size.height/10.;
    _vwUnit.layer.cornerRadius = _vwUnit.frame.size.height/10.;
    _vwPhone.layer.cornerRadius = _vwPhone.frame.size.height/10.;
    _vwZipcode.layer.cornerRadius = _vwZipcode.frame.size.height/10.;
    _vwInstruction.layer.cornerRadius = _vwInstruction.frame.size.height/10.;
    _btnNext.layer.cornerRadius = _btnNext.frame.size.height/10.;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToCard"])
    {
        PaymentViewController *vc = segue.destinationViewController;
//        vc.delegate = self;
        vc.username = self.username;
        vc.password = self.password;
        vc.name = self.name;
        
        vc.streetName = self.tfName.text;
        vc.unit = self.tfUnit.text;
        vc.zipcode = self.tfZip.text;
        vc.phonenumber = self.tfPhone.text;
        vc.specialinstruction = self.tfInstruct.text;
    }
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        _btnNext.enabled = YES;
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
        [_currentTextField becomeFirstResponder];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfName)
    {
        [self.tfUnit becomeFirstResponder];
        [self adjustScrollToView:_vwUnit];
    }
    if (textField == self.tfUnit)
    {
        [self.tfZip becomeFirstResponder];
        [self adjustScrollToView:_vwZipcode];
    }
    if (textField == self.tfZip)
    {
        [self.tfPhone becomeFirstResponder];
        [self adjustScrollToView:_vwPhone];
    }
    if (textField == self.tfPhone)
    {
        [self.tfInstruct becomeFirstResponder];
        [self adjustScrollToView:_vwInstruction];
    }
    if (textField == self.tfInstruct)
    {
        [textField resignFirstResponder];
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    }
    
    return YES;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAddress:(id)sender
{
//TODO: Temp for debug
//    [self performSegueWithIdentifier:@"segueToCard" sender:self];
//    return;
//End
    
    [self proceed];
}

- (void)proceed
{
    [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    _btnNext.enabled = NO;
    
    if(_tfName.text.length <= 5)
    {
        _currentTextField = _tfName;
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter your street address."];
        return;
    }
    
    if(_tfZip.text.length < 5)
    {
        _currentTextField = _tfZip;
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter your zip code."];
        return;
    }
    
    if(_tfPhone.text.length < 12)
    {
        _currentTextField = _tfPhone;
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter a phone number in the format 555-555-5555"];
        return;
    }
    
    [self saveUserDefaults];
    
    [self updateAddress:_updateMode];
    
    /*
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser)
    {
        [self updateAddress:YES];
    }
    else
    {
        [self updateAddress:NO];
//        _btnNext.enabled = YES;
//        [self performSegueWithIdentifier:@"segueToCard" sender:self];
        //[self signUpNow:paymentAddress];
    }
     */

}

- (void)updateAddress:(BOOL)updateMode
{
    NSMutableDictionary *deliveryAddress = [[NSMutableDictionary alloc]init];
    
    [deliveryAddress setObject:self.tfName.text forKey:@"streetaddress"];
    [deliveryAddress setObject:self.tfUnit.text forKey:@"unit"];
    [deliveryAddress setObject:@"New York City" forKey:@"city"];
    [deliveryAddress setObject:self.tfZip.text forKey:@"zip"];
    
    PFUser *user =  [PFUser currentUser];
    [user setObject:deliveryAddress forKey:@"deliveryAddress"];
    [user setObject:_tfPhone.text forKey:@"phoneNumber"];
    [user setObject:_tfInstruct.text forKey:@"specialInstruction"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            [[Appboy sharedInstance] logCustomEvent:@"Signup Page 2 - Success"];
            
            //This is to register current user to AppBoy
            [Appboy sharedInstance].user.phone = _tfPhone.text;
            [[Appboy sharedInstance].user setCustomAttributeWithKey:@"streetAddress" andStringValue:self.tfName.text];
            [[Appboy sharedInstance].user setCustomAttributeWithKey:@"zipcode" andStringValue:self.tfZip.text];
            
            [Appboy sharedInstance].user.country = @"US";
            
            _btnNext.enabled = YES;
            if (updateMode)
                [self.navigationController popToRootViewControllerAnimated:YES];
            else
                [self performSegueWithIdentifier:@"segueToCard" sender:self];
            
        }
        else
        {
            [[Appboy sharedInstance] logCustomEvent:@"Signup Page 2 - Failed"];
            
            [self showAlert:@"Sorry!" withMessage:[error.userInfo objectForKey:@"error"]];
            _btnNext.enabled = YES;
        }
    }];
}

- (void)saveUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_tfName.text forKey:@"address"];
    [defaults setValue:_tfZip.text forKey:@"zipcode"];
    [defaults setValue:_tfUnit.text forKey:@"unit"];
    
    [defaults synchronize];
}

- (void)dismissKeyboard
{
    [self.tfName resignFirstResponder];
    [self.tfUnit resignFirstResponder];
    [self.tfZip resignFirstResponder];
    [self.tfPhone resignFirstResponder];
    [self.tfInstruct resignFirstResponder];
    
    if (_tfName.text.length > 0 && _tfInstruct.text.length > 0 && _tfPhone.text.length > 0 && _tfZip.text.length > 0)
    {
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    }
    else
        [_btnNext setBackgroundColor:[UIColor foozeOrange80]];
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self proceed];
//    [self performSegueWithIdentifier:@"segueToCard" sender:self];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)adjustScroll:(UITextField *)textField
//{
////    CGRect frame = CGRectMake(0, textField.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
////    [self.scrollView scrollRectToVisible:frame animated:YES];
//    NSLog(@"centerY = %f", textField.center.y);
//    if (textField == _tfInstruct) {
//        [_scrollView setContentOffset:CGPointMake(0,textField.center.y + 200) animated:YES];
//    }
//    else
//        [_scrollView setContentOffset:CGPointMake(0,textField.center.y + 50) animated:YES];
//}

- (void)adjustScrollToView:(UIView *)view
{
    NSLog(@"y = %f", view.center.y);
    [_scrollView setContentOffset:CGPointMake(0,view.center.y - 50) animated:YES];
}

- (void)done:(id)sender
{
//    [self dismissKeyboard];
    if (_currentTextField == _tfName)
    {
        [_tfUnit becomeFirstResponder];
        [self adjustScrollToView:_vwUnit];
//        [self adjustScroll:_tfUnit];
    }
    else if (_currentTextField == _tfUnit)
    {
        [_tfZip becomeFirstResponder];
        [self adjustScrollToView:_vwZipcode];
//        [self adjustScroll:_tfZip];
    }
    else if (_currentTextField == _tfZip)
    {
        [_tfPhone becomeFirstResponder];
        [self adjustScrollToView:_vwPhone];
//        [self adjustScroll:_tfPhone];
    }
    else if (_currentTextField == _tfPhone)
    {
        [_tfInstruct becomeFirstResponder];
        [self adjustScrollToView:_vwInstruction];
//        [self adjustScroll:_tfInstruct];
    }
    else
    {
        [self dismissKeyboard];
    }
}

- (IBAction)touchDown:(id)sender
{
    [_btnNext setBackgroundColor:[UIColor foozeBlue]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    if (textField == self.tfName)
    {
        self.tfName.adjustsFontSizeToFitWidth = YES;
    }
    else if (textField == self.tfInstruct)
    {
        self.tfInstruct.adjustsFontSizeToFitWidth = YES;
    }

}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self redefineFont:textField withString:string];
    
    if(textField == _tfZip)
    {
        if (textField.text.length > 4 && range.length == 0)
            return NO;
    }
    else if(textField == _tfPhone)
    {
        //555-555-5555

        if (textField.text.length > 11 && range.length == 0) {
            return NO;
        }
        
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            return YES;
        }
        else
        {
            if (textField.text.length == 3) {
                //textField.text = [NSString stringWithFormat:@"(%@)-%@",[textField.text substringToIndex:3],[textField.text substringFromIndex:3]];
                textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:3],[textField.text substringFromIndex:3]];
            }
            if (textField.text.length == 7) {
                textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:7],[textField.text substringFromIndex:7]];
            }
        }
        return YES;
    }
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

//- (void)proceedToFoozeHome:(ConfirmViewController *) controller
//{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self.delegate proceedToFoozeHome:self];
//    }];
//}

@end
