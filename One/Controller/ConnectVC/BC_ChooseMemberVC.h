//
//  BC_NewContactVC.h
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"

@interface BC_ChooseMemberVC : ECSBaseViewController
@property (strong ,nonatomic) NSMutableArray *arrayGroupMembers;
-(id)initWithGroupDetail:(NSNumber *)GroupID;
@end
