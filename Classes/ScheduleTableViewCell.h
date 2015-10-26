//
//  ScheduleTableViewCell.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 8/6/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *lblDay;
@property (nonatomic, strong) IBOutlet UILabel *lblStartTime;
@property (nonatomic, strong) IBOutlet UILabel *lblEndTime;
@end
