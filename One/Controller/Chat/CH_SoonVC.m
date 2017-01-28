//
//  CH_SoonVC.m
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 03/08/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CH_SoonVC.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@interface CH_SoonVC ()

@end

@implementation CH_SoonVC
//@synthesize arrya;
#pragma mark - Memory management

- (void)dealloc
{
    appDelegate.musicPlayer1.delegate=nil;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self intializeArrayForMusicPlayerANDMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self volumeSliderDown];
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTimeVolume"]==nil)
    {
        [[NSUserDefaults standardUserDefaults]setFloat:volumeSlider.value forKey:@"Volume"];
        [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"FirstTimeVolume"];
    }
    else{
        
        volumeSlider.value=[[NSUserDefaults standardUserDefaults]floatForKey:@"Volume"];
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self intializeArrayForMusicPlayerANDMemoryWarning];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChangedFromOutside:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
    [self CheckForPlayerButtonInitial];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self UpdateShffuleLabelIntial];
}
-(void)CheckForPlayerButtonInitial{
    
    if (appDelegate.musicPlayer1.isPlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Play"];
        appDelegate.musicPlayer1.volume=volumeSlider.value;
        
    } else {
        
        [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Play"];
        
        
    }
}
-(void)volumeSliderDown{
    
    
    
}
-(void)UpdateShffuleLabelIntial{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"]!=nil) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"] isEqualToString:@"On"]){
            [self updateShuffleLabel:YES];
            
        }else{
            
            [self updateShuffleLabel:NO];
            [[NSUserDefaults standardUserDefaults]setObject:@"Off" forKey:@"Shuffle"];
            
        }
    }
    else{
        [self updateShuffleLabel:NO];
        [[NSUserDefaults standardUserDefaults]setObject:@"Off" forKey:@"Shuffle"];
        
    }
}
-(void)intializeArrayForMusicPlayerANDMemoryWarning{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"]isEqualToString:@"On"]) {
        arrya= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArrayRandom"];
        
    }else{
        
        arrya= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArray"];
        
        
    }
    arry=[NSKeyedUnarchiver unarchiveObjectWithData:arrya];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBorderAndColorButton];
    [self viewDidLoadIntializationMusicIfPlaying];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    
}
- (void)applicationEnteredForeground:(NSNotification *)notification {
    
    
    //    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
    //
    //        [playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
    //
    //    } else {
    //
    //        [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    //    }
    
    [self updateUIForCurrentItem];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    AppDelegate  *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] removeObserver:appDel.observer];
    
    
    // by HHT
    __block CH_SoonVC *playerObj = self;
    
    appDel.observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"PausePlayerObserverKey" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [playerObj handlePlaybackStateChangedPlayer:note];
    }] ;
    
    //    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    //    NSArray *playlists = [query collections];
    //
    //    for(int i = 0; i < [playlists count]; i++)
    //    {
    //        NSLog(@"Playlist : %@", [[playlists objectAtIndex:i] valueForProperty: MPMediaPlaylistPropertyName]);
    //    }
    
}

#pragma mark Set border color,width and corner radius

