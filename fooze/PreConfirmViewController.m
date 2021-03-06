//
//  PreConfirmViewController.m
//  Fooze
//
//  Created by Alex Russell on 5/28/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "PreConfirmViewController.h"
#import <Parse/Parse.h>
#import "Flurry.h"
#import "SCLAlertView.h"

#import "AlertTimeErrorViewController.h"

@interface PreConfirmViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnThatsRight;
@property (strong, nonatomic) IBOutlet UIImageView *imgPlus;
@property (strong, nonatomic) IBOutlet UIImageView *imgPlusYellow;
@property (strong, nonatomic) IBOutlet UIImageView *imgMinus;
@property (strong, nonatomic) IBOutlet UIImageView *imgMinusYellow;
@property (strong, nonatomic) IBOutlet UILabel *lblRestoName;
@property (strong, nonatomic) IBOutlet UILabel *lblFood;
@property (strong, nonatomic) IBOutlet UIView *vwThatsRight;

@property (nonatomic) int intQuantity;
@end

@implementation PreConfirmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Pre Order", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateDetails];
}

- (void)updateDetails
{
    PFUser *currentUser = [PFUser currentUser];
    
    //    [currentUser fetch];
    NSDictionary *dicAddress = [currentUser valueForKey:@"deliveryAddress"];
    
    NSString *address;
    if(dicAddress.count!=0)
    {
        if (dicAddress[@"unit"]) {
            address = [NSString stringWithFormat:@"%@, %@", dicAddress[@"streetaddress"], dicAddress[@"unit"]];
        }
        else
            address = dicAddress[@"streetaddress"];
    }
    
    NSString *resto = [NSString stringWithFormat:@"%@:", [_menu.name capitalizedString]];
    resto = [resto stringByReplacingOccurrencesOfString:@"Nyc" withString:@"NYC"];
    
    _lblRestoName.text = resto;
    _lblFood.text = _menu.details;

    
//    NSString *resto = [NSString stringWithFormat:@"%@:", [_menu.restaurant capitalizedString]];
//    resto = [resto stringByReplacingOccurrencesOfString:@"Nyc" withString:@"NYC"];
    
//    _lblRestoName.text = resto;
//    _lblFood.text = [_menu.name capitalizedString];
    
    
    _intQuantity = 1;
    _lblQuantity.text = [NSString stringWithFormat:@"%d x $%.2f",_intQuantity,_menu.price];
    _lblAddress.text = address;
    
    _lblQuantity.text = [NSString stringWithFormat:@"%ld x $%.2f",(long)_intQuantity,_menu.price];
    _lblTotal.text = [NSString stringWithFormat:@"$%.2f",(long)_intQuantity * _menu.price];
    
    _btnThatsRight.useActivityIndicator = YES;
    
    [[Appboy sharedInstance] logCustomEvent:@"Order - Viewed" withProperties:@{@"Food":_menu.name, @"Restaurant":_menu.restaurant}];
}

- (void)viewDidLayoutSubviews
{
    _vwThatsRight.layer.cornerRadius = _vwThatsRight.frame.size.height/10.;
}

- (void)showAlert:(NSString *)title withMsg:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        [_vwThatsRight setBackgroundColor:[UIColor foozeTurquoise]];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToPromoCode"])
    {
        PromoCodeViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.bSettings = NO;
        
    }
}

- (void)confirmOrder
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    SCLButton *button = [alert addButton:@"Continue" target:self selector:@selector(confirmOrderNow)];
    
    button.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor foozeOrange];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        buttonConfig[@"borderWidth"] = @0.0f;
        buttonConfig[@"borderColor"] = [UIColor foozeOrange];  //[UIColor greenColor];
        
        return buttonConfig;
    };
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        [_vwThatsRight setBackgroundColor:[UIColor foozeTurquoise]];
    }];
    
    NSString *subTitle = [NSString stringWithFormat:@"Are you sure? (%@)", _lblTotal.text];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    [alert showSuccessWithImage:@"Fooze Order" image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor redColor] subTitle:subTitle closeButtonTitle:@"Cancel" duration:0.0f];
}

