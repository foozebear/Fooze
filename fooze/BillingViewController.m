//
//  BillingViewController.m
//  Fooze
//
//  Created by RMBuerano on 7/1/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "BillingViewController.h"
#import "Helper.h"
#import "UIColor+Extended.h"
#import "ConfirmViewController.h"

@interface BillingViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tfStreetName;
@property (strong, nonatomic) IBOutlet UITextField *tfUnit;
@property (strong, nonatomic) IBOutlet UITextField *tfCity;
@property (strong, nonatomic) IBOutlet UITextField *tfZipCode;
@property (strong, nonatomic) IBOutlet UIView *viewStreetName;
@property (strong, nonatomic) IBOutlet UIView *viewUnit;
@property (strong, nonatomic) IBOutlet UIView *viewCity;
@property (strong, nonatomic) IBOutlet UIView *viewZipCode;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;
@end

@implementation BillingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Helper setPlaceholderColor:_tfStreetName withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfUnit withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfZipCode withColor:[UIColor foozePlaceHolder]];
    [Helper setPlaceholderColor:_tfCity withColor:[UIColor foozePlaceHolder]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swiperight];
    
    _btnSubmit.useActivityIndicator = YES;

    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser)
    {
//        [currentUser fetch];
        NSDictionary *dicAddress = [currentUser valueForKey:@"paymentAddress"];
        if(dicAddress.count)
        {
            _tfStreetName.text = dicAddress[@"streetaddress"];
            _tfUnit.text = dicAddress[@"unit"];
            _tfCity.text = dicAddress[@"city"];
            _tfZipCode.text = dicAddress[@"zip"];
        }
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _tfStreetName.text = [defaults valueForKey:@"address"];
        _tfZipCode.text = [defaults valueForKey:@"zipcode"];
        _tfUnit.text = [defaults valueForKey:@"unit"];
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

    _tfStreetName.inputAccessoryView = keyboardDoneButtonView;
    _tfUnit.inputAccessoryView = keyboardDoneButtonView;
    _tfCity.inputAccessoryView = keyboardDoneButtonView;
    _tfZipCode.inputAccessoryView = keyboardDoneButtonView;

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnSubmit setBackgroundColor:[UIColor foozeOrange80]];
    [_tfStreetName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        _btnSubmit.enabled = YES;
        [_btnSubmit setBackgroundColor:[UIColor foozeOrange]];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfStreetName)
    {
        [self.tfUnit becomeFirstResponder];
    }
    if (textField == self.tfUnit)
    {
        [self.tfCity becomeFirstResponder];
    }
    if (textField == self.tfCity)
    {
        [self.tfZipCode becomeFirstResponder];
    }
    if (textField == self.tfZipCode)
    {
        [textField resignFirstResponder];
        [_btnSubmit setBackgroundColor:[UIColor foozeOrange]];
    }
    
    return YES;
}
- (void)viewDidLayoutSubviews
{
    _btnSubmit.layer.cornerRadius = _btnSubmit.frame.size.height/10.;
    _viewStreetName.layer.cornerRadius = _viewStreetName.frame.size.height/10.;
    _viewUnit.layer.cornerRadius = _viewUnit.frame.size.height/10.;
    _viewCity.layer.cornerRadius = _viewCity.frame.size.height/10.;
    _viewZipCode.layer.cornerRadius = _viewZipCode.frame.size.height/10.;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if([segue.identifier isEqualToString:@"showConfirm"]){
//        ConfirmViewController *vc = segue.destinationViewController;
//        vc.strMessage = @"GREAT";
//        vc.delegate = self;
//        vc.strSubMessage =@"You're ready to Fooze";
//    }
}

- (IBAction)submitUserData:(id)sender
{
    //TODO: Temp
//    [self performSegueWithIdentifier:@"showConfirm" sender:self];
//    return;
    //End

    [self proceed];
}

- (void)proceed
{
    [_btnSubmit setBackgroundColor:[UIColor foozeBlue]];
    
    if(_tfStreetName.text.length <= 5)
    {
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter your street address."];
        return;
    }
    
    if(_tfUnit.text.length == 0 )
    {
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter your unit."];
        return;
    }
    
    if(_tfCity.text.length < 1)
    {
        [self showAlert:@"Oops!" withMessage:@"Please enter your city name."];
        return;
    }
    
    if(_tfZipCode.text.length < 5)
    {
        [self showAlert:@"Oops!" withMessage:@"Make sure you enter your zipcode."];
        return;
    }
    
    _btnSubmit.enabled = NO;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        [self updateUserBillingInfoNow];
    }
    else
    {
        [self submitUserDataNow];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitUserDataNow
{
    NSMutableDictionary *deliveryAddress = [[NSMutableDictionary alloc]init];
    
    [deliveryAddress setObject:self.streetName forKey:@"streetaddress"];
    [deliveryAddress setObject:self.unit forKey:@"unit"];
    [deliveryAddress setObject:@"New York City" forKey:@"city"];
    [deliveryAddress setObject:self.zipcode forKey:@"zip"];
    
    NSMutableDictionary *paymentAddress = [[NSMutableDictionary alloc]init];
    
    [paymentAddress setObject:self.tfStreetName.text forKey:@"streetaddress"];
    [paymentAddress setObject:self.tfUnit.text forKey:@"unit"];
    [paymentAddress setObject:@"New York City" forKey:@"city"];
    [paymentAddress setObject:self.tfZipCode.text forKey:@"zip"];
    
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.username;
    newUser.password = self.password;
    newUser.email = self.username;
    [newUser setObject:self.name forKey:@"name"];
    [newUser setObject:self.phonenumber forKey:@"phoneNumber"];
    
    [newUser setObject:self.cardname forKey:@"cardName"];
    [newUser setObject:[self.cardNumber stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"cardNumber"];
    [newUser setObject:self.cardCVC forKey:@"cardCVC"];
    [newUser setObject:self.cardExpiry forKey:@"cardExpiry"];
    [newUser setObject:self.specialinstruction forKey:@"specialInstruction"];
    
    [newUser setObject:deliveryAddress forKey:@"deliveryAddress"];
    [newUser setObject:paymentAddress forKey:@"paymentAddress"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [self performSegueWithIdentifier:@"showConfirm" sender:self];
            _btnSubmit.enabled = YES;
            [[Branch getInstance] setIdentity:newUser.username];
        }
        else
        {
            [self showAlert:@"Sorry!" withMessage:[error.userInfo objectForKey:@"error"]];
            _btnSubmit.enabled = YES;
        }
    }];
}

- (void)updateUserBillingInfoNow
{
    NSMutableDictionary *paymentAddress = [[NSMutableDictionary alloc]init];
    
    [paymentAddress setObject:self.tfStreetName.text forKey:@"streetaddress"];
    [paymentAddress setObject:self.tfUnit.text forKey:@"unit"];
    [paymentAddress setObject:@"New York City" forKey:@"city"];
    [paymentAddress setObject:self.tfZipCode.text forKey:@"zip"];
   
    PFUser *currentUser =  [PFUser currentUser];
    [currentUser setObject:paymentAddress forKey:@"paymentAddress"];
    
    NSString *cardNumber = [self.cardNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [currentUser setObject:cardNumber forKey:@"cardNumber"];
    [currentUser setObject:self.cardNumber forKey:@"cardNumber"];
    [currentUser setObject:self.cardCVC forKey:@"cardCVC"];
    [currentUser setObject:self.cardExpiry forKey:@"cardExpiry"];

    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
//             PFUser *currentUser = [PFUser currentUser];
//             if (currentUser)
//             {
//                 //This is to register current user to AppBoy
//                  NSDictionary *dicAddress = [currentUser valueForKey:@"paymentAddress"];
//                 if(dicAddress.count)
//                 {
//                     [Appboy sharedInstance].user.homeCity = dicAddress[@"city"];
//                 }
//             }
             
             _btnSubmit.enabled = YES;
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [self showAlert:@"Sorry!" withMessage:[error.userInfo objectForKey:@"error"]];
             _btnSubmit.enabled = YES;
         }
     }];
}

