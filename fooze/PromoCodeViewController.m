//
//  PromoCodeViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/31/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "PromoCodeViewController.h"
#import "Helper.h"

@interface PromoCodeViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *vwPromoCode;
@property (strong, nonatomic) IBOutlet UITextField *tfPromoCode;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;
@property (strong, nonatomic) NSString *promo_amount;
@property (nonatomic) long credit;
@end

@implementation PromoCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Helper setPlaceholderColor:_tfPromoCode withColor:[UIColor foozePlaceHolder]];
    
    _btnRedeem.useActivityIndicator = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
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
    
    _tfPromoCode.inputAccessoryView = keyboardDoneButtonView;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"PromoCode", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnRedeem setBackgroundColor:[UIColor foozeOrange80]];
    _btnRedeem.enabled = YES;
//    [_tfPromoCode becomeFirstResponder];
}


- (void)viewDidLayoutSubviews
{
    _vwPromoCode.layer.cornerRadius = _vwPromoCode.frame.size.height/10.;
    _btnRedeem.layer.cornerRadius = _btnRedeem.frame.size.height/10.;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"segueToPromoSuccess"])
    {
        PromoCodeSuccessViewController *vc = segue.destinationViewController;
        vc.promo_amount = _promo_amount;
        vc.delegate = self;
        vc.bSettings = _bSettings;
        vc.credit = _credit;
    }
}


- (void)dismissKeyboard
{
    [self.tfPromoCode resignFirstResponder];
}

- (void)adjustScrollToView:(UIView *)view
{
    //    CGRect frame = CGRectMake(0, textField.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    //    [self.scrollView scrollRectToVisible:frame animated:YES];
    NSLog(@"y = %f", view.center.y);
    [_scrollView setContentOffset:CGPointMake(0,view.center.y - 50) animated:YES];
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        _btnRedeem.enabled = YES;
        [_btnRedeem setBackgroundColor:[UIColor foozeOrange]];
        [_tfPromoCode becomeFirstResponder];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)done:(id)sender
{
    if (_currentTextField == _tfPromoCode)
    {
        [_btnRedeem setBackgroundColor:[UIColor foozeOrange]];
        [self dismissKeyboard];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfPromoCode)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    if (textField == self.tfPromoCode)
    {
        self.tfPromoCode.adjustsFontSizeToFitWidth = YES;
        [self adjustScrollToView:_vwPromoCode];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)redeemNow:(id)sender
{
    [self validatePromoCode];
}

- (void)validatePromoCode
{
    NSString *code = [_tfPromoCode.text uppercaseString];
    
    if (code.length > 0)
    {
        _btnRedeem.enabled = NO;
        
        [[Branch getInstance] validatePromoCode:code callback:^(NSDictionary *params, NSError *error) {
            if (!error) {
                if ([code isEqualToString:[params objectForKey:@"promo_code"]])
                {
                    // valid
                    NSLog(@"Congrats! Instant discount for you!");
                    
                    NSDictionary *metadata = [params objectForKey:@"metadata"];
                    _promo_amount = [metadata objectForKey:@"amount"];
                    
                    [[Appboy sharedInstance] logCustomEvent:@"Promo Code - Redeemed" withProperties:@{@"Amount":_promo_amount}];
                    
                    [self applyPromoCode:code withAmount:_promo_amount];
                }
                else
                {
                    [[Appboy sharedInstance] logCustomEvent:@"Promo Code - Invalid" withProperties:@{@"PromoCode":self.tfPromoCode.text}];
                    
                    [self showAlert:@"Invalid" withMessage:@"Invalid promo code."];
                    // invalid (should never happen)
                }
            }
            else
            {
                [[Appboy sharedInstance] logCustomEvent:@"Promo Code - Failed" withProperties:@{@"PromoCode":self.tfPromoCode.text}];
                
                [self showAlert:@"Error" withMessage:@"Error validating promo code."];
                NSLog(@"Error in validating promo code: %@", error.localizedDescription);
            }
        }];
    }
    else
    {
       [self showAlert:@"Oops" withMessage:@"Please enter promo code."];
    }
    
}

- (void)applyPromoCode:(NSString *)code withAmount:(NSString *)amount
{
    [[Branch getInstance] applyPromoCode:code callback:^(NSDictionary *params, NSError *error) {
        if (!error)
        {
            // applied. you can get the promo code amount from the params and deduct it in your UI.
            NSLog(@"applied promo code with params: %@", params);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:amount forKey:@"promo_amount"];
            [defaults synchronize];
            
            [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *err) {
                if (!err)
                {
                    _credit = [[Branch getInstance] getCredits];
                    [self performSegueWithIdentifier:@"segueToPromoSuccess" sender:self];
                }
            }];
            
            
        }
        else
        {
            NSLog(@"Error in applying promo code: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)touchDownRedeem:(id)sender
{
    [_btnRedeem setBackgroundColor:[UIColor foozeBlue]];
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

#pragma mark -
#pragma mark - PromoCodeSuccessViewController

- (void)goBackToConfirmViewFromPromoCodeSuccess:(PromoCodeSuccessViewController *)controller withCredit:(float)credit
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate goBackToConfirmView:self withCredit:credit];
}

@end
