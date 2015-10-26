//
//  FoozeHomeViewController.m
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "FoozeHomeViewController.h"
#import "ConfirmViewController.h"
#import "PreConfirmViewController.h"
#import "DeliveryAddressViewController.h"
#import "SignMeUpViewController.h"
#import "YRActivityIndicator.h"
#import "Flurry.h"
#import "AppboyKit.h"

#import "AlertDeliveryErrorViewController.h"
#import "AlertTimeErrorViewController.h"

#import "Menu.h"

@interface FoozeHomeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblMenu1;
@property (strong, nonatomic) IBOutlet UILabel *lblMenu2;
@property (strong, nonatomic) IBOutlet UILabel *lblMenu3;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenu1;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenu2;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenu3;
@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
@property (strong, nonatomic) IBOutlet UIImageView *imgSettings;
@property (strong, nonatomic) IBOutlet YRActivityIndicator *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu1;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu2;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu3;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIImageView *imgRefresh;

@property (strong,nonatomic) NSString * strAddress;
@property (strong,nonatomic) NSString * strCity;
@property (strong,nonatomic) NSString * strUnit;
@property (strong,nonatomic) NSString * strZip;

//Restaurants Data
@property (strong, nonatomic) Menu *menu1;
@property (strong, nonatomic) Menu *menu2;
@property (strong, nonatomic) Menu *menu3;
@property (strong, nonatomic) Menu *mainMenu;
@property (strong, nonatomic) Menu *onboardingMenu;

@property (strong, nonatomic) NSString *strImage;
@property (nonatomic) int onboardPage;
@property (nonatomic) int promo_amount;
@property (nonatomic) float credit;
@property (nonatomic) BOOL bFetching;
@property (nonatomic) int intSelectedFood;
@property (nonatomic) float freefood;

@property (nonatomic) BOOL bNoPayment;
@property (nonatomic) int iSettingsMode;
@end

