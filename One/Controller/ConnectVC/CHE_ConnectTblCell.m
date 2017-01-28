//
//  CHE_ConnectTblCell.m
//  CountryHillElementary
//
//  Created by Daksha on 9/5/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CHE_ConnectTblCell.h"

@implementation CHE_ConnectTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImg.layer.cornerRadius = self.userImg.frame.size.height/2;
    self.userImg.clipsToBounds = YES;
    
    // border
    [self.userImg.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.userImg.layer setBorderWidth:2.0f];
    
    // drop shadow
    [self.userImg.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.userImg.layer setShadowOpacity:0.8];
    [self.userImg.layer setShadowRadius:3.0];
    [self.userImg.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
