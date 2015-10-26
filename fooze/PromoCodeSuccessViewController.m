//
//  PromoCodeSuccessViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 8/1/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "PromoCodeSuccessViewController.h"
#import "Helper.h"


@interface PromoCodeSuccessViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnFeedMe;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblGreat;

@end

@implementation PromoCodeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"PromoCodeSuccess", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _lblGreat.text = [NSString stringWithFormat:@"Great! You have received $%@.", _promo_amount];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    _btnFeedMe.layer.cornerRadius = _btnFeedMe.frame.size.height/10.;
}

- (IBAction)touchDownFeedMe:(id)sender
{
    [_btnFeedMe setBackgroundColor:[UIColor foozeBlue]];
}

- (IBAction)feedMe:(id)sender
{
    if (_bSettings)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.delegate goBackToConfirmViewFromPromoCodeSuccess:self withCredit:_credit];
}



@end
