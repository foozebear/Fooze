//
//  PaymentViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/27/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "PaymentViewController.h"
#import "DeliveryAddressViewController.h"
#import "Helper.h"
#import "ConfirmViewController.h"
#import "BillingViewController.h"

#define kLEGAL @"/1234567890"

@interface PaymentViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tfCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *tfCardName;
@property (strong, nonatomic) IBOutlet UITextField *tfExpire;
@property (strong, nonatomic) IBOutlet UITextField *tfCVC;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIView *viewCardName;
@property (strong, nonatomic) IBOutlet UIView *viewCardNumber;
@property (strong, nonatomic) IBOutlet UIView *viewExpire;
@property (strong, nonatomic) IBOutlet UIView *viewCvw;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblPoweredBy;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;
//@property(weak, nonatomic) PTKView *paymentView;
@end


@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Helper setPlaceholderColor:_tfCardName withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfCardNumber withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfExpire withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfCVC withColor:[UIColor foozePlaceHolder]];
        
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
    [currentUser fetch];
    
    if(currentUser)
    {
//        [currentUser fetch];
        NSString *cardNumber = [currentUser valueForKey:@"cardNumber"];
        
        if (cardNumber.length > 4) {
            NSString *cardNumber1 = [cardNumber substringWithRange:NSMakeRange(0, 4)];
            NSString *cardNumber2 = [cardNumber substringWithRange:NSMakeRange(4, 4)];
            NSString *cardNumber3 = [cardNumber substringWithRange:NSMakeRange(8, 4)];
            
            NSString *cardNumber4;
            if (cardNumber.length == 16)
                cardNumber4 = [cardNumber substringWithRange:NSMakeRange(12, 4)];
            else
                cardNumber4 = [cardNumber substringWithRange:NSMakeRange(12, 3)];
            
            cardNumber1 = cardNumber2 = cardNumber3 = @"****";
            _tfCardNumber.text = [NSString stringWithFormat:@"%@-%@-%@-%@", cardNumber1, cardNumber2, cardNumber3, cardNumber4 ];
        }

        _tfCardName.text = [currentUser valueForKey:@"cardName"];
        _tfExpire.text = [currentUser valueForKey:@"cardExpiry"];
        _tfCVC.text = [currentUser valueForKey:@"cardCVC"];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Payment Info", @"Page", nil];
        [Flurry logEvent:@"Settings" withParameters:params];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _tfCardName.text = [defaults valueForKey:@"name"];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Payment Info", @"Page", nil];
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

    _tfCardName.inputAccessoryView = keyboardDoneButtonView;
    _tfCardNumber.inputAccessoryView = keyboardDoneButtonView;
    _tfCVC.inputAccessoryView = keyboardDoneButtonView;
    _tfExpire.inputAccessoryView = keyboardDoneButtonView;

    
}

- (void)viewDidLayoutSubviews
{
    //RMB
//    PTKView *view = [[PTKView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.center.y,290,55)];
//    self.paymentView = view;
//    self.paymentView.delegate = self;
//    [self.paymentView setTintColor:[UIColor whiteColor]];
//    [self.view bringSubviewToFront:view];
//    [self.view addSubview:self.paymentView];
    //RMB
  // [self makeButtonSaveCard];
//    [self makeBackButton];
    
    
    _btnNext.layer.cornerRadius = _btnNext.frame.size.height/10.;
     _viewCardName.layer.cornerRadius = _viewCardName.frame.size.height/10.;
     _viewCardNumber.layer.cornerRadius = _viewCardNumber.frame.size.height/10.;
     _viewExpire.layer.cornerRadius = _viewExpire.frame.size.height/10.;
     _viewCvw.layer.cornerRadius = _viewCvw.frame.size.height/10.;
 
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
        [_tfCardNumber becomeFirstResponder];
        [_btnNext setBackgroundColor:[UIColor foozeOrange80]];        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)showAlert:(NSString *)title withMsg:(NSString *)msg
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

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToBilling"])
    {
        BillingViewController *vc = segue.destinationViewController;
//        vc.delegate = self;
        vc.username = self.username;
        vc.password = self.password;
        vc.name = self.name;
        vc.specialinstruction = self.specialinstruction;
        
        vc.streetName = self.streetName;
        vc.unit = self.unit;
        vc.zipcode = self.zipcode;
        vc.phonenumber = self.phonenumber;
        
        vc.cardname = _tfCardName.text;
        vc.cardNumber = _tfCardNumber.text;
        vc.cardExpiry = _tfExpire.text;
        vc.cardCVC = _tfCVC.text;
    }
    
}

- (IBAction)saveCard:(id)sender
{
//TODO: Temp for debug
//    [self performSegueWithIdentifier:@"showConfirm" sender:self];
//    return;
//End
    
    [self proceed];
    
}