@implementation FoozeHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showHideControls:YES];
    
    _iSettingsMode = 0;
    _promo_amount = 0;
    _bFetching = YES;
    _bNoPayment = NO;
    
    _menu1 = [Menu object];
    _menu2 = [Menu object];
    _menu3 = [Menu object];
    
    _btnMenu1.useActivityIndicator = YES;
    _btnMenu2.useActivityIndicator = YES;
    _btnMenu3.useActivityIndicator = YES;
    
    PFUser *currentUser = [PFUser currentUser];

    if (currentUser)
    {
        [currentUser fetchInBackground];
    }
    else
    {
        [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

}

- (void)appplicationIsActive:(NSNotification *)notification
{
    NSLog(@"Application Did Become Active");
}

- (void)applicationEnteredForeground:(NSNotification *)notification
{
    NSLog(@"Application Entered Foreground");
    [self refreshMenuNow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _imgMenu1.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
    _imgMenu2.layer.cornerRadius = _imgMenu2.frame.size.height / 2.;
    _imgMenu3.layer.cornerRadius = _imgMenu3.frame.size.height / 2.;

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _iSettingsMode = 0;
    
    _imgMenu1.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
    _imgMenu2.layer.cornerRadius = _imgMenu2.frame.size.height / 2.;
    _imgMenu3.layer.cornerRadius = _imgMenu3.frame.size.height / 2.;
    
    [self refreshMenuNow];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}


- (void)viewDidLayoutSubviews
{
//    _imgMenu1.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
//    _imgMenu2.layer.cornerRadius = _imgMenu2.frame.size.height / 2.;
//    _imgMenu3.layer.cornerRadius = _imgMenu3.frame.size.height / 2.;
}

- (void)showHideControls:(BOOL)mode
{
    _lblMenu1.alpha = 0;
    _lblMenu2.alpha = 0;
    _lblMenu3.alpha = 0;
    _lblStatus.alpha = 0;
    _lblHeader.alpha = 0;
    _imgSettings.alpha = 0;
    _imgRefresh.alpha = 0;
    
    _imgMenu1.alpha = 0;
    _imgMenu2.alpha = 0;
    _imgMenu3.alpha = 0;

    
    if (mode)
    {
        _lblMenu1.hidden = mode;
        _lblMenu2.hidden = mode;
        _lblMenu3.hidden = mode;
        _lblStatus.hidden = mode;
        _lblHeader.hidden = mode;
        _imgSettings.hidden = mode;
        _imgRefresh.hidden = mode;
        
        _imgMenu1.hidden = mode;
        _imgMenu2.hidden = mode;
        _imgMenu3.hidden = mode;
    }
    else
    {
        [UIView beginAnimations:@"animation" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.0f];
        
        _lblMenu1.hidden = mode;
        _lblMenu2.hidden = mode;
        _lblMenu3.hidden = mode;
        _lblStatus.hidden = mode;
        _lblHeader.hidden = mode;
        _imgSettings.hidden = mode;
        _imgRefresh.hidden = mode;
        
        _imgMenu1.hidden = mode;
        _imgMenu2.hidden = mode;
        _imgMenu3.hidden = mode;
        
        _lblMenu1.alpha = 1;
        _lblMenu2.alpha = 1;
        _lblMenu3.alpha = 1;
        _lblStatus.alpha = 1;
        _lblHeader.alpha = 1;
        _imgSettings.alpha = 1;
        _imgRefresh.alpha = 1;
        
        _imgMenu1.alpha = 1;
        _imgMenu2.alpha = 1;
        _imgMenu3.alpha = 1;
        
        [UIView commitAnimations];
    }
    
}


- (void)showAlert:(NSString *)title withMsg:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        _btnMenu1.enabled = YES;
        _btnMenu2.enabled = YES;
        _btnMenu3.enabled = YES;
        
        if (_bNoPayment) {
            NSLog(@"segue to payment info");
            [self performSegueWithIdentifier:@"showSettings" sender:self];
        }
        
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)refreshMenuNow
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        _btnMenu1.enabled = YES;
        _btnMenu2.enabled = YES;
        _btnMenu3.enabled = YES;
        [self showHideControls:NO];
        
        [self getFood];
        
        if (![currentUser valueForKey:@"deliveryAddress"])
        {
            [self showAlert:@"Registration" withMsg:@"Please complete your registration."];
            _bNoPayment = YES;
            _iSettingsMode = 1;
        }
        else if (![currentUser valueForKey:@"cardNumber"] || ![currentUser valueForKey:@"customerID"])
        {
            [self showAlert:@"Registration" withMsg:@"Please complete your registration."];
            _bNoPayment = YES;
            _iSettingsMode = 2;
        }
    }
}

