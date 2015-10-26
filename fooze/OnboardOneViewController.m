//
//  OnboardOneViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/17/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "OnboardOneViewController.h"
#import "Helper.h"

@interface OnboardOneViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto1;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto2;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto3;
@end

@implementation OnboardOneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    if (_page == 1)
    {
        _imgPhoto1.alpha = 1.;
        _imgPhoto2.alpha = 0.;
        _imgPhoto3.alpha = 0.;
    }
    else
    {
        _imgPhoto1.alpha = 0.;
        _imgPhoto2.alpha = 0.;
        _imgPhoto3.alpha = 1.;
    }
    
    if( IS_IPHONE_4 )
    {
        _imgPhoto1.image = [UIImage imageNamed:@"walkthrough1_4S.jpg"];
        _imgPhoto2.image = [UIImage imageNamed:@"walkthrough2_4S.jpg"];
        _imgPhoto3.image = [UIImage imageNamed:@"walkthrough3_4S.jpg"];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"Onboard", @"Page", nil];
    [Flurry logEvent:@"Views" withParameters:params];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapped:(UITapGestureRecognizer*)gestureRecognizer
{
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    _page++;
    
    if (_page < 4)
    {
        switch (_page) {
            case 2:
            {
                [UIView beginAnimations:@"animation2" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.6f];
                
                _imgPhoto1.alpha = 0.;
                _imgPhoto2.alpha = 1.;
                _imgPhoto3.alpha = 0.;
                [UIView commitAnimations];
                break;
            }
            case 3:
            {
                [UIView beginAnimations:@"animation2" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.6f];
                
                _imgPhoto1.alpha = 0.;
                _imgPhoto2.alpha = 0.;
                _imgPhoto3.alpha = 1.;
                [UIView commitAnimations];
                break;
            }
            default:
                break;
        }        
    }
    else
    {
        [self.delegate  continueToSignupFromOnboardOne:self];
    }
    
//    [self performSegueWithIdentifier:@"segueToOnboardTwo" sender:self];
//    [self.delegate continueToOnboardTwo:self];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    _page--;
    
    if (_page > 0)
    {
        switch (_page) {
            case 1:
            {
                [UIView beginAnimations:@"animation2" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.6f];
                
                _imgPhoto1.alpha = 1.;
                _imgPhoto2.alpha = 0.;
                _imgPhoto3.alpha = 0.;
                [UIView commitAnimations];
                break;
            }
            case 2:
            {
                [UIView beginAnimations:@"animation2" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.6f];
                
                _imgPhoto1.alpha = 0.;
                _imgPhoto2.alpha = 1.;
                _imgPhoto3.alpha = 0.;
                [UIView commitAnimations];
                break;
            }
            default:
                break;
        }
    }
    else
        [self.delegate showWelcomeAgainFromOnboard:self];
    
//    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
