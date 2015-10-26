
//
//  SuccessViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 6/30/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnSuccess;
@property (strong, nonatomic) IBOutlet UIView *vwSuccess;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Success Order", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];

//    [self clearPromoCode];
    
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
    //    _viewSignUp.layer.cornerRadius = _viewSignUp.frame.size.height/10.;
    _vwSuccess.layer.cornerRadius = _vwSuccess.frame.size.height/10.;
}

- (IBAction)successTouchDown:(id)sender
{
    [_vwSuccess setBackgroundColor:[UIColor foozeYellow]];
//    [_btnSuccess setBackgroundColor:[UIColor foozeYellow]];
}

- (IBAction)done:(id)sender
{
//    [self getNotifications];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
- (void)getNotifications
{
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
                     if ([purpose isEqualToString:@"order"])
                     {
                         NSString *notification = [object objectForKey:@"message"];
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setValue:notification forKey:@"notification"];
                         [defaults synchronize];
                         
                         [self generateSuccessNotification:notification];
                         break;
                     }
                 }
             }
         }
         else
         {
             [self generateSuccessNotification:@"Thank you for Foozing. Enjoy!"];
         }
     }];
}

- (void)generateSuccessNotification:(NSString *)message
{
    UILocalNotification *localNotification;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int alarm_badge = [[defaults valueForKey:@"alarm_badge"] intValue];
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *name = [currentUser objectForKey:@"name"];
    
    //NSString *message = @"Thank you for Foozing. Enjoy!";
    NSString *alertBody;
    
    if (name.length > 0)
        alertBody = [NSString stringWithFormat:@"Hi there %@!, %@", name, message];
    else
        alertBody = [NSString stringWithFormat:@"Hi there!, %@", message];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    int year = (int)[theComponents year];
    int month = (int)[theComponents month];
    int day = (int)[theComponents day];
    int hour = (int)[theComponents hour];
    int min = (int)[theComponents minute] + 2;
    int sec = (int)[theComponents second];
    
    NSString *strTime = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", year, month, day, hour, min, sec];
    
    NSLog(@"strTime = %@", strTime);
    
    NSString *identifier = [NSString stringWithFormat:@"%@%d%d%d%d%d%d]", @"OrderNotification_", year, month, day, hour, min, sec];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
//    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *fireDate = [dateFormat dateFromString:strTime];
    
    NSLog(@"NSDate = %@", fireDate);

    //Configure the Local Notification
    localNotification = [[UILocalNotification alloc] init];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertBody;
    localNotification.repeatInterval = 0;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", message, @"alertBody", nil];
    localNotification.userInfo = infoDict;
    
    //    alarm_badge++;
//    alarm_badge = 1;
//    localNotification.applicationIconBadgeNumber = alarm_badge;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [defaults setValue:[NSNumber numberWithInt: alarm_badge] forKey:@"alarm_badge"];
    [defaults synchronize];

}
*/

@end
