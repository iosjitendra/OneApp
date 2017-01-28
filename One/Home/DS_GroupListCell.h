//
//  DS_GroupListCell.h
//  CountryHillElementary
//
//  Created by Daksha on 12/12/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DS_GroupListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewFav;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCheckmark;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@end