- (void)getFood
{
//    [_activityIndicator startAnimating];
    [self getNotifications];
    [self getCurrentTimeConfiguration];

    [self rotateImageViewFrom:0.0f to:M_PI*2 duration:2.5f repeatCount:HUGE_VALF];
    _btnRefresh.enabled = NO;
//    _lblStatus.hidden = NO;
    _bFetching = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser)
    {
        [currentUser fetchInBackground];
//        [currentUser fetch];
        NSDictionary *dicAddress = [currentUser valueForKey:@"deliveryAddress"];
        NSString *zipcode;
        
        if(dicAddress.count)
        {
            zipcode = dicAddress[@"zip"];
            
            PFQuery *queryServing = [PFQuery queryWithClassName:@"ZipcodeServing"];
            [queryServing whereKey:@"zipcode" equalTo:zipcode];
            [queryServing includeKey:@"product"];
            [queryServing includeKey:@"product.restaurant"];
            [queryServing orderByAscending:@"createdAt"];
            
            [queryServing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             {
                 if (!error)
                 {
                     if ([objects count] > 0)
                     {
                         NSLog(@"servings = %@", objects);
                         int ii = 0;
                         _bFetching = NO;
                         for (PFObject *object in objects)
                         {
                             //PFObject *product = [[objects objectAtIndex:0] objectForKey:@"product"];
                             PFObject *product = [object objectForKey:@"product"];
                             PFObject *restaurant = [product objectForKey:@"restaurant"];
                             
                             NSLog(@"product = %@ and resto = %@", product, restaurant);
                             
                             switch (ii) {
                                 case 0:
                                 {
                                     _menu1.name = [product objectForKey:@"name"];
                                     _menu1.price = [[product objectForKey:@"price"] floatValue];
                                     _menu1.category = [product objectForKey:@"category"];
                                     _menu1.menuID = product.objectId;
                                     _menu1.restaurant = [restaurant objectForKey:@"name"];
                                     _menu1.zipcodes = [restaurant objectForKey:@"serving_zipcodes"];
                                     _menu1.details = [product objectForKey:@"description"];
                                     
                                     PFFile *userImageFile = product[@"image"];
                                     [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                                         if (!error) {
                                             UIImage *image = [UIImage imageWithData:imageData];
                                             _imgMenu1.image = image;
                                             _imgMenu1.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
                                         }
                                         else
                                         {
                                             NSLog(@"Error: %@", error);
                                         }
                                     }];
                                     
                                     break;
                                 }
                                 case 1:
                                 {
                                     _menu2.name = [product objectForKey:@"name"];
                                     _menu2.price = [[product objectForKey:@"price"] floatValue];
                                     _menu2.category = [product objectForKey:@"category"];
                                     _menu2.menuID = product.objectId;
                                     _menu2.restaurant = [restaurant objectForKey:@"name"];
                                     _menu2.zipcodes = [restaurant objectForKey:@"serving_zipcodes"];
                                     _menu2.details = [product objectForKey:@"description"];
                                     
                                     PFFile *userImageFile = product[@"image"];
                                     [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                                         if (!error) {
                                             UIImage *image = [UIImage imageWithData:imageData];
                                             _imgMenu2.image = image;
                                             _imgMenu2.layer.cornerRadius = _imgMenu2.frame.size.height / 2.;
                                         }
                                         else
                                         {
                                             NSLog(@"Error: %@", error);
                                         }
                                     }];
                                     
                                     break;
                                 }
                                 case 2:
                                 {
                                     _menu3.name = [product objectForKey:@"name"];
                                     _menu3.price = [[product objectForKey:@"price"] floatValue];
                                     _menu3.category = [product objectForKey:@"category"];
                                     _menu3.menuID = product.objectId;
                                     _menu3.restaurant = [restaurant objectForKey:@"name"];
                                     _menu3.zipcodes = [restaurant objectForKey:@"serving_zipcodes"];
                                     _menu3.details = [product objectForKey:@"description"];
                                     
                                     PFFile *userImageFile = product[@"image"];
                                     [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                                         if (!error) {
                                             UIImage *image = [UIImage imageWithData:imageData];
                                             _imgMenu3.image = image;
                                             _imgMenu3.layer.cornerRadius = _imgMenu3.frame.size.height / 2.;
                                         }
                                         else
                                         {
                                             NSLog(@"Error: %@", error);
                                         }
                                     }];
                                     
                                     break;
                                 }
                                     
                                 default:
                                     break;
                             }
                             
                             [self updateMenuItems];
                             
                             ii++;
                         }
                     }
                     else
                     {
                         AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
                         vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                         [self presentViewController:vc animated:YES completion:nil];
                         
                         _btnRefresh.enabled = YES;
                         _imgRefresh.hidden = NO;
                         [_imgRefresh.layer removeAllAnimations];
                         _lblStatus.hidden = YES;
                         _bFetching = NO;
                         
                         //Change the icons
                         [self changeMenuForDeliveryZoneError];
                         
                         return;
                     }
                 }
                 else
                 {
                     [self showAlert:@"Connection error." withMsg:@"Cannot get data!"];
                     _btnRefresh.enabled = YES;
                     _imgRefresh.hidden = NO;
                     [_imgRefresh.layer removeAllAnimations];
                     _bFetching = NO;
                     NSLog(@"error");
                 }
             }];
        }
 
    }
    else
    {
        [self showAlert:@"Registration" withMsg:@"You must register to get menu."];
        NSLog(@"error");
    }

    return;

}

