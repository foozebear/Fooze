//
//  OnboardTwoViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/17/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "OnboardTwoViewController.h"

@interface OnboardTwoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;

@end

@implementation OnboardTwoViewController

- (void)viewDidLoad {
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
    
    if( IS_IPHONE_4 )
    {
        _imgPhoto.image = [UIImage imageNamed:@"walkthrough2_4S.jpg"];
    }
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
    [self.delegate continueToOnboardThree:self];
//    [self performSegueWithIdentifier:@"segueToOnboardThree" sender:self];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.delegate backToOnboardOne:self];
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
