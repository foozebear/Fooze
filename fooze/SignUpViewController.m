//
//  SignUpViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "SignUpViewController.h"
#import "DeliveryAddressViewController.h"
#import "Helper.h"
#import "UIColor+Extended.h"
#import "Branch.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwName;
@property (strong, nonatomic) IBOutlet UIView *vwEmail;
@property (strong, nonatomic) IBOutlet UIView *vwPassword;
@property (strong, nonatomic) IBOutlet UIView *vwPassword2;

@property (strong, nonatomic) IBOutlet UITextField *tfConfirmPass;
@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *vwOnboard;

@property (strong, nonatomic) NSString *strImage;
@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Helper setPlaceholderColor:_tfName withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfEmail withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfPassword withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfConfirmPass withColor:[UIColor foozePlaceHolder]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swiperight];
    
    _btnNext.useActivityIndicator = YES;
    _vwOnboard.hidden = YES;
    
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
    _tfEmail.inputAccessoryView = keyboardDoneButtonView;
    _tfPassword.inputAccessoryView = keyboardDoneButtonView;
    _tfConfirmPass.inputAccessoryView = keyboardDoneButtonView;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Signup", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnNext setBackgroundColor:[UIColor foozeOrange80]];
    [_tfName becomeFirstResponder];
}


/*
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [_btnNext setBackgroundColor:[UIColor foozeBlue]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_btnNext setBackgroundColor:[UIColor foozeOrange]];
}
 */

- (void)viewDidLayoutSubviews
{
    _vwName.layer.cornerRadius = _vwName.frame.size.height/10.;
    _vwEmail.layer.cornerRadius = _vwEmail.frame.size.height/10.;
    _vwPassword.layer.cornerRadius = _vwPassword.frame.size.height/10.;
    _vwPassword2.layer.cornerRadius = _vwPassword2.frame.size.height/10.;
    _btnNext.layer.cornerRadius = _btnNext.frame.size.height/10.;
}

- (void)dismissKeyboard
{    
    [self.tfEmail resignFirstResponder];
    [self.tfName resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    [self.tfConfirmPass resignFirstResponder];
    
//    if (_tfName.text.length > 0 && _tfEmail.text.length > 0 && _tfPassword.text.length > 0 && _tfConfirmPass.text.length > 0) {
    if (_tfName.text.length > 0 && _tfEmail.text.length > 0 && _tfPassword.text.length > 0)
    {
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    }
    else
        [_btnNext setBackgroundColor:[UIColor foozeOrange80]];
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self proceed];
//    [self performSegueWithIdentifier:@"segueToDeliveryAddress" sender:self];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //[self.delegate showWelcomeAgainFromSignUp:self];
}

//- (void)adjustScroll:(UITextField *)textField
//{
////    CGRect frame = CGRectMake(0, textField.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
////    [self.scrollView scrollRectToVisible:frame animated:YES];
//    NSLog(@"y = %f", textField.frame.origin.y);
//    [_scrollView setContentOffset:CGPointMake(0,textField.center.y + 50) animated:YES];
//}

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
        _btnNext.enabled = YES;
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
        [_currentTextField becomeFirstResponder];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)done:(id)sender
{
    if (_currentTextField == _tfName)
    {
        [_tfEmail becomeFirstResponder];
        [self adjustScrollToView:_vwEmail];
    }
    else if (_currentTextField == _tfEmail)
    {
        [_tfPassword becomeFirstResponder];
        [self adjustScrollToView:_vwPassword];
    }
//    else if (_currentTextField == _tfPassword)
//    {
//        [_tfConfirmPass becomeFirstResponder];
//        [self adjustScrollToView:_vwPassword2];
//    }
    else
    {
        [_btnNext setBackgroundColor:[UIColor foozeOrange]];
        [self dismissKeyboard];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfName)
    {
        [self.tfEmail becomeFirstResponder];
        [self adjustScrollToView:_vwEmail];
    }
    if (textField == self.tfEmail)
    {
        [self.tfPassword becomeFirstResponder];
        [self adjustScrollToView:_vwPassword];
    }
    if (textField == self.tfPassword)
    {
        [self.tfConfirmPass becomeFirstResponder];
        [self adjustScrollToView:_vwPassword2];
    }
    if (textField == self.tfConfirmPass)
    {
        [textField resignFirstResponder];
        [self dismissKeyboard];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    if (textField == self.tfName)
    {
        self.tfName.adjustsFontSizeToFitWidth = YES;
    }
    else if (textField == self.tfEmail)
    {
        self.tfEmail.adjustsFontSizeToFitWidth = YES;
    }
}
    
- (IBAction)actionNext:(id)sender
{
//TODO: Temp for debug
//    [self performSegueWithIdentifier:@"segueToDeliveryAddress" sender:self];
//    return;
//End
    
    [self proceed];
}

- (void)proceed
{
    [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    
    if (_tfName.text.length < 1)
    {
        _currentTextField = _tfName;
        [self showAlert:@"Oops" withMessage:@"Please enter your name."];
        return;
    }
    
    if (_tfEmail.text.length < 1)
    {
        _currentTextField = _tfEmail;
        [self showAlert:@"Oops" withMessage:@"Please enter a valid email address."];
        return;
    }
    
    if ([_tfEmail.text rangeOfString:@"@"].location == NSNotFound)
    {
        _currentTextField = _tfEmail;
        [self showAlert:@"Oops" withMessage:@"Please enter a valid email address."];
        return;
    }
    
    if (_tfPassword.text.length < 1)
    {
        _currentTextField = _tfPassword;
        [self showAlert:@"Oops" withMessage:@"Please enter your password."];
        return;
    }
    
//    if (_tfConfirmPass.text.length < 1)
//    {
//        _currentTextField = _tfConfirmPass;
//        [self showAlert:@"Oops" withMessage:@"Please confirm your password."];
//        return;
//    }
    
//    if(![_tfConfirmPass.text isEqualToString:_tfPassword.text])
//    {
//        _currentTextField = _tfConfirmPass;
//        [self showAlert:@"Oops" withMessage:@"Passwords do not match."];
//        return;
//    }
    
    _btnNext.enabled = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_tfName.text forKey:@"name"];
    [defaults synchronize];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:_tfEmail.text];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             NSLog(@"object = %@", objects);
             if ([objects count])
             {
                 _currentTextField = _tfEmail;
                 [self showAlert:@"Oops" withMessage:@"Email already exist."];
             }
             else
             {
                 _btnNext.enabled = YES;
                 [self signupUserNow];
//                 [self performSegueWithIdentifier:@"segueToDeliveryAddress" sender:self];
             }
             
             
         }
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             _btnNext.enabled = YES;
         }
     }];
}