- (void)changeMenuForDeliveryZoneError
{
    _lblMenu1.text = [NSString stringWithFormat:@"%@, %@", @"Philly Cheesesteak Sandwich", @"FOOZE"];
    _lblMenu1.adjustsFontSizeToFitWidth = NO;
    
    _lblMenu2.text = [NSString stringWithFormat:@"%@, %@", @"Korean Ribeye Bacon Fried Rice Bowl", @"KORILLA BBQ"];
    _lblMenu2.adjustsFontSizeToFitWidth = NO;

    _lblMenu3.text = [NSString stringWithFormat:@"%@, %@", @"Chicken Cheese Crepe", @"CREPERIE NYC"];
    _lblMenu3.adjustsFontSizeToFitWidth = NO;
    
    UIImage *image = [UIImage imageNamed:@"menu1.jpg"];
    _imgMenu1.image = image;
    _imgMenu1.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
    
    image = [UIImage imageNamed:@"menu2.jpg"];
    _imgMenu2.image = image;
    _imgMenu2.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
    
    image = [UIImage imageNamed:@"menu3.jpg"];
    _imgMenu3.image = image;
    _imgMenu3.layer.cornerRadius = _imgMenu1.frame.size.height / 2.;
    
    
    _btnRefresh.enabled = YES;
    _imgRefresh.hidden = NO;
    [_imgRefresh.layer removeAllAnimations];
}

- (void)updateMenuItems
{
    if (_menu1.name && _menu1.restaurant)
    {
        _lblMenu1.text = [NSString stringWithFormat:@"%@, %@", [_menu1.name capitalizedString], _menu1.restaurant];
        _lblMenu1.adjustsFontSizeToFitWidth = NO;
    }
    
    if (_menu2.name && _menu2.restaurant)
    {
        _lblMenu2.text = [NSString stringWithFormat:@"%@, %@", [_menu2.name capitalizedString], _menu2.restaurant];
        _lblMenu2.adjustsFontSizeToFitWidth = NO;
    }

    if (_menu3.name && _menu3.restaurant)
    {
        _lblMenu3.text = [NSString stringWithFormat:@"%@, %@", [_menu3.name capitalizedString], _menu3.restaurant];
        _lblMenu3.adjustsFontSizeToFitWidth = NO;
        
//        [self getNotifications];
//        [self getCurrentTimeConfiguration];
//        
        _btnRefresh.enabled = YES;
        _imgRefresh.hidden = NO;
        [_imgRefresh.layer removeAllAnimations];
    }

}

- (void)getNotifications
{
    _lblStatus.hidden = YES;

    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             if ([objects count] > 0)
             {
                 for (PFObject *object in objects)
                 {
                     NSString *purpose = [object objectForKey:@"purpose"];
                     if ([purpose isEqualToString:@"daily"])
                     {
                         NSString *notification = [object objectForKey:@"message"];
                         NSString *fire_time = [object objectForKey:@"fire_time"];
                         BOOL bFireMode = [[object objectForKey:@"fire_mode"] boolValue];
                         
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setValue:notification forKey:@"daily_message"];
                         [defaults setValue:fire_time forKey:@"daily_message_time"];
                         [defaults synchronize];
                         
                         [self createDailyLocalNotification:notification withFireMode:bFireMode];
                     }
                     else if ([purpose isEqualToString:@"share"])
                     {
                         NSString *notification = [object objectForKey:@"message"];
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setValue:notification forKey:@"share_message"];
                         [defaults synchronize];
                     }
                     else if ([purpose isEqualToString:@"order"])
                     {
                         NSString *notification = [object objectForKey:@"message"];
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setValue:notification forKey:@"order_message"];
                         [defaults synchronize];
                     }
                 }
             }
         }
     }];
}

