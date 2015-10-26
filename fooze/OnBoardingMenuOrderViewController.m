//
//  OnBoardingMenuOrderViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 10/10/15.
//  Copyright © 2015 Fooze. All rights reserved.
//

#import "OnBoardingMenuOrderViewController.h"
#import "AppboyKit.h"

@interface OnBoardingMenuOrderViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblRestoName;
@property (strong, nonatomic) IBOutlet UILabel *lblFood;
@property (strong, nonatomic) IBOutlet UIView *vwThatsRight;
@property (strong, nonatomic) IBOutlet UILabel *lblCenterMessage;

@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnThatsRight;
@property (strong, nonatomic) IBOutlet UIImageView *imgPlus;
@property (strong, nonatomic) IBOutlet UIImageView *imgPlusYellow;
@property (strong, nonatomic) IBOutlet UIImageView *imgMinus;
@property (strong, nonatomic) IBOutlet UIImageView *imgMinusYellow;
@end

@implementation OnBoardingMenuOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fooze_confirm = [defaults valueForKey:@"fooze_confirm"];
    
    if (fooze_confirm)
    {
        NSArray *array = [fooze_confirm componentsSeparatedByString: @"|"];
        
        NSString *message = nil;
        
        if ([array count] > 1)
        {
            for (NSString *string in array)
            {
                if (message)
                    message = [NSString stringWithFormat:@"%@\n%@", message, string];
                else
                    message = string;
            }
        }
        else
            message = fooze_confirm;
        
        _lblCenterMessage.text = message;
    }
    else
        _lblCenterMessage.text = @"Quality late night food\n1-tap ordering\nSpeedy Delivery";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateDetails];
}

- (void)viewDidLayoutSubviews
{
    _vwThatsRight.layer.cornerRadius = _vwThatsRight.frame.size.height/10.;
}

- (IBAction)back:(id)sender
{
    [self.delegate goBackToMenuFromOnboardingMenuOrder:self];
}

- (IBAction)goBack:(id)sender
{
    [[Appboy sharedInstance] logCustomEvent:@"Onboarding Menu Order - No, I'd rather starve" withProperties:@{@"Food":_menu.name, @"Restaurant":_menu.restaurant}];

    [self.delegate showWelcomeFromOnboardingMenuOrder:self];
}

- (IBAction)registerNow:(id)sender
{
    [[Appboy sharedInstance] logCustomEvent:@"Onboarding Menu Order - I love Food" withProperties:@{@"Food":_menu.name, @"Restaurant":_menu.restaurant}];
    
    [self.delegate signupFromOnboardingMenuOrder:self];
}

- (void)updateDetails
{
    
    NSString *resto = [NSString stringWithFormat:@"%@:", [_menu.name capitalizedString]];
    resto = [resto stringByReplacingOccurrencesOfString:@"Nyc" withString:@"NYC"];
    
    _lblRestoName.text = resto;
    _lblFood.text = _menu.details;
    
}


@end
