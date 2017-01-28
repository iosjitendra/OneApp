//
//  DS_HomeCollectioncell.m
//  FanfuroSB
//
//  Created by Daksha_Mac4 on 11/23/15.
//  Copyright © 2015 Daksha_Mac4. All rights reserved.
//

#import "BC_ContactCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BC_ContactCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.restorationIdentifier = @"Cell";
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingNone;
//        self.img_view.layer.cornerRadius = self.img_view.frame.size.width / 2;
//        self.img_view.clipsToBounds = YES;
        
        CGFloat borderWidth = 3.0f;
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.layer.borderColor = [UIColor redColor].CGColor;
        bgView.layer.borderWidth = borderWidth;
        self.selectedBackgroundView = bgView;
        
        CGRect myContentRect = CGRectInset(self.contentView.bounds, borderWidth, borderWidth);
        
        UIView *myContentView = [[UIView alloc] initWithFrame:myContentRect];
        myContentView.backgroundColor = [UIColor whiteColor];
        myContentView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
        myContentView.layer.borderWidth = borderWidth;
        [self.contentView addSubview:myContentView];
        
        
 
    }
    return self;
}


@end