- (void)proceed
{
    [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    
    if(_tfCardNumber.text.length < 18)
    {
        _currentTextField = _tfCardNumber;
        [self showAlert:@"Oops!" withMsg:@"Make sure you enter your correct card number."];
        return;
    }

    if(_tfCardName.text.length <= 1)
    {
        _currentTextField = _tfCardName;
        [self showAlert:@"Oops!" withMsg:@"Make sure you enter your name on your credit card."];
        return;
    }
    
    if(_tfExpire.text.length < 7)
    {
        _currentTextField = _tfExpire;
        [self showAlert:@"Oops!" withMsg:@"Make sure you enter the correct expiry date format."];
        return;
    }
    
    if(_tfCVC.text.length < 3)
    {
        _currentTextField = _tfCVC;
        [self showAlert:@"Oops!" withMsg:@"Please enter CVC number."];
        return;
    }
    
    NSArray *dates = [_tfExpire.text componentsSeparatedByString:@"/"];
    
    if ([dates count] == 0)
    {
        _currentTextField = _tfExpire;
        [self showAlert:@"Oops!" withMsg:@"Make sure you enter the correct expiry date format."];
        return;
    }
    
    
    int expMonth = [[dates objectAtIndex:0] intValue];
    int expYear = [[dates objectAtIndex:1] intValue];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    int month = (int)[dateComponents month];
    int year = (int)[dateComponents year];

    if ((expMonth < month && expYear == year) || (expYear < year) || (expYear - year > 10) || (expMonth > 12))
    {
        _currentTextField = _tfExpire;
        [self showAlert:@"Oops!" withMsg:@"Make sure you enter the correct expiry date."];
        return;
    }

    _btnNext.enabled = NO;
    
    [self updateUserBillingInfoNow:_updateMode];
    
    /*
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        [self updateUserBillingInfoNow:YES];
    }
    else
    {
        [self updateUserBillingInfoNow:NO];
        
//        [self submitUserDataNow];
    }
     */
    
//    [self performSegueWithIdentifier:@"segueToBilling" sender:self];
    
}

/*
- (void)submitUserDataNow
{
    NSMutableDictionary *deliveryAddress = [[NSMutableDictionary alloc]init];
    
    [deliveryAddress setObject:self.streetName forKey:@"streetaddress"];
    [deliveryAddress setObject:self.unit forKey:@"unit"];
    [deliveryAddress setObject:@"New York City" forKey:@"city"];
    [deliveryAddress setObject:self.zipcode forKey:@"zip"];
    
    NSMutableDictionary *paymentAddress = [[NSMutableDictionary alloc]init];
    
    [paymentAddress setObject:self.streetName forKey:@"streetaddress"];
    [paymentAddress setObject:self.unit forKey:@"unit"];
    [paymentAddress setObject:@"New York City" forKey:@"city"];
    [paymentAddress setObject:self.zipcode forKey:@"zip"];
    
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.username;
    newUser.password = self.password;
    newUser.email = self.username;
    [newUser setObject:self.name forKey:@"name"];
    [newUser setObject:self.phonenumber forKey:@"phoneNumber"];
    
    [newUser setObject:self.tfCardName.text forKey:@"cardName"];
    [newUser setObject:[self.tfCardNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"cardNumber"];
    [newUser setObject:self.tfCVC.text forKey:@"cardCVC"];
    [newUser setObject:self.tfExpire.text forKey:@"cardExpiry"];
    [newUser setObject:self.specialinstruction forKey:@"specialInstruction"];
    
    [newUser setObject:deliveryAddress forKey:@"deliveryAddress"];
    [newUser setObject:paymentAddress forKey:@"paymentAddress"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            _btnNext.enabled = YES;
            [self performSegueWithIdentifier:@"showConfirm" sender:self];
//            [[Branch getTestInstance] setIdentity:self.username];
        }
        else
        {
            [self showAlert:@"Sorry!" withMsg:[error.userInfo objectForKey:@"error"]];
            _btnNext.enabled = YES;
        }
    }];
}
 */

- (void)updateUserBillingInfoNow:(BOOL)updateMode
{
    PFUser *currentUser =  [PFUser currentUser];

    if (!updateMode)
    {
        NSMutableDictionary *paymentAddress = [[NSMutableDictionary alloc]init];
        
        [paymentAddress setObject:self.streetName forKey:@"streetaddress"];
        [paymentAddress setObject:self.unit forKey:@"unit"];
        [paymentAddress setObject:@"New York City" forKey:@"city"];
        [paymentAddress setObject:self.zipcode forKey:@"zip"];

        [currentUser setObject:paymentAddress forKey:@"paymentAddress"];
    }
    
    NSString *cardNumber;
    
    NSRange found = [self.tfCardNumber.text rangeOfString:@"*"];
    if (found.location != NSNotFound)
        cardNumber = [currentUser valueForKey:@"cardNumber"];
    else
        cardNumber = [self.tfCardNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
 
    [currentUser setObject:cardNumber forKey:@"cardNumber"];
    [currentUser setObject:self.tfCardName.text forKey:@"cardName"];
    [currentUser setObject:self.tfCVC.text forKey:@"cardCVC"];
    [currentUser setObject:self.tfExpire.text forKey:@"cardExpiry"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             [[Appboy sharedInstance] logCustomEvent:@"Signup Page 3 - Success"];
             
             NSString *card = [cardNumber substringFromIndex:MAX((int)[cardNumber length]-4, 0)];
             
             [[Appboy sharedInstance].user setCustomAttributeWithKey:@"card" andStringValue:card];
             
             _btnNext.enabled = YES;
             if (updateMode)
                 [self.navigationController popToRootViewControllerAnimated:YES];
             else
                 [self performSegueWithIdentifier:@"showConfirm" sender:self];
         }
         else
         {
             [[Appboy sharedInstance] logCustomEvent:@"Signup Page 3 - Failed"];
             
             [self showAlert:@"Sorry!" withMsg:[error.userInfo objectForKey:@"error"]];
             _btnNext.enabled = YES;
         }
     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfCardNumber)
    {
        [self.tfCardName becomeFirstResponder];
    }
    if (textField == self.tfCardName)
    {
        [self.tfExpire becomeFirstResponder];
    }
    if (textField == self.tfExpire)
    {
        [self.tfCVC becomeFirstResponder];
    }
    if (textField == self.tfCVC)
    {
        [textField resignFirstResponder];
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    if (textField == self.tfCardName)
    {
        self.tfCardName.adjustsFontSizeToFitWidth = YES;
    }
    if (textField == self.tfCardNumber)
    {
        self.tfCardNumber.adjustsFontSizeToFitWidth = YES;
    }
}

- (IBAction)touchDown:(id)sender
{
    [_btnNext setBackgroundColor:[UIColor foozeBlue]];
}

- (void)showPoweredBy
{
    NSURL *url = [NSURL URLWithString:@"https://stripe.com"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);

}

- (void)dismissKeyboard
{
    [self.tfCardName resignFirstResponder];
    [self.tfCardNumber resignFirstResponder];
    [self.tfExpire resignFirstResponder];
    [self.tfCVC resignFirstResponder];
    
    if (_tfCardName.text.length > 0 && _tfCardNumber.text > 0 && _tfCVC.text.length > 0 && _tfExpire.text.length > 0) {
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    }
    else
        [_btnNext setBackgroundColor:[UIColor foozeOrange80]];
    
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self proceed];
//    [self performSegueWithIdentifier:@"segueToBilling" sender:self];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)adjustScroll:(UITextField *)textField
//{
//    //    CGRect frame = CGRectMake(0, textField.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//    //    [self.scrollView scrollRectToVisible:frame animated:YES];
//    NSLog(@"centerY = %f", textField.center.y);
//    if (textField == _tfCVC) {
//        [_scrollView setContentOffset:CGPointMake(0,textField.center.y + 100) animated:YES];
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
    if (_currentTextField == _tfCardNumber)
    {
        [_tfCardName becomeFirstResponder];
        [self adjustScrollToView:_viewCardName];
//        [self adjustScroll:_tfCardName];
    }
    else if (_currentTextField == _tfCardName)
    {
        [_tfExpire becomeFirstResponder];
        [self adjustScrollToView:_viewExpire];
//        [self adjustScroll:_tfExpire];
    }
    else if (_currentTextField == _tfExpire)
    {
        [_tfCVC becomeFirstResponder];
        [self adjustScrollToView:_viewCvw];
//        [self adjustScroll:_tfCVC];
    }
    else
    {
        [self dismissKeyboard];
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kLEGAL] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    return [string isEqualToString:filtered];
//}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self redefineFont:textField withString:string];
    
    if(textField == _tfCardNumber)
    {
        //1234-5678-9012-3456
        if (textField.text.length > 18 && range.length == 0)
            return NO;
        
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            return YES;
        }
        else
        {
            if (textField.text.length == 4)
            {
                textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:4],[textField.text substringFromIndex:4]];
            }
            else if (textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:9],[textField.text substringFromIndex:9]];
            }
            else if (textField.text.length == 14) {
                textField.text = [NSString stringWithFormat:@"%@-%@",[textField.text substringToIndex:14],[textField.text substringFromIndex:14]];
            }
        }
    }
    else if(textField == _tfExpire)
    {
        if (textField.text.length > 6 && range.length == 0)
            return NO;
        
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8)
        {
            return YES;
        }
        else
        {
            if (textField.text.length == 2)
            {
                textField.text = [NSString stringWithFormat:@"%@/%@",[textField.text substringToIndex:2],[textField.text substringFromIndex:2]];
            }

            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kLEGAL] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
        }
    }
    else if(textField == _tfCVC)
    {
        if (textField.text.length > 3 && range.length == 0)
            return NO;
        
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
