//
//  UIButton+Activity.h
//  Zynappse Corporation
//
//  Created by Cris Padilla Tagle on 2/28/15.
//  Copyright (c) 2015 Zynappse Corporation. All rights reserved.
//
//  Use to display activity indicator inside UIButton

#import <UIKit/UIKit.h>

#ifndef IBInspectable
#define IBInspectable
#endif

@interface UIButton (Activity)

@property (readwrite, setter=useActivityIndicator:, getter=getUseActivityIndicator) IBInspectable BOOL useActivityIndicator;
-(void)updateActivityIndicatorVisibility;

@end
