//
//  WelcomeViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/7/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Helper.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnFoozeAway;
@property (strong, nonatomic) IBOutlet UIView *vwFoozeAway;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (strong, nonatomic) NSString *strImage;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( IS_IPHONE_4 )
    {
        _imgPhoto.image = [UIImage imageNamed:@"bgWelcome_4S.jpg"];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Welcome", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_vwFoozeAway setBackgroundColor:[UIColor foozeTurquoise]];
    self.mainView.hidden = YES;
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
    _vwFoozeAway.layer.cornerRadius = _vwFoozeAway.frame.size.height/10.;
}

- (IBAction)foozeAway:(id)sender
{
    [[Appboy sharedInstance] logCustomEvent:@"Fooze Away from Welcome"];
    
    [self.delegate continueFromWelcomeToOnboardingMenu:self];
    
//    [self.delegate continueFromWelcomeToOnboard:self];
//    [self.delegate continueFromWelcomeToSignUp:self];
//    [self createWalkthrough];
}

- (IBAction)tapDown:(id)sender
{
    [_vwFoozeAway setBackgroundColor:[UIColor foozeYellow]];
}

- (IBAction)login:(id)sender
{
//    [self performSegueWithIdentifier:@"segueToLogin" sender:self];
    [self.delegate continueFromWelcomeToLogin:self];
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
    //[self performSegueWithIdentifier:@"segueToSignUp" sender:self];

    [self.delegate continueFromWelcomeToSignUp:self];
}

@end
