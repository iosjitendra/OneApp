//
//  DVGStreamSelectionViewController.h
//  NineHundredSeconds
//
//  Created by Nikolay Morev on 03.10.14.
//  Copyright (c) 2014 DENIVIP Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVGStreamsDataController.h"

@interface DVGStreamSelectionViewController : UIViewController <DVGStreamsDataControllerDelegate>
@property (nonatomic, strong) DVGStreamsDataController *dataController;
@property (nonatomic, strong) NSString *ChpStreamId;

- (void)streamsDataControllerDidUpdateStreams:(DVGStreamsDataController *)controller;
@end
