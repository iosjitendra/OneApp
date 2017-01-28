//
//  BC_NewContactVC.h
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
#import "GroupObject.h"
@protocol DSGroupDetailScreenDelegate <NSObject>



@end
@interface BC_GroupDetailVC : ECSBaseViewController
@property (nonatomic, strong) GroupObject *selectedGroupData;

@property (assign) id <DSGroupDetailScreenDelegate> delegate;
-(id)initWithGroupDetail:(NSNumber *)GroupID;
@end
