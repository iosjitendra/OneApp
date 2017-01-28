//
//  DS_GroupListCell.m
//  CountryHillElementary
//
//  Created by Daksha on 12/12/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "DS_GroupListCell.h"

@implementation DS_GroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2;
    self.imgView.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
