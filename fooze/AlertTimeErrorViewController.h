//
//  AlertTimeErrorViewController.h
//  Fooze
//
//  Created by Cris Padilla Tagle on 7/3/15.
//  Copyright (c) 2015 Fooze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@interface AlertTimeErrorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end
