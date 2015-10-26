//
//  AlertDeliveryErrorViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/3/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "AlertDeliveryErrorViewController.h"

@interface AlertDeliveryErrorViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@end

@implementation AlertDeliveryErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( IS_IPHONE_4 )
    {
        _imgPhoto.image = [UIImage imageNamed:@"bgSorryHour_4S.jpg"];
    }
    
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

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
