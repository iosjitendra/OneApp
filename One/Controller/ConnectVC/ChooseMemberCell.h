//
//  FilterTableViewCell.h
//  FilterDemo
//
//  Created by Daksha Mac 3 on 10/11/15.
//  Copyright © 2015 Daksha Mac 3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewFav;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCheckmark;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property BOOL isChecked;
@end