-(void)setBorderAndColorButton
{
    [[showMediaButton layer] setBorderWidth:1.0f];
    [[showMediaButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[showMediaButton layer] setCornerRadius:2.0f];
    [[ShuffleSongs layer] setBorderWidth:1.0f];
    [[ShuffleSongs layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[ShuffleSongs layer] setCornerRadius:2.0f];
}

#pragma mark Set Music Player

-(void)viewDidLoadIntializationMusicIfPlaying{
    
    [self checkforPlayingButton];
    
    [self updateUIForCurrentItem];
    [self registerMediaPlayerNotifications];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)checkforPlayingButton{
    if ([appDelegate.musicPlayer1 isPlaying]) {
        
        [playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        
        
    } else {
        [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        
    }
}
#pragma mark - Update UI

- (void)updateUIForCurrentItem {
    /* [[NSUserDefaults standardUserDefaults ]setObject:array forKey:@"MusicArray"];
     [[NSUserDefaults standardUserDefaults ]setInteger:0 forKey:@"MusicItem"];*/
    NSData*NSDataForArray;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"]isEqualToString:@"On"]) {
        NSDataForArray= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArrayRandom"];
        
    }else{
        
        NSDataForArray= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArray"];
        
        
    }
    NSMutableArray*arrayOfMusic=[NSKeyedUnarchiver unarchiveObjectWithData:NSDataForArray];
    
    MPMediaItem *currentItem = [arrayOfMusic objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"MusicItem"]];;
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    [artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        titleLabel.text = @"Title: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        artistLabel.text = @"Artist: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        albumLabel.text = @"Album: Unknown album";
    }
    titleString=nil;
    albumString=nil;
    artworkImage=nil;
    currentItem=nil;
    artwork=nil;
    NSDataForArray=nil;
}

- (void)updateShuffleLabel:(BOOL)isOn {
    if (isOn)
        ShuffleMode.text = @"Shuffle Mode: On";
    else
        ShuffleMode.text = @"Shuffle Mode: Off";
    
}

#pragma mark - Notifications

- (void) registerMediaPlayerNotifications
{
    
}


- (void) handle_NowPlayingItemChanged: (id) notification
{
    [self updateUIForCurrentItem];
}


- (void) handle_PlaybackStateChanged: (id) notification
{
    
}


- (void) handle_VolumeChanged: (id) notification
{
    
    
}

- (void)volumeChangedFromOutside:(NSNotification *)notification
{
    // Do stuff with volume
    
    float Devicevolume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
                          floatValue];
    
    [appDelegate.musicPlayer1 setVolume:Devicevolume];
    [volumeSlider setValue:Devicevolume];
    [[NSUserDefaults standardUserDefaults]setFloat:volumeSlider.value forKey:@"Volume"];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"outputVolume"])
    {
        [appDelegate.musicPlayer1 setVolume:[change[@"new"] floatValue]];
        [volumeSlider setValue:[change[@"new"] floatValue]];
        [[NSUserDefaults standardUserDefaults]setFloat:volumeSlider.value forKey:@"Volume"];
        
    }
}
#pragma mark - Media Picker

- (IBAction)showMediaPicker:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.showsCloudItems=NO;
    mediaPicker.prompt = @"Select songs to play";
    
    
    [self presentViewController:mediaPicker animated:YES completion:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    }];
}
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        
        [playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        NSMutableArray*array1=[[NSMutableArray alloc]init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        array=mediaItemCollection.items;
        array1=[array mutableCopy];
        NSUInteger count = [array1 count];
        
        if (count < 1) return;
        for (NSUInteger i = 0; i < count - 1; ++i) {
            NSInteger remainingCount = count - i;
            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
            [array1 exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:array1];
        
        [[NSUserDefaults standardUserDefaults ]setObject:data forKey:@"MusicArray"];
        [[NSUserDefaults standardUserDefaults ]setObject:data2 forKey:@"MusicArrayRandom"];
        
        [[NSUserDefaults standardUserDefaults ]setInteger:0 forKey:@"MusicItem"];
        [[NSUserDefaults standardUserDefaults ]setInteger:[array count] forKey:@"MusicArrayCount"];
        
        MPMediaItem*item=[array objectAtIndex:0];
        NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        NSError*Error;
        appDelegate. musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&Error];
        if (Error) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"An Error Occured to this song.Please select another song." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
            [appDelegate.musicPlayer1 stop];
            
        }
        
        else{
            [appDelegate.musicPlayer1 setDelegate:self];
            appDelegate.musicPlayer1.volume=volumeSlider.value;
            [appDelegate.musicPlayer1 prepareToPlay];
            [appDelegate.musicPlayer1 play];
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"]isEqualToString:@"On"]) {
            arrya= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArrayRandom"];
            
        }else{
            
            arrya= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArray"];
            
            
        }
        arry=[NSKeyedUnarchiver unarchiveObjectWithData:arrya];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Play"];
        [self updateCenterAudioInfo];
        data=nil;
        data2=nil;
        array=nil;
        item=nil;
        array1=nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playNextSong];
    [self updateUIForCurrentItem];
    [self updateCenterAudioInfo];
}


- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Controls

- (IBAction)volumeChanged:(id)sender
{
    [appDelegate.musicPlayer1 setVolume:[volumeSlider value]];
    MPMusicPlayerController*MusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    MusicPlayer.volume = [volumeSlider value]; // max volume
    [[NSUserDefaults standardUserDefaults]setFloat:volumeSlider.value forKey:@"Volume"];
    
}

- (IBAction)previousSong:(id)sender
{
    appDelegate.musicPlayer1=nil;
    
    [self playPreviousSong];
    [self updateUIForCurrentItem];
    [self updateCenterAudioInfo];
    
}

- (IBAction)playPause:(id)sender
{
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MusicArrayCount"]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please add songs from \"Add Music from Music App\"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    else{
        
        if (appDelegate.musicPlayer1.isPlaying) {
            
            [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
            [appDelegate.musicPlayer1 stop];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Play"];
            
        } else {
            
            [playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Play"];
            if (appDelegate.musicPlayer1==nil) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                
                //            [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:NULL];
                NSInteger x=  [[NSUserDefaults standardUserDefaults ]integerForKey:@"MusicItem"];
                MPMediaItem *item=[arry objectAtIndex:x];
                NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
                NSError*error;
                appDelegate.musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&error];
                NSLog(@"error:%@",error);
                if (error) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"An Error Occured to this song.Please select another song." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
                    [appDelegate.musicPlayer1 stop];
                    
                }
                
                else{
                    
                    [appDelegate.musicPlayer1 setDelegate:self];
                    [appDelegate.musicPlayer1 prepareToPlay];
                    appDelegate.musicPlayer1.volume=volumeSlider.value;
                    [appDelegate.musicPlayer1 setVolume:volumeSlider.value];
                    
                    [appDelegate.musicPlayer1 play];
                    [self updateUIForCurrentItem];
                    [self updateCenterAudioInfo];
                }
            }else{
                appDelegate.musicPlayer1.volume=volumeSlider.value;
                [appDelegate.musicPlayer1 setVolume:volumeSlider.value];
                
                [appDelegate.musicPlayer1 play];
                
            }
        }
    }
}

-(void)updateCenterAudioInfo{
    NSMutableDictionary *nowPlayingInfo = [[NSMutableDictionary alloc] init];
    [nowPlayingInfo setObject:titleLabel.text forKey:MPMediaItemPropertyTitle];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:artworkImageView.image];
    [nowPlayingInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    [nowPlayingInfo setObject:[NSString stringWithFormat:@"%f",appDelegate.musicPlayer1.duration] forKey:MPMediaItemPropertyPlaybackDuration];
    [nowPlayingInfo setObject:[NSNumber numberWithDouble:appDelegate.musicPlayer1.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
    albumArt=nil;
}


-(void)playNextSong{
    
    
    NSInteger x=  [[NSUserDefaults standardUserDefaults ]integerForKey:@"MusicItem"];
    x++;
    NSInteger x2=[[NSUserDefaults standardUserDefaults]integerForKey:@"MusicArrayCount"];
    if (x>=x2) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Songs Selection ended." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
        [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [appDelegate.musicPlayer1 stop];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Play"];
        x--;
    }
    else{
        [[NSUserDefaults standardUserDefaults ]setInteger:x forKey:@"MusicItem"];
        MPMediaItem *item=[arry objectAtIndex:x];
        appDelegate.musicPlayer1=nil;
        NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        NSError*error;
        appDelegate.musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&error];
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"This song cannot be added. Please select another song." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
            [appDelegate.musicPlayer1 stop];
            
        }
        
        else{
            [appDelegate.musicPlayer1 setDelegate:self];
            [appDelegate.musicPlayer1 prepareToPlay];
            appDelegate.musicPlayer1.volume=volumeSlider.value;
            [appDelegate.musicPlayer1 setVolume:volumeSlider.value];
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            if (![playPauseButton.imageView.image isEqual:[UIImage imageNamed:@"playButton.png"]]) {
                [appDelegate.musicPlayer1 play];
            }
        }
    }
}