- (void)signupUserNow
{
    PFUser *newUser = [PFUser user];
    
    newUser.username = _tfEmail.text;
    newUser.password = _tfPassword.text;
    newUser.email = _tfEmail.text;
    [newUser setObject:_tfName.text forKey:@"name"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            [[Appboy sharedInstance] logCustomEvent:@"Signup Page 1 - Success"];
            
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser)
            {
                //This is to register current user to AppBoy
                [[Appboy sharedInstance] changeUser:currentUser.objectId];
                [Appboy sharedInstance].user.firstName = [currentUser valueForKey:@"name"];
                [Appboy sharedInstance].user.email = [currentUser valueForKey:@"email"];
                
                [Appboy sharedInstance].user.country = @"US";
            }
            
            _btnNext.enabled = YES;
            [[Branch getInstance] setIdentity:_tfEmail.text];
            [self performSegueWithIdentifier:@"segueToDeliveryAddress" sender:self];
        }
        else
        {
            [[Appboy sharedInstance] logCustomEvent:@"Signup Page 1 - Failed"];
            
            [self showAlert:@"Sorry!" withMessage:[error.userInfo objectForKey:@"error"]];
            _btnNext.enabled = YES;
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToDeliveryAddress"])
    {
        DeliveryAddressViewController *vc = segue.destinationViewController;
        vc.username = self.tfEmail.text;
        vc.password = self.tfPassword.text;
        vc.name = self.tfName.text;
        vc.updateMode = NO;
    }
}

- (IBAction)back:(id)sender
{

    [self.delegate showWelcomeAgainFromSignUp:self];

    
//    [self.navigationController popViewControllerAnimated:YES];
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchDown:(id)sender
{
    [_btnNext setBackgroundColor:[UIColor foozeBlue]];
}

- (void)createWalkthrough
{
    CGRect rectFrame = CGRectMake(0., 0., self.view.bounds.size.width, self.view.bounds.size.height);
    self.ghView = [[GHWalkThroughView alloc] initWithFrame:rectFrame];
    self.ghView.backgroundColor = [UIColor clearColor];
    [self.ghView setDataSource:self];
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:30];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel = welcomeLabel;
    
    _walkthroughTitle = @[NSLocalizedString(@"TITLE_ONE", nil), NSLocalizedString(@"TITLE_TWO", nil), NSLocalizedString(@"TITLE_THREE", nil), NSLocalizedString(@"TITLE_FOUR", nil), NSLocalizedString(@"TITLE_FIVE", nil), NSLocalizedString(@"TITLE_SIX", nil)];
    [self showWalkthrough];
    
}

#pragma mark - Table view data source

- (void)showWalkthrough
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.vwOnboard.hidden = NO;
    
    self.ghView.isfixedBackground = NO;
    self.ghView.delegate = self;
    //self.descStrings = [NSArray arrayWithObjects:desc1,desc2, desc3, desc4, desc5, desc6, desc7, nil];
    //[_ghView setFloatingHeaderView:self.welcomeLabel];
    self.ghView.floatingHeaderView = nil;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    [self.ghView showInView:self.vwOnboard animateDuration:0.3];
}

- (NSInteger)numberOfPages
{
    return 4;
}

- (void)configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    //    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"walkthrough%ld", index+1]];
    //    cell.title = [_walkthroughTitle objectAtIndex:index];
    //cell.desc = [self.descStrings objectAtIndex:index];
    
    //    self.pageControl.currentPage = index ;
    
    if( IS_IPHONE_4 )
    {
        self.strImage = [NSString stringWithFormat:@"walkthrough%ld_4S.jpg", (long)index + 1];
    }
    else
        self.strImage = [NSString stringWithFormat:@"walkthrough%ld.jpg", (long)index + 1];
}

- (UIImage*)bgImageforPage:(NSInteger)index
{
    NSString* imageName;
    UIImage* image;
    
    imageName =[NSString stringWithFormat:@"walkthrough%ld.jpg", (long)index+1];
    image = [UIImage imageNamed:imageName];
    
    return image;
}

- (void)walkthroughDidDismissView:(GHWalkThroughView *)walkthroughView
{
    _vwOnboard.hidden = YES;
    [_btnNext setBackgroundColor:[UIColor foozeOrange]];
    [_tfName becomeFirstResponder];
    //[self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    
//    [self.delegate continueFromWelcomeToSignUp:self];
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
