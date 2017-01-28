//
//  BC_NewContactVC.h
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
#import "BC_ResetPassword.h"
@interface BC_ResetPassword : ECSBaseViewController
{
    
}
-(id)initWithUsername:(NSString *)usernamel withToken:(NSString *)token;
@property(strong,nonatomic)NSString *username1;
@property(strong,nonatomic)NSString *token;
@property(nonatomic, assign) UIColor* borderIBColor;
@end
