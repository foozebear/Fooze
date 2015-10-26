//
//  AppDelegate.m
//  Fooze
//
//  Created by Alex Russell on 4/13/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Flurry.h"
#import "Branch.h"
#import "AppboyKit.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


NSString * const StripePublishableKey = @"pk_test_ApS1d4lUpyUzOeO7nmiaiRWt";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
//#warning Remove for launch
    Branch *branch = [Branch getInstance];
    
//    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error)
    {
        if (!error) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...
            NSLog(@"params: %@", params.description);
        }
        // params are the deep linked params associated with the link that the user clicked before showing up.
        NSLog(@"deep link data: %@", [params description]);
    }];
    
    // Initialize Parse.
    [Parse enableLocalDatastore];

    [Parse setApplicationId:@"80zV92e2a7suGhwCoBSL0Y7UZ76TGwFOQqzj1XFv"
                  clientKey:@"NUsMYJA7VVX3AQZNZxewisr7gl5C2uprVcSisgsz"];
    
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    [Fabric with:@[CrashlyticsKit]];
    
    //Handle Local Notification
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification)
    {
        NSLog(@"Notification Body: %@",localNotification.alertBody);
        NSLog(@"%@", localNotification.userInfo);
    }
    
    application.applicationIconBadgeNumber = 0;
    
    //Flurry
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"3FPRBHGK3CJ8HV4J2KMT"];

    [Appboy startWithApiKey:@"ec01211a-bc82-4cda-96f6-5b6f47027f62" inApplication:application withLaunchOptions:launchOptions];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    return YES;

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    if (![[Branch getInstance] handleDeepLink:url]) {
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
    }
    
//    if (![[Branch getInstance] handleDeepLink:url]) {
//        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
//    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //push view manually
    
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //int showWalkthrough = [[defaults stringForKey:@"showWalkthrough"] intValue];
    
    ///
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:deviceToken];
//    currentInstallation.channels = @[@"Fooze" ];
//    [currentInstallation saveInBackground];
    
    NSLog(@"Token is: %@", deviceToken);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registration = [defaults stringForKey:@"regfornotification"];
    
    if (![registration isEqualToString:@"Registered"]) {
        NSLog(@"sending device to push notification");
        [self sendProviderDeviceToken:deviceToken]; //Unremark when available
    }
    
    [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
    
//    [[Appboy sharedInstance].user setPushNotificationSubscriptionType:ABKOptedIn];
    
}

//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    NSLog(@"Token is: %@", deviceToken);
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *registration = [defaults stringForKey:@"regfornotification"];
//    
//    if (![registration isEqualToString:@"Registered"]) {
//        NSLog(@"sending device to push notification");
////        [self sendProviderDeviceToken:deviceToken]; //Unremark when available
//    }
//}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //When the app is open and active
//    [PFPush handlePush:userInfo];
    
//   [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
     [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    NSLog(@"Application delegate method handleActionWithIdentifier:forRemoteNotification:completionHandler: is called with identifier: %@, userInfo:%@", identifier, userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[Appboy sharedInstance] getActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications with error= %@", error);
    
}

- (void)sendProviderDeviceToken:(NSData *)devTokenBytes
{
    NSString *token = [devTokenBytes description];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}



@end
