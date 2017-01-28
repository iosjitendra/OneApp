//
//  CH_SoonVC.h
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 03/08/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface CH_SoonVC : UIViewController <MPMediaPickerControllerDelegate,AVAudioPlayerDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIImageView *artworkImageView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *albumLabel;
    
    IBOutlet UISlider *volumeSlider;
    NSArray*array;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIButton *showMediaButton;
    IBOutlet UIButton *ShuffleSongs;
    IBOutlet UILabel *ShuffleMode;
    NSData*arrya;
    NSMutableArray*arry;
    NSTimer*timer;
}


- (IBAction)showMediaPicker:(id)sender;

- (IBAction)volumeChanged:(id)sender;

- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void) registerMediaPlayerNotifications;


@end
