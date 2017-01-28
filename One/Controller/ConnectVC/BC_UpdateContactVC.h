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
@protocol DSContactDetailScreenDelegate <NSObject>

-(void)updateContactDetails;

@end
@interface BC_UpdateContactVC : ECSBaseViewController
@property (nonatomic, strong) ContactObject *selectedContactsData;
@property(strong,nonatomic) NSString *memContactId;
@property (assign) id <DSContactDetailScreenDelegate> delegate;
-(id)initWithContactDetail:(NSNumber *)ContactId;
@end
