//
//  OnBoardingMenuViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 10/9/15.
//  Copyright © 2015 Fooze. All rights reserved.
//

#import "OnBoardingMenuViewController.h"
#import "Helper.h"

#import "OnboardingMenuTableViewCell.h"

@interface OnBoardingMenuViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *vwBottomBar;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIImageView *imgDone;

@property (strong, nonatomic) NSMutableArray *aryMenu;
@property (strong, nonatomic) NSMutableArray *aryMenuImages;
@property (nonatomic) float prevContentOffsetY;
@property (nonatomic) BOOL bFetching;
@end

@implementation OnBoardingMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _aryMenu = [[NSMutableArray alloc] init];
    _aryMenuImages = [[NSMutableArray alloc] init];
    
    [self getMenu];
    [self getNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showAlert:(NSString *)title withMsg:(NSString *)msg
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    
    [alert alertIsDismissed:^{
        [self getMenu];
    }];
    
    [alert showCustom:self image:[UIImage imageNamed:@"logoFooze.png"] color:[UIColor foozeOrange] title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0f];
}


- (IBAction)goBack:(id)sender
{
    [self.delegate showWelcomeFromOnboardingMenu:self];
}

- (IBAction)scrollToBottom:(id)sender
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
//    CGFloat calculatedPosY = 300;
//    [UIView animateWithDuration:0.8
//                     animations:^{self.tableView.contentOffset = CGPointMake(0.0, calculatedPosY);}
//                     completion:^(BOOL finished){ }];
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            return 70;
        }
        else return 0;
    }
    
    CGFloat ht = (self.view.frame.size.height - 95. ) / 3;
    return ht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnboardingMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];

    cell.imgMenu.layer.cornerRadius = cell.imgMenu.frame.size.height / 2.;

    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    }
    else if (indexPath.section == 1)
    {
        if ([_aryMenu count] > indexPath.row) {
            Menu *menu = [_aryMenu objectAtIndex:indexPath.row];
            cell.lblMenu.text = menu.name;
        }
        if ([_aryMenuImages count] > indexPath.row) {
            cell.imgMenu.image = [_aryMenuImages objectAtIndex:indexPath.row];
        }
        
//        [cell.btnMenu addTarget:self action:@selector(showFoodDetails:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)getMenu
{
    _bFetching = YES;

    PFQuery *queryServing = [PFQuery queryWithClassName:@"OnBoardMenu"];
//    [queryServing whereKey:@"zipcode" equalTo:zipcode];
    [queryServing includeKey:@"product"];
    [queryServing includeKey:@"product.restaurant"];
    [queryServing orderByAscending:@"createdAt"];
    
    [queryServing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             if ([objects count] > 0)
             {
                 NSLog(@"servings = %@", objects);
   
                 _bFetching = NO;
                 for (PFObject *object in objects)
                 {
                     //PFObject *product = [[objects objectAtIndex:0] objectForKey:@"product"];
                     PFObject *product = [object objectForKey:@"product"];
                     PFObject *restaurant = [product objectForKey:@"restaurant"];

                     NSLog(@"product = %@ and resto = %@", product, restaurant);
                     
                     Menu *menu = [[Menu alloc] init];
                     
                     menu.name = [product objectForKey:@"name"];
                     menu.price = [[product objectForKey:@"price"] floatValue];
                     menu.category = [product objectForKey:@"category"];
                     menu.menuID = product.objectId;
                     menu.restaurant = [restaurant objectForKey:@"name"];
                     menu.zipcodes = [restaurant objectForKey:@"serving_zipcodes"];
                     menu.details = [product objectForKey:@"description"];
                     
                     [_aryMenu addObject:menu];
                     
                     PFFile *userImageFile = product[@"image"];
                     [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                         if (!error) {
                             UIImage *image = [UIImage imageWithData:imageData];
                             [_aryMenuImages addObject:image];
                             [self.tableView reloadData];
                         }
                         else
                         {
                             NSLog(@"Error: %@", error);
                         }
                     }];

                 }
             }
         }
         
         [self.tableView reloadData];
     }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_aryMenu count] == 0)
    {
        [self showAlert:@"Updating" withMsg:@"Please wait for Fooze to update your menu."];
        return;
    }

    Menu *menu = [_aryMenu objectAtIndex:indexPath.row];
    
    [[Appboy sharedInstance] logCustomEvent:@"Onboarding Menu - Chose Food" withProperties:@{@"Food":menu.name, @"Restaurant":menu.restaurant}];
    
    [self.delegate showOnboardingMenuOrder:self withMenu:menu];
    
    NSLog(@"data = %@", menu);

}

- (void)showDoneControl:(BOOL)show
{
    if (show)
    {
        [UIView beginAnimations:@"animation" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        _btnDone.hidden = NO;
        _imgDone.hidden = NO;
        _imgDone.alpha = 1.0f;
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"animation" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        _imgDone.alpha = 0.0f;
        _btnDone.hidden = YES;
        
        [UIView commitAnimations];
    }
}

- (void)showBottomBar:(BOOL)show
{
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenBound.size;
    
    if (show)
    {
        [UIView beginAnimations:@"animation" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        CGRect navBarFrame = CGRectMake(0, self.view.frame.size.height - _vwBottomBar.frame.size.height, _vwBottomBar.frame.size.width, _vwBottomBar.frame.size.height);
        self.vwBottomBar.frame = navBarFrame;
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"animation" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        
        self.vwBottomBar.frame = CGRectMake(0., self.view.bounds.size.height, self.view.bounds.size.width, _vwBottomBar.frame.size.height);
        [UIView commitAnimations];
    }
}

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
                     if ([purpose isEqualToString:@"confirm"])
                     {
                         NSString *notification = [object objectForKey:@"message"];
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setValue:notification forKey:@"fooze_confirm"];
                         [defaults synchronize];
                     }
                 }
             }
         }
     }];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView ==  self.tableView)
    {
        CGFloat contentYoffset = scrollView.contentOffset.y;
        CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset - 1.;
        CGFloat height = scrollView.frame.size.height;
        
        NSLog(@"distanceFromBottom = %f and height = %f", distanceFromBottom, height);
        if(distanceFromBottom < height)
        {
            NSLog(@"At the bottom");
            [self showDoneControl:YES];
        }
        else if(scrollView.contentOffset.y == 0) {
//            NSLog(@"At the top");
//            [self showDoneControl:NO];
        }
        
        if (_prevContentOffsetY < scrollView.contentOffset.y)
        {
            _prevContentOffsetY = scrollView.contentOffset.y;
//            NSLog(@"upwards");
            [self showBottomBar:NO];
        }
        else {
            _prevContentOffsetY = scrollView.contentOffset.y;
//            NSLog(@"downwards");
            [self showBottomBar:YES];
            //[self adjustTopbarViewNow:(_navBarOffset - scrollView.contentOffset.y)];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
    if (scrollView == self.tableView)
    {
        //[self showButtons:NO];
    }
}

@end
