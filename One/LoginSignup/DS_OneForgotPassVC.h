//
//  DS_OneForgotPassVC.h
//  One
//
//  Created by Daksha on 1/20/17.
//  Copyright © 2017 Daksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersDetails.h"
#import "ECSBaseViewController.h"
@interface DS_OneForgotPassVC : ECSBaseViewController
@property(strong,nonatomic)NSString *username1;
@property(strong,nonatomic)NSString *token;
@property(strong,nonatomic) UsersDetails *userData;
@end
