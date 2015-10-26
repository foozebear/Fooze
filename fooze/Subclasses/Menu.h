//
//  Menu.h
//  fooze
//
//  Created by Cris Padilla Tagle on 6/28/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import <Parse/Parse.h>

@interface Menu : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *menuID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic) float price;
@property (nonatomic, strong) NSString *restaurant;
@property (nonatomic, strong) NSArray *zipcodes;
@property (nonatomic, strong) NSString *details;
+ (NSString *)parseClassName;

@end
