////
////  CH_ChatScreen.h
////  CountryHillElementary
////
////  Created by Daksha Mac 3 on 27/07/16.
////  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
////
//
#import <UIKit/UIKit.h>

#import "ECSBaseViewController.h"

@interface CH_ChatScreen : ECSBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
- (IBAction)clickOnSend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *launchChatList;
@property(nonatomic,strong) UIActivityIndicatorView *activityView;
@end
