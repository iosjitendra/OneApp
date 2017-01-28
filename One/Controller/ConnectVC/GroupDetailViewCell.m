//
//  FilterTableViewCell.m
//  FilterDemo
//
//  Created by Daksha Mac 3 on 10/11/15.
//  Copyright © 2015 Daksha Mac 3. All rights reserved.
//
#import "GroupDetailViewCell .h"

@implementation GroupDetailViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2;
    self.imgView.clipsToBounds = YES;
}

@end
