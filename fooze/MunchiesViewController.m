//
//  MunchiesViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/18/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "MunchiesViewController.h"
#import "Helper.h"
#import <Parse/Parse.h>

@interface MunchiesViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UILabel *lfCredit;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIActivityItemProvider *itemProvider;
@property (strong, nonatomic) NSString *credit;
@end

@implementation MunchiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     _btnShare.useActivityIndicator = YES;
    [_activityIndicator startAnimating];
    
//    [self checkHistory];
    
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *err) {
        if (!err)
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            NSNumber *credit = [NSNumber numberWithLong:[[Branch getInstance] getCredits]];

            NSString *formatted = [formatter stringFromNumber:credit];
            
            _lfCredit.text = [NSString stringWithFormat:@"%@", formatted];
            [_activityIndicator stopAnimating];
        }
        else
            [_activityIndicator stopAnimating];
    }];
        
    PFUser *currentUser = [PFUser currentUser];
    NSString *username = currentUser.username;
    NSString *phone = [currentUser objectForKey:@"phoneNumber"];
    NSString *name = [currentUser objectForKey:@"name"];
    NSString *customerID = [currentUser objectForKey:@"customerID"];
    
    NSArray *tags = @[@"fooze", @"food"];
    NSString *feature = @"invite";
    NSString *stage = @"1";
    
    // Custom data
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:username forKey:@"username"];
    if (phone)
        [params setObject:phone forKey:@"phone"];
    if (name)
        [params setObject:name forKey:@"name"];
    if (customerID)
        [params setObject:customerID forKey:@"customerID"];
    
    _itemProvider = [Branch getBranchActivityItemWithParams:params feature:feature stage:stage tags:tags];

    // Adding a link -- Branch UIActivityItemProvider
    //UIActivityItemProvider *itemProvider = [Branch getBranchActivityItemWithParams:params andFeature:feature andStage:stage andTags:tags];
    
    NSDictionary *flurryparams = [NSDictionary dictionaryWithObjectsAndKeys: @"Munchies", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:flurryparams];

}

//- (void)checkHistory
//{
//    [[Branch getInstance] getCreditHistoryWithCallback:^(NSArray *history, NSError *error) {
//        if (!error) {
//            NSLog(@"history = %@", history);
//            
//            for (int ii=0; ii < [history count]; ii++) {
//                NSDictionary *transaction = [[history objectAtIndex:ii] objectForKey:@"transaction"];
//                NSLog(@"transaction = %@", transaction);
//                
//                NSString *bucket = [[transaction objectForKey:@"bucket"] uppercaseString];
//                if ([bucket isEqualToString:@"FOOD"])
//                {
//                    int type = [[transaction objectForKey:@"type"] intValue];
//                    
//                    if (type == 0)
//                    {
//                        NSString *amount = [transaction objectForKey:@"amount"];
//                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                        
//                        [defaults setValue:amount forKey:@"free_food_count"];
//                        [defaults synchronize];
//                    }
//                }
//            }
//            
//        }
//    }];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnShare setBackgroundColor:[UIColor foozeOrange]];
    _btnShare.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    _btnShare.layer.cornerRadius = _btnShare.frame.size.height/10.;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender
{
//#warning temp
//    return;
    
    _btnShare.enabled = NO;
    
    // Adding text
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *shareString = [defaults valueForKey:@"share_message"];

    if (!shareString)
    {
        shareString = @"Amazing Fooze I want to share!";
    }
    
    // Adding an image
    UIImage *amazingImage = [UIImage imageNamed:@"fooze_sharing.jpg"];
    
//    NSString *urlString = @"http://www.foozeapp.com";
//    NSURL *url = [NSURL URLWithString:urlString];
    
    
    // Pass this in the NSArray of ActivityItems when initializing a UIActivityViewController
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString, amazingImage, _itemProvider] applicationActivities:nil];
    
    // Present the share sheet!
    [self.navigationController presentViewController:shareViewController animated:YES completion:nil];
    
    [_btnShare setBackgroundColor:[UIColor foozeOrange]];
    _btnShare.enabled = YES;
    
    [[Appboy sharedInstance] logCustomEvent:@"Free Munchies - Share" withProperties:@{@"Share String":shareString}];

    /*
    NSArray *activityItems;
    
    activityItems = @[url];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
    */
    /*
    // Adding text
    NSString *shareString = @"Super amazing thing I want to share!";
    
    // Adding an image
    UIImage *amazingImage = [UIImage imageNamed:@"Super-Amazing-Image.png"];
    
    // Custom data
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Joe" forKey:@"user"];
    [params setObject:@"https://s3-us-west-1.amazonaws.com/myapp/joes_pic.jpg" forKey:@"profile_pic"];
    [params setObject:@"Joe likes long walks on the beach..." forKey:@"description"];
    [params setObject:@"Joe's My App Referral" forKey:@"$og_title"];
    [params setObject:@"https://s3-us-west-1.amazonaws.com/myapp/joes_pic.jpg" forKey:@"$og_image_url"];
    [params setObject:@"Join Joe in My App - it's awesome" forKey:@"$og_description"];
    [params setObject:@"http://myapp.com/desktop_splash" forKey:@"$desktop_url"];
    
    NSArray *tags = @[@"tag1", @"tag2"];
    NSString *feature = @"invite";
    NSString *stage = @"2";
    
    // Adding a link -- Branch UIActivityItemProvider
    UIActivityItemProvider *itemProvider = [Branch getBranchActivityItemWithParams:params andFeature:feature andStage:stage andTags:tags];
    
    // Pass this in the NSArray of ActivityItems when initializing a UIActivityViewController
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString, amazingImage, itemProvider] applicationActivities:nil];
    
    // Present the share sheet!
    [self.navigationController presentViewController:shareViewController animated:YES completion:nil];
    */
    
//    self.actionsSheet =
//    [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self
//                       cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
//                       otherButtonTitles:@"Email", @"SMS", @"Others", nil];
//    
//    self.actionsSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [self.actionsSheet showInView:self.view];
}

- (IBAction)touchDownShare:(id)sender
{
    [_btnShare setBackgroundColor:[UIColor foozeBlue]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark -
//#pragma mark - Action Sheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (actionSheet == _actionsSheet) {
//        self.actionsSheet = nil;
//        if (buttonIndex != actionSheet.cancelButtonIndex) {
//            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
////                [self sendEmailNow];
//            }
//        }
//    }
//}

@end
