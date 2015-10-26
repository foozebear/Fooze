//
//  SettingsViewController.m
//  Fooze
//
//  Created by Alex Russell on 5/27/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "PaymentViewController.h"
#import "TermsViewController.h"
#import "HelpViewController.h"
#import "DeliveryAddressViewController.h"
#import "SignUpViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnHelp;
@property (strong, nonatomic) IBOutlet UIButton *btnTerms;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnMunchies;
@property (strong, nonatomic) IBOutlet UIButton *btnPromoCode;
@property (strong, nonatomic) PFUser *currentUser;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _btnLogout.useActivityIndicator = YES;
    
    _currentUser = [PFUser currentUser];
    if (_currentUser)
    {
        [_btnLogout setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else
        [_btnLogout setTitle:@"Login" forState:UIControlStateNormal];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Settings", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnAddress setBackgroundColor:[UIColor foozeOrange]];
    [_btnPayment setBackgroundColor:[UIColor foozeOrange]];
    [_btnHelp setBackgroundColor:[UIColor foozeOrange]];
    [_btnTerms setBackgroundColor:[UIColor foozeOrange]];
    [_btnLogout setBackgroundColor:[UIColor foozeOrange]];
    [_btnMunchies setBackgroundColor:[UIColor foozeOrange]];
    [_btnPromoCode setBackgroundColor:[UIColor foozeOrange]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _btnLogout.enabled = YES;
    
    if (_iSettingsMode == 1)
    {
        [self showAddressSettings];
        _iSettingsMode = 0;
    }
    else if (_iSettingsMode == 2)
    {
        [self showPaymentSettings];
        _iSettingsMode = 0;
    }
}

- (void)viewDidLayoutSubviews
{
    _btnAddress.layer.cornerRadius = _btnAddress.frame.size.height/10.;
    _btnPayment.layer.cornerRadius = _btnPayment.frame.size.height/10.;
    _btnHelp.layer.cornerRadius = _btnHelp.frame.size.height/10.;
    _btnTerms.layer.cornerRadius = _btnTerms.frame.size.height/10.;
    _btnLogout.layer.cornerRadius = _btnLogout.frame.size.height/10.;
    _btnMunchies.layer.cornerRadius = _btnMunchies.frame.size.height/10.;
    _btnPromoCode.layer.cornerRadius = _btnPromoCode.frame.size.height/10.;
}

- (void)showAlert:(NSString *)title withMsg:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)showAddressSettings
{
    //    PFUser *currentUser = [PFUser currentUser];
    if (_currentUser)
    {
        DeliveryAddressViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryAddressViewController"];
        vc.updateMode = YES;
        [self showViewController:vc sender:self];
    }
    else
    {
        SignUpViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)showPaymentSettings
{
    //    PFUser *currentUser = [PFUser currentUser];
    if (_currentUser)
    {
        PaymentViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        vc.updateMode = YES;
        [self showViewController:vc sender:self];
    }
    else
    {
        SignUpViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)goPayment:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Settings" withProperties:@{@"Page":@"Payment"}];
    
    [_btnPayment setBackgroundColor:[UIColor foozeOrange]];
    
    [self showPaymentSettings];
}

- (IBAction)goAddress:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Settings" withProperties:@{@"Page":@"Address"}];
    
    [_btnAddress setBackgroundColor:[UIColor foozeOrange]];
   
    [self showAddressSettings];
 
}

- (IBAction)goHelp:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Settings" withProperties:@{@"Page":@"Help"}];
    
    [self performSegueWithIdentifier:@"segueToHelp" sender:self];
}

- (IBAction)goTerms:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Settings" withProperties:@{@"Page":@"Terms"}];
    
    [self performSegueWithIdentifier:@"showTerms" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToPromoCode"])
    {
        PromoCodeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.bSettings = YES;
        
    }
////    if ([segue.identifier isEqualToString:@"segueToHelp"])
////    {
////        HelpViewController *viewcontroller = segue.destinationViewController;
//////        viewcontroller.type = @"FAQ";
////        
////    }
}

- (IBAction)logout:(id)sender
{
    [_btnLogout setBackgroundColor:[UIColor foozeOrange]];
//    PFUser *currentUser = [PFUser currentUser];
    if (_currentUser)
    {
        [[Appboy sharedInstance] logCustomEvent:@"Logout"];
        
        _btnLogout.enabled = NO;
        [PFUser logOut];
        [[Branch getInstance] logout];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [defaults dictionaryRepresentation];
        for (id key in dict) {
            [defaults removeObjectForKey:key];
            NSLog(@"key = %@", key);
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [defaults setValue:0 forKey:@"alarm_badge"];
//        [defaults setValue:@"0" forKey:@"changeUser"];
        [defaults synchronize];

//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.delegate showWelcomeScreen:self];
    }
//    else
//    {
////        [self.navigationController popViewControllerAnimated:NO];
////        [self.delegate showLogin:self];
//        LogInViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
//        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        vc.delegate = self;
//        [self presentViewController:vc animated:YES completion:nil];
//    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)freeMunchies:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Settings" withProperties:@{@"Page":@"Munchies"}];
    
//    if (_currentUser)
        [self performSegueWithIdentifier:@"segueToMunchies" sender:self];
//    else
//        [self showAlert:@"Registration Error" withMsg:@"Please login or ."];
}


- (IBAction)promoCode:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Settings" withProperties:@{@"Page":@"Promo Code"}];
    
    [self performSegueWithIdentifier:@"segueToPromoCode" sender:self];
}


- (IBAction)touchDownPromoCode:(id)sender
{
    [_btnPromoCode setBackgroundColor:[UIColor foozeBlue]];
}


- (IBAction)touchDownMunchies:(id)sender
{
    [_btnMunchies setBackgroundColor:[UIColor foozeBlue]];
}

- (IBAction)touchDownAddress:(id)sender
{
    [_btnAddress setBackgroundColor:[UIColor foozeBlue]];
}


- (IBAction)touchDownPayment:(id)sender
{
    [_btnPayment setBackgroundColor:[UIColor foozeBlue]];
}


- (IBAction)touchDownHelp:(id)sender
{
    [_btnHelp setBackgroundColor:[UIColor foozeBlue]];
}


- (IBAction)touchDownTerms:(id)sender
{
    [_btnTerms setBackgroundColor:[UIColor foozeBlue]];
}


- (IBAction)touchDownLogin:(id)sender
{
     [_btnLogout setBackgroundColor:[UIColor foozeBlue]];
}


//#pragma mark -
//#pragma mark - LoginViewController
//
//- (void)continueToMain:(LogInViewController *)controller
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//}

@end
