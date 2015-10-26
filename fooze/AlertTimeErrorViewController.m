//
//  AlertTimeErrorViewController.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/3/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import "AlertTimeErrorViewController.h"
#import "ScheduleTableViewCell.h"

@interface AlertTimeErrorViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *schedule;
@end

@implementation AlertTimeErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( IS_IPHONE_4 )
    {
        _imgPhoto.image = [UIImage imageNamed:@"bgSorryHour_4S.jpg"];
    }
    
    [self getSchedule];
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

- (void)getSchedule
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _schedule = [defaults valueForKey:@"Schedule"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    switch (indexPath.row)
    {
        case 0:
        {
            NSDictionary *sched = [_schedule objectForKey:@"SUNDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                //When the closing time is the closing time of the previous day
                //start_time is later than end_time
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                    [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"MONDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                    [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
 
            cell.lblDay.text = @"SUN";
            
            break;
        }
        case 1:
        {
            NSDictionary *sched = [_schedule objectForKey:@"MONDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"TUESDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
            cell.lblDay.text = @"MON";
            
            break;
        }
        case 2:
        {
            NSDictionary *sched = [_schedule objectForKey:@"TUESDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"WEDNESDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];

            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
            
            cell.lblDay.text = @"TUES";
            
            break;
        }
        case 3:
        {
            NSDictionary *sched = [_schedule objectForKey:@"WEDNESDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"THURSDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
            
            
            cell.lblDay.text = @"WED";
            
            break;
        }
        case 4:
        {
            NSDictionary *sched = [_schedule objectForKey:@"THURSDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"FRIDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
            cell.lblDay.text = @"THURS";
            
            break;
        }
        case 5:
        {
            NSDictionary *sched = [_schedule objectForKey:@"FRIDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"SATURDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
            cell.lblDay.text = @"FRI";
            
            break;
        }
        case 6:
        {
            NSDictionary *sched = [_schedule objectForKey:@"SATURDAY"];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSDate *start_time = [dateFormat dateFromString:[sched objectForKey:@"start_time"]];
            NSDate *end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
            
            if ([start_time compare:end_time] == NSOrderedDescending)
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                sched = [_schedule objectForKey:@"SUNDAY"];
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            else
            {
                NSString *min = [[sched objectForKey:@"start_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblStartTime.text = [dateFormat stringFromDate:start_time];
                
                [dateFormat setDateFormat:@"HH:mm:ss"];
                end_time = [dateFormat dateFromString:[sched objectForKey:@"end_time"]];
                
                min = [[sched objectForKey:@"end_time"] substringWithRange:NSMakeRange(3, 2)];;
                
                if ([min isEqualToString:@"00"]) {
                    [dateFormat setDateFormat:@"h a"];
                }
                else
                [dateFormat setDateFormat:@"h:mm a"];
                cell.lblEndTime.text = [dateFormat stringFromDate:end_time];
            }
            
            
            cell.lblDay.text = @"SAT";
            
            break;
        }
    }
    
    
    return cell;
}




@end