-(void)playPreviousSong{
    
    
    NSInteger x=  [[NSUserDefaults standardUserDefaults ]integerForKey:@"MusicItem"];
    x--;
    if (x<0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Songs Selection ended." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
        [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [appDelegate.musicPlayer1 stop];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Play"];
        
        x++;
    }
    else{
        [[NSUserDefaults standardUserDefaults ]setInteger:x forKey:@"MusicItem"];
        
        appDelegate.musicPlayer1=nil;
        
        MPMediaItem *item=[arry objectAtIndex:x];
        NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        NSError*Error;
        appDelegate.musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&Error];
        if (Error) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"This song cannot be added. Please select another song." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
            [appDelegate.musicPlayer1 stop];
            
        }
        
        else{
            
            [appDelegate.musicPlayer1 setDelegate:self];
            [appDelegate.musicPlayer1 prepareToPlay];
            appDelegate.musicPlayer1.volume=volumeSlider.value;
            [appDelegate.musicPlayer1 setVolume:volumeSlider.value];
            
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            if (![playPauseButton.imageView.image isEqual:[UIImage imageNamed:@"playButton.png"]]) {
                [appDelegate.musicPlayer1 play];
            }
        }
        item=nil;
        
    }
}



- (IBAction)nextSong:(id)sender
{
    
    [self playNextSong];
    [self updateUIForCurrentItem];
    [self updateCenterAudioInfo];
    
    
}


-(IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Shuffle:(id)sender{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"]isEqualToString:@"On"])
    {
        [self updateShuffleLabel:NO];
        [[NSUserDefaults standardUserDefaults]setObject:@"Off" forKey:@"Shuffle"];
    }else{
        [self updateShuffleLabel:YES];
        [[NSUserDefaults standardUserDefaults]setObject:@"On" forKey:@"Shuffle"];
    }
    arrya=nil;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Shuffle"]isEqualToString:@"On"]) {
        arrya= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArrayRandom"];
        
    }else{
        
        arrya= [[NSUserDefaults standardUserDefaults ]objectForKey:@"MusicArray"];
    }
    arry=[NSKeyedUnarchiver unarchiveObjectWithData:arrya];
}
-(void)handlePlaybackStateChangedPlayer:(NSNotification *)notification{
    UIEvent *receivedEvent = notification.object;
    [self remoteControlReceivedWithEventPlayer:receivedEvent];
}

- (void) remoteControlReceivedWithEventPlayer: (UIEvent *) receivedEvent {
    NSLog(@"from player screen");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                
                [self playPause:nil];
                
                
                
                NSLog(@"toggele");
                //                if (appDelegate.playerObject) {
                //                    [self updateViewAsPerEarBudsForPlayerState:appDelegate.playerObject];
                //                }
                
                break;
                
                
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"pause");
                [self playPause:nil];
                
                
                break;
            case UIEventSubtypeRemoteControlPlay:
                
            {
                [self playPause:nil];
                [appDelegate.musicPlayer1 setVolume:volumeSlider.value];
                [appDelegate.musicPlayer1 play];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                [self playNextSong];
                [self updateUIForCurrentItem];
                [self updateCenterAudioInfo];
                
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                [self playPreviousSong];
                [self updateUIForCurrentItem];
                [self updateCenterAudioInfo];
                break;
            }
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            {
                //                self.backWordBtn.enabled = NO;
                break;
            }
                
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            {
                //                self.backWordBtn.enabled = YES;
                break;
            }
                
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            {
                //                self.forwordBtn.enabled = NO;
                break;
            }
                
            case UIEventSubtypeRemoteControlEndSeekingForward:
            {
                //                self.forwordBtn.enabled = YES;
                break;
            }
                
            default:
                break;
        }
    }
}

@end