- (void)getCurrentTimeConfiguration
{
    PFQuery *query = [PFQuery queryWithClassName:@"DeliverySchedule"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             if ([objects count] > 0)
             {
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                 
                 for (PFObject *object in objects)
                 {
                     NSLog(@"object = %@", object);
                     NSMutableDictionary *sched = [[NSMutableDictionary alloc] init];
                     
                     NSString *day_id = [object objectForKey:@"day_id"];
                     NSString *day_name = [object objectForKey:@"day_name"];
                     NSString *end_time = [object objectForKey:@"end_time"];
                     NSString *start_time = [object objectForKey:@"start_time"];
                     
                     [sched setObject:day_id forKey:@"day_id"];
                     [sched setObject:day_name forKey:@"day_name"];
                     [sched setObject:end_time forKey:@"end_time"];
                     [sched setObject:start_time forKey:@"start_time"];

                     [dict setObject:sched forKey:day_name];
                 }
                 
                 [defaults setValue:dict forKey:@"Schedule"];
                 [defaults synchronize];
             }
         }
     }];
}

- (void)createDailyLocalNotification:(NSString *)message withFireMode:(BOOL)fireMode
{
    //Delete any existing notification
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *array = [app scheduledLocalNotifications];
    for (int i=0; i<[array count]; i++)
    {
        UILocalNotification *notification = [array objectAtIndex:i];
        [app cancelLocalNotification:notification];
    }
    
    if (!fireMode) return;
    
    UILocalNotification *localNotification;
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int alarm_badge = [[defaults valueForKey:@"alarm_badge"] intValue];

    NSString *alertBody = [NSString stringWithFormat:@"%@", message];
    NSString *alertTime = [defaults valueForKey:@"daily_message_time"];
    
//TODO: Temp
//    alertTime = @"00:10:00";
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    int year = (int)[theComponents year];
    int month = (int)[theComponents month];
    int day = (int)[theComponents day];
    
//    NSString *identifier = [NSString stringWithFormat:@"%@%d%d%d%d%d%d]", @"DailyNotification_", year, month, day, hour, min, sec];
//    NSString *strTime = [NSString stringWithFormat:@"%d-%d-%d %@", year, month, day, @"22:00:00"];
    
    //Delete any existing similar notification
    [self deleteReminder:@"DailyNotification"];

    NSDate *fireDate;

    alarm_badge = 0;
    for (int ii=0; ii<5; ii++)
    {
        NSString *identifier = [NSString stringWithFormat:@"%@%d%d%d%@", @"DailyNotification_", year, month, day, [alertTime stringByReplacingOccurrencesOfString:@":" withString:@""]];
        NSString *strTime = [NSString stringWithFormat:@"%d-%d-%d %@", year, month, day, alertTime];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        if (ii == 0)
            fireDate = [dateFormat dateFromString:strTime];
        
        if ([fireDate compare:[NSDate date]] == NSOrderedAscending)
        {
            NSLog(@"should not save anymore");
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = ii + 1;
            fireDate = [cal dateByAddingComponents:dayComponent toDate:fireDate options:0];

            continue;
        }
        
        //Configure the Local Notification
        localNotification = [[UILocalNotification alloc] init];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.fireDate = fireDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.alertBody = alertBody;
        localNotification.repeatInterval = 0;
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", message, @"alertBody", nil];
        localNotification.userInfo = infoDict;
        
//        alarm_badge = 1;
        localNotification.applicationIconBadgeNumber = alarm_badge;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [defaults setValue:[NSNumber numberWithInt: alarm_badge] forKey:@"alarm_badge"];
        [defaults synchronize];
        
        //Increment by one day
        alarm_badge ++;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
       
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = ii + 1;
        fireDate = [cal dateByAddingComponents:dayComponent toDate:fireDate options:0];
    }
}

- (void)deleteReminder:(NSString *)identifier
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *array = [app scheduledLocalNotifications];
    for (int i=0; i<[array count]; i++)
    {
        UILocalNotification *notification = [array objectAtIndex:i];
        NSDictionary *info = notification.userInfo;
        NSString *code = [NSString stringWithFormat:@"%@",[info valueForKey:@"identifier"]];
        NSLog(@"%@",code);
        
        NSRange found = [code rangeOfString:identifier];
        if (found.location != NSNotFound) {
            NSLog(@"Deleting local notification");
            [app cancelLocalNotification:notification];
        }
    }
}


//- (IBAction)segueToAddress:(id)sender
//{
//    DeliveryAddressViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryAddressViewController"];
////    vc.bSettings = YES;
//    [self showViewController:vc sender:sender];
//}