- (IBAction)touchDown:(id)sender
{
    [_btnSubmit setBackgroundColor:[UIColor foozeBlue]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    if (textField == self.tfStreetName)
    {
        self.tfStreetName.adjustsFontSizeToFitWidth = YES;
    }
}

- (void)dismissKeyboard
{
    [self.tfStreetName resignFirstResponder];
    [self.tfCity resignFirstResponder];
    [self.tfUnit resignFirstResponder];
    [self.tfZipCode resignFirstResponder];
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self proceed];
//    [self performSegueWithIdentifier:@"showConfirm" sender:self];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)adjustScroll:(UITextField *)textField
{
    //    CGRect frame = CGRectMake(0, textField.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    //    [self.scrollView scrollRectToVisible:frame animated:YES];
//    NSLog(@"centerY = %f", textField.center.y);
//    if (textField == _tfCVC) {
//        [_scrollView setContentOffset:CGPointMake(0,textField.center.y + 100) animated:YES];
//    }
//    else
        [_scrollView setContentOffset:CGPointMake(0,textField.center.y + 50) animated:YES];
}

- (void)done:(id)sender
{
    //    [self dismissKeyboard];
    if (_currentTextField == _tfStreetName)
    {
        [_tfUnit becomeFirstResponder];
        [self adjustScroll:_tfUnit];
    }
    else if (_currentTextField == _tfUnit)
    {
        [_tfCity becomeFirstResponder];
        [self adjustScroll:_tfCity];
    }
    else if (_currentTextField == _tfCity)
    {
        [_tfZipCode becomeFirstResponder];
        [self adjustScroll:_tfZipCode];
    }
    else
    {
        [self dismissKeyboard];
    }
}

//- (void)proceedToFoozeHome:(ConfirmViewController *) controller
//{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self.delegate proceedToFoozeHome:self];
//    }];
//}

@end