- (void)confirmOrderNow
{
    NSLog(@"confirming order now!");
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: _menu.name, @"Food", _menu.restaurant, @"Restaurant", nil];
    [Flurry logEvent:@"Food - Ordered" withParameters:params];
    
    
    PFUser *currentuser = [PFUser currentUser];
    NSString *userID = currentuser.objectId;
    NSString *productObjectId = _menu.menuID;
    NSNumber *quantity =  [NSNumber numberWithInt:_intQuantity];
    NSString *zipcode = [[currentuser objectForKey:@"deliveryAddress"] objectForKey:@"zip"];
        
    [PFCloud callFunctionInBackground:@"order"
                       withParameters:@{
                                        @"userObjectId":userID,
                                        @"productObjectId":productObjectId,
                                        @"zipcode":zipcode,
                                        @"quantity":quantity,
                                        @"discount":@"0"
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error)
                                    {
                                        [[Appboy sharedInstance] logCustomEvent:@"Order - Confirmed" withProperties:@{@"Food":_menu.name, @"Restaurant":_menu.restaurant}];
                                        
                                        [[Appboy sharedInstance] logPurchase:productObjectId
                                                                  inCurrency:@"USD"
                                                                     atPrice:[[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", _intQuantity * _menu.price]]];
                                        
                                        NSLog(@"from Cloud Code Res: %@",result);
                                        _btnThatsRight.enabled = YES;
                                        
                                        [[Branch getInstance] userCompletedAction:@"placed_order" withState:@{@"item":_menu.name}];
                                        
                                        [self performSegueWithIdentifier:@"segueToSuccess" sender:self];
                                        
                                        [Helper showLocalNotification:@"We've received your order! Fooze on." forRestaurant:[_menu.restaurant capitalizedString] andFood:[_menu.name capitalizedString]];
                                    }
                                    else
                                    {
                                        NSLog(@"from Cloud Code: %@",error);
                                        NSString *message = [[error userInfo] objectForKey:@"error"];
                                        
                                        [self showAlert:@"Order Error" withMsg:message];
                                        _btnThatsRight.enabled = YES;
                                    }
                                    
                                }];
}

- (IBAction)thatsRightTouchDown:(id)sender
{
    [_vwThatsRight setBackgroundColor:[UIColor foozeYellow]];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionConfirm:(id)sender
{
//    [[Appboy sharedInstance] logCustomEvent:@"Order - Confirmed" withProperties:@{@"Food":_menu.name, @"Restaurant":_menu.restaurant}];
    if (![self checkCurrentTime]) return;
    
//    [self confirmOrderNow];
//    [self confirmOrder];
}

- (BOOL)checkCurrentTime
{
    //TODO: Temp for testing
//    return YES;
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) return NO;
    
    _btnThatsRight.enabled = NO;
    
    [PFCloud callFunctionInBackground:@"getCurrentTime"
                       withParameters:nil
                                block:^(NSString *result, NSError *error) {
                                    if (!error)
                                    {
                                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//                                        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//                                        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
                                        
                                        NSDate *today = [dateFormat dateFromString:result];
                                        NSDate *nycDate = [today dateByAddingTimeInterval:-4*60*60];
                                        
                                        [dateFormat setDateFormat:@"EEEE"];
                                        NSString *dayName = [dateFormat stringFromDate:nycDate];
                                        
                                        [dateFormat setDateFormat:@"HH:mm:ss"];
                                        NSString *time = [dateFormat stringFromDate:nycDate];
                                        
                                        [self validateSchedule:[dayName uppercaseString] withHour:time];
                                        
                                    }
                                    else
                                    {
                                       [self showAlert:@"Fooze Order" withMsg:@"Sorry, error encountered in placing your order."];
                                        [_vwThatsRight setBackgroundColor:[UIColor foozeTurquoise]];
                                        _btnThatsRight.enabled = YES;
                                    }
                                }];
    
    return NO;
    
}

- (void)validateSchedule:(NSString *)dayName withHour:(NSString *)time
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
                 
                 [self compareTimeNow:dayName withHour:time];
             }
         }
     }];
}

- (void)compareTimeNow:(NSString *)dayName withHour:(NSString *)time
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults valueForKey:@"Schedule"];
    
    NSDictionary *sched = [dict objectForKey:dayName];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
    NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
    NSDate *current_time = [dateFormat dateFromString:time];
    
//#warning temp
//    start_time = [dateFormat dateFromString:@"04:00:00"];
//    end_time = [dateFormat dateFromString:@"09:00:00"];
    
    if ([start_time compare:end_time] == NSOrderedDescending)
    {
        //When the closing time is the closing time of the previous day
        NSLog(@"start_time is later than end_time");
        if ([start_time compare:current_time] == NSOrderedAscending || [end_time compare:current_time] == NSOrderedDescending)
        {
            NSLog(@"end_time is later that time.");
            [self confirmOrderNow];
        }
        else
        {
            [[Appboy sharedInstance] logCustomEvent:@"Order - Time Error" withProperties:@{@"Day":dayName, @"Time":time}];
            
            AlertTimeErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertTimeError"];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            
            [_vwThatsRight setBackgroundColor:[UIColor foozeTurquoise]];
            _btnThatsRight.enabled = YES;
        }
    }
    else
    {
        if ([start_time compare:current_time] == NSOrderedAscending && [end_time compare:current_time] == NSOrderedDescending)
        {
            NSLog(@"current time is within start and end time.");
            [self confirmOrderNow];
        }
        else
        {
            [[Appboy sharedInstance] logCustomEvent:@"Order - Time Error" withProperties:@{@"Day":dayName, @"Time":time}];
            
            AlertTimeErrorViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertTimeError"];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            
            [_vwThatsRight setBackgroundColor:[UIColor foozeTurquoise]];
            _btnThatsRight.enabled = YES;
        }
    }

}

- (IBAction)addCount:(id)sender
{
    _intQuantity++;
    
    self.lblQuantity.text = [NSString stringWithFormat:@"%d x $%.2f",_intQuantity,_menu.price];
    self.lblTotal.text = [NSString stringWithFormat:@"$%.2f",_intQuantity * _menu.price];
    
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6f];

    _imgPlus.alpha = 1.;
    
    [UIView commitAnimations];
}

- (IBAction)addDown:(id)sender
{
    _imgPlus.alpha = 0.;
//    _imgPlus.image = [UIImage imageNamed:@"icn_plus_yellow"];

}

- (IBAction)minusCount:(id)sender
{
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6f];
    
    _imgMinus.alpha = 1.;
    
    [UIView commitAnimations];
    
    if(_intQuantity <= 1) return;
    _intQuantity--;
    
    self.lblQuantity.text = [NSString stringWithFormat:@"%d x $%.2f",_intQuantity,_menu.price];
    self.lblTotal.text = [NSString stringWithFormat:@"$%.2f",_intQuantity * _menu.price];

}

- (IBAction)minusDown:(id)sender
{
    _imgMinus.alpha = 0.;
}

- (IBAction)showPromoCode:(id)sender
{
    [self performSegueWithIdentifier:@"segueToPromoCode" sender:self];
}

#pragma mark -
#pragma mark - PromoCodeViewController

- (void)goBackToConfirmView:(PromoCodeViewController *)controller
{
    [self.navigationController popViewControllerAnimated:NO];
//    [self.delegate goBackToConfirmView:self];

}

@end