- (IBAction)refresh:(id)sender
{
    [self getFood];
}

- (IBAction)goSettings:(id)sender
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToConfirmOrder"])
    {
        PreConfirmViewController *vc = segue.destinationViewController;
        vc.menu = _mainMenu;
    }
    else if ([segue.identifier isEqualToString:@"segueToConfirmOrderWithPromo"])
    {
        PreConfirmPromoViewController *vc = segue.destinationViewController;
        vc.menu = _mainMenu;
        vc.credit = _credit;
        vc.freefood = _freefood;
    }
    else if ([segue.identifier isEqualToString:@"segueToOnboardOne"])
    {
        OnboardOneViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.page = _onboardPage;
    }
    else if ([segue.identifier isEqualToString:@"segueToOnboardTwo"])
    {
        OnboardTwoViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"segueToOnboardThree"])
    {
        OnboardThreeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"showSettings"])
    {
        SettingsViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.iSettingsMode = _iSettingsMode;
    }
    else if ([segue.identifier isEqualToString:@"SegueToWelcome"])
    {
        WelcomeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"segueToLogin"])
    {
        LogInViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"segueToSignUp"])
    {
        SignUpViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"segueToOnboardingMenu"])
    {
        OnBoardingMenuViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"segueToOnboardingOrder"])
    {
        OnBoardingMenuOrderViewController *vc = segue.destinationViewController;
        vc.menu = _onboardingMenu;
        vc.delegate = self;
    }
    
}

- (BOOL)checkZipCode:(Menu *)menu
{
    PFUser *currentUser = [PFUser currentUser];
    NSString *userZipcode = [[currentUser objectForKey:@"deliveryAddress"] objectForKey:@"zip"];
    NSArray *zipcodes = [menu objectForKey:@"zipcodes"];
    
    for (NSDictionary *zipcode in zipcodes)
    {
        NSString *thisCode = [zipcode objectForKey:@"zipcode"];
        
        if ([thisCode isEqualToString:userZipcode])
        {
            return YES;
        }
    }
    
    [[Appboy sharedInstance] logCustomEvent:@"Order - Zipcode Error" withProperties:@{@"Zipcode":userZipcode}];
    
    return NO;
}

