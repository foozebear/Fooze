//
//  OnboardingMenuTableViewCell.m
//  Fooze
//
//  Created by Cris Padilla Tagle on 10/10/15.
//  Copyright © 2015 Fooze. All rights reserved.
//

#import "OnboardingMenuTableViewCell.h"

@implementation OnboardingMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.imgMenu.frame = CGRectMake(self.imgMenu.frame.origin.x, self.imgMenu.frame.origin.y, 155, 155);
    self.imgMenu.layer.cornerRadius = self.imgMenu.frame.size.height / 2.;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
//    self.imgMenu.image = nil;
    self.imgMenu.layer.cornerRadius = self.imgMenu.frame.size.height / 2.;
    
}
@end
