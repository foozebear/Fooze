//
//  Helper.m
//  fooze
//
//  Created by RMBuerano on 6/25/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "Helper.h"

NSString* const FONTSTYLE = @"Gotham-Medium";

@implementation Helper

/*
+ (void)setPlaceholderColor:(UITextField *)txtField withColor:(UIColor *)color
{
    NSDictionary *attributes = (NSMutableDictionary *)[ (NSAttributedString *)txtField.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    [newAttributes setObject:color forKey:NSForegroundColorAttributeName];
    [newAttributes setObject:[UIFont fontWithName:@"Gotham-Medium" size:[[txtField font] pointSize]] forKey:NSFontAttributeName];
    txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[txtField.attributedPlaceholder string] attributes:newAttributes];

}
*/

+ (void)setPlaceholderColor:(UITextField *)txtField withColor:(UIColor *)color
{
    NSDictionary *attributes = (NSMutableDictionary *)[ (NSAttributedString *)txtField.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    [newAttributes setObject:color forKey:NSForegroundColorAttributeName];
    txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[txtField.attributedPlaceholder string] attributes:newAttributes];
}

+ (void)showLocalNotification:(NSString *)message forRestaurant:(NSString *)restaurant andFood:(NSString *)food
{
    NSDictionary *userInfo = @{
                               @"Restaurant":restaurant,
                               @"Food":food
                               };

    //Override
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    message = [defaults valueForKey:@"order_message"];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = userInfo;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
