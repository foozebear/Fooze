//
//  Menu.m
//  fooze
//
//  Created by Cris Padilla Tagle on 6/28/15.
//  Copyright (c) 2015 alexrussell. All rights reserved.
//

#import "Menu.h"
#import <Parse/PFObject+Subclass.h>

@implementation Menu

@dynamic menuID;
@dynamic name;
@dynamic category;
@dynamic price;
@dynamic restaurant;
@dynamic zipcodes;
@dynamic details;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Menu";
}

@end