- (IBAction)selectFoodOne:(id)sender
{
    _btnMenu1.enabled = NO;
    
    if (_menu1.menuID)
    {
        _mainMenu = _menu1;
        PFUser *currentUser = [PFUser currentUser];
        
        if (currentUser)
        {
            if ([self checkZipCode:_menu1])
            {
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: _menu1.name, @"Food", _menu1.restaurant, @"Restaurant", nil];
                [Flurry logEvent:@"Food - Selected" withParameters:params];

                [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *err) {
                    if (!err)
                    {
                        _freefood = [[Branch getInstance] getCreditsForBucket:@"Food"];
                        _credit = [[Branch getInstance] getCredits];
                        
                        if (_credit > 0. || _freefood > 0)
                            [self performSegueWithIdentifier:@"segueToConfirmOrderWithPromo" sender:self];
                        else
                            [self performSegueWithIdentifier:@"segueToConfirmOrder" sender:self];
                        
                    }
                    else
                    {
                        [self showAlert:@"Order" withMsg:@"Encountered error in selecting food item. Please try again."];
                        _btnMenu1.enabled = YES;
                    }
                }];
                
            }
            else
            {
                AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        else
            [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    }
    else
    {
        if (!_bFetching)
        {
            AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            
            _btnRefresh.enabled = YES;
            _btnMenu1.enabled = YES;
            _imgRefresh.hidden = NO;
            [_imgRefresh.layer removeAllAnimations];
            _lblStatus.hidden = YES;
        }
        else
            [self showAlert:@"Updating" withMsg:@"Please wait for Fooze to update your menu."];
    }
    
}

- (IBAction)selectFoodTwo:(id)sender
{
    _btnMenu2.enabled = NO;
    
    if (_menu2.menuID)
    {
        _mainMenu = _menu2;
        PFUser *currentUser = [PFUser currentUser];
        
        if (currentUser)
        {
            if ([self checkZipCode:_menu2])
            {
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: _menu2.name, @"Food", _menu2.restaurant, @"Restaurant", nil];
                [Flurry logEvent:@"Food - Selected" withParameters:params];

                [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *err) {
                    if (!err)
                    {
                        _freefood = [[Branch getInstance] getCreditsForBucket:@"Food"];
                        _credit = [[Branch getInstance] getCredits];
                        
                        if (_credit > 0. || _freefood > 0)
                            [self performSegueWithIdentifier:@"segueToConfirmOrderWithPromo" sender:self];
                        else
                            [self performSegueWithIdentifier:@"segueToConfirmOrder" sender:self];
                        
                    }
                    else
                    {
                        [self showAlert:@"Order" withMsg:@"Encountered error in selecting food item. Please try again."];
                        _btnMenu1.enabled = YES;
                    }
                }];

                
            }
            else
            {
                AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        else
            [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    }
    else
    {
        if (!_bFetching)
        {
            AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            
            _btnRefresh.enabled = YES;
            _btnMenu2.enabled = YES;
            _imgRefresh.hidden = NO;
            [_imgRefresh.layer removeAllAnimations];
            _lblStatus.hidden = YES;
        }
        else
            [self showAlert:@"Updating" withMsg:@"Please wait for Fooze to update your menu."];
    }
}

- (IBAction)selectFoodThree:(id)sender
{
    _btnMenu3.enabled = NO;
    
    if (_menu3.menuID)
    {
        _mainMenu = _menu3;
        PFUser *currentUser = [PFUser currentUser];
        
        if (currentUser)
        {
            if ([self checkZipCode:_menu3])
            {
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: _menu3.name, @"Food", _menu3.restaurant, @"Restaurant", nil];
                [Flurry logEvent:@"Food - Selected" withParameters:params];

                [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *err) {
                    if (!err)
                    {
                        _freefood = [[Branch getInstance] getCreditsForBucket:@"Food"];
                        _credit = [[Branch getInstance] getCredits];
                        
                        if (_credit > 0. || _freefood > 0)
                            [self performSegueWithIdentifier:@"segueToConfirmOrderWithPromo" sender:self];
                        else
                            [self performSegueWithIdentifier:@"segueToConfirmOrder" sender:self];
                        
                    }
                    else
                    {
                        [self showAlert:@"Order" withMsg:@"Encountered error in selecting food item. Please try again."];
                        _btnMenu1.enabled = YES;
                    }
                }];

            }
            else
            {
                AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        else
            [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    }
    else
    {
        if (!_bFetching)
        {
            AlertDeliveryErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertDeliveryError"];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            
            _btnRefresh.enabled = YES;
            _btnMenu3.enabled = YES;
            _imgRefresh.hidden = NO;
            [_imgRefresh.layer removeAllAnimations];
            _lblStatus.hidden = YES;
        }
        else
            [self showAlert:@"Updating" withMsg:@"Please wait for Fooze to update your menu."];
    }
}

- (void)rotateImageViewFrom:(CGFloat)fromValue to:(CGFloat)toValue duration:(CFTimeInterval)duration repeatCount:(CGFloat)repeatCount
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    rotationAnimation.toValue = [NSNumber numberWithFloat:toValue];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.imgRefresh.layer addAnimation:rotationAnimation forKey:@"rotation"];
}


#pragma mark -
#pragma mark - OnBoardingMenuOrderViewController

- (void)showWelcomeFromOnboardingMenuOrder:(OnBoardingMenuOrderViewController *)controller
{
    [self.navigationController popViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
}

- (void)goBackToMenuFromOnboardingMenuOrder:(OnBoardingMenuOrderViewController *)controller
{
    [self performSegueWithIdentifier:@"segueToOnboardingMenu" sender:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signupFromOnboardingMenuOrder:(OnBoardingMenuOrderViewController *)controller
{
    [self.navigationController popViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
}

#pragma mark -
#pragma mark - OnBoardingMenuViewController

- (void)showWelcomeFromOnboardingMenu:(OnBoardingMenuViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
    }];
}

- (void)showOnboardingMenuOrder:(OnBoardingMenuViewController *)controller withMenu:(Menu *)menu
{
    [self dismissViewControllerAnimated:NO completion:^{
        _onboardingMenu = menu;
        [self performSegueWithIdentifier:@"segueToOnboardingOrder" sender:self];
    }];
}

#pragma mark -
#pragma mark - WelcomeViewController

- (void)continueFromWelcomeToOnboardingMenu:(WelcomeViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToOnboardingMenu" sender:self];
    }];
}

- (void)continueFromWelcome:(WelcomeViewController *) controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self showHideControls:NO];
    }];
}

