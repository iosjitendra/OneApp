//
//  DS_ContactCell.h
//  One
//
//  Created by Daksha on 1/12/17.
//  Copyright © 2017 Daksha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DS_ContactCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_view;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblOffer;
@end
