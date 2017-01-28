//
//  BC_NewContactVC.h
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSBaseViewController.h"
#import "ContactObject.h"
@interface BC_AddContactVC : ECSBaseViewController
@property (nonatomic, strong) ContactObject *selectedContactsData;
@property (strong,nonatomic) NSString *openWithGroup;
@end