- (void)continueFromWelcomeToOnboard:(WelcomeViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        _onboardPage = 1;
        [self performSegueWithIdentifier:@"segueToOnboardOne" sender:self];
    }];
}

- (void)continueFromWelcomeToSignUp:(WelcomeViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    }];
}

- (void)continueFromWelcomeToLogin:(WelcomeViewController *) controller
{
    [self showHideControls:YES];
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToLogin" sender:self];
    }];
}

#pragma mark -
#pragma mark - SignUpViewController

- (void)showOnboardFromSignup:(SignUpViewController *) controller
{
    [self.navigationController popViewControllerAnimated:NO];
    _onboardPage = 3;
    [self performSegueWithIdentifier:@"segueToOnboardOne" sender:self];
}

- (void)showWelcomeAgainFromSignUp:(SignUpViewController *)controller
{
    [self showHideControls:YES];
    [self.navigationController popViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
}

#pragma mark - 
#pragma mark - LogInViewController

- (void)showWelcomeAgain:(LogInViewController *) controller
{
    [self.navigationController popViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
}

#pragma mark -
#pragma mark - OnboardOneViewController

- (void)showWelcomeAgainFromOnboard:(OnboardOneViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
    }];
//    [self.navigationController popViewControllerAnimated:NO];
//    [self performSegueWithIdentifier:@"SegueToWelcome" sender:self];
}

- (void)continueToSignupFromOnboardOne:(OnboardOneViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    }];
}

- (void)continueToOnboardTwo:(OnboardOneViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToOnboardTwo" sender:self];
    }];
}


#pragma mark -
#pragma mark - OnboardTwoViewController

- (void)continueToOnboardThree:(OnboardTwoViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToOnboardThree" sender:self];
    }];
}

- (void)backToOnboardOne:(OnboardTwoViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToOnboardOne" sender:self];
    }];
}

#pragma mark -
#pragma mark - OnboardThreeViewController

- (void)continueToSignupFromOnboardThree:(OnboardThreeViewController *) controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToSignUp" sender:self];
    }];
}

- (void)backToOnboardTwo:(OnboardThreeViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"segueToOnboardTwo" sender:self];
    }];
}

#pragma mark -
#pragma mark - SettingsViewController

- (void)showWelcomeScreen:(SettingsViewController *)controller
{
    [self showHideControls:YES];
    [self.navigationController popViewControllerAnimated:NO];
    WelcomeViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}


/*
#pragma mark - Table view data source

- (void)showWalkthrough
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.mainView.hidden = NO;
    
    self.ghView.isfixedBackground = NO;
    self.ghView.delegate = self;
    //self.descStrings = [NSArray arrayWithObjects:desc1,desc2, desc3, desc4, desc5, desc6, desc7, nil];
    //[_ghView setFloatingHeaderView:self.welcomeLabel];
    self.ghView.floatingHeaderView = nil;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    [self.ghView showInView:self.mainView animateDuration:0.3];
}

- (NSInteger)numberOfPages
{
    return 4;
}

- (void)configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
//    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"walkthrough%ld", (long)index + 1]];
//    cell.title = [_walkthroughTitle objectAtIndex:index];
    //cell.desc = [self.descStrings objectAtIndex:index];
    
    //    self.pageControl.currentPage = index ;
    self.strImage = [NSString stringWithFormat:@"walkthrough%ld", (long)index + 1];
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

}
*/



@end
