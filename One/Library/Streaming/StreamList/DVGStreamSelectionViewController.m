//
//  DVGStreamSelectionViewController.m
//  NineHundredSeconds
//
//  Created by Nikolay Morev on 03.10.14.
//  Copyright (c) 2014 DENIVIP Group. All rights reserved.
//

#import "DVGStreamSelectionViewController.h"
#import "DVGStreamsDataController.h"
#import "Nine00SecondsSDK.h"

@import MediaPlayer;

@interface DVGStreamSelectionViewController ()
{
    NHSStream *streamForPlay;
}

@property (nonatomic, strong) IBOutlet UITableView *tblview;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UILabel *lblLive;
@property (nonatomic, weak) IBOutlet UIImageView *imgLive;
@property (nonatomic, weak) IBOutlet UIImageView *imgAir;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NHSStreamPlayerController *playerController;
@property(nonatomic,strong) UIActivityIndicatorView *activityView;
@end

@implementation DVGStreamSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"List";

    
    self.activityView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //self.activityView.frame = CGRectMake(self.view.frame.size.width / 2 -20, 250, 40.0, 40.0);
  //  self.activityView.center=self.view.center;
    //[self.playerController.view addSubview: self.activityView];
    if (!self.dataController) {
        DVGStreamsDataController *dataController = [[DVGStreamsDataController alloc] init];
        
        self.dataController = dataController;
        self.dataController.delegate = self;
    }

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    
    // Register the classes for use.
    //;; self.playButton=[[UIButton alloc]init];
    //[self.playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
    //self.playButton.frame = CGRectMake(5, 0, self.view.frame.size.width - 10.f, 250.f);
    
   // self.playButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
   // [self.view addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(ClickPlay) forControlEvents:UIControlEventTouchUpInside];
   // [self.tblview registerClass:[UITableViewCell class] forCellReuseIdentifier:buttonCellIdentifier];

    self.tblview.backgroundView = activityIndicator;
    
     NSLog(@"streamlistid %@",self.ChpStreamId);
    if (self.ChpStreamId) {
        self.tblview.hidden=YES;
    }
    if (!self.ChpStreamId.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Streaming not Available."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    //
    
    self.imgAir.hidden=YES;
      self.imgLive.hidden=YES;
    
    [self.dataController refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    if ([UIApplication sharedApplication].networkActivityIndicatorVisible ==YES) {
        NSLog(@"Show Indicator");
    }
      [self.dataController refresh];
   
    
    

}

- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.doesRelativeDateFormatting = YES;
    }

    return _dateFormatter;
}

- (IBAction)refreshControlTriggered:(id)sender {
    [self.dataController refresh];
}



#pragma mark - Table view data source



- (void)showPlayerWithStream:(NHSStream *)stream {
   // NSURL *streamingURL = [[NHSBroadcastManager sharedManager] broadcastingURLWithStream:(NHSStream *)stream];

    //NSURL *mediaURL = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
   // MPMoviePlayerController *mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL:streamingURL];

    self.playerController = [[NHSStreamPlayerController alloc] initWithStream:stream];
   
    [self.playerController setScalingMode: MPMovieScalingModeAspectFill];

    self.playerController.delegate = self;
    UIView *playerView = self.playerController.view;
    playerView.alpha = 0.f;
    playerView.frame = CGRectMake(5, 110, self.view.bounds.size.width - 10.f, 250.f);
    
   // playerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view.superview addSubview:playerView];
    
    [UIView animateWithDuration:.25f animations:^{
        //self.playerBackgroundView.alpha = 1.f;
        playerView.alpha = 1.f;
    }];
    
    [playerView addSubview: self.activityView];
   self.activityView.frame = CGRectMake(playerView.frame.size.width / 2 -20, 100, 40.0, 40.0);
   // self.activityView.center = playerView.center;
    
   [self.activityView startAnimating];
}


- (void)streamsDataControllerDidUpdateStreams:(DVGStreamsDataController *)controller
{
    self.title = [NSString stringWithFormat:@"List (%ld)", [self.dataController.streams count]];
    //[self configureView];
    
    for (int i=0; i<self.dataController.streams.count; i++) {
        
        NHSStream *stream = self.dataController.streams[i];
        NSLog(@"streamlistid %@",stream.streamID);
        NSLog(@"streamlistid %@",self.ChpStreamId);
        if ([stream.streamID isEqualToString:self.ChpStreamId]) {
            streamForPlay=stream;
            if (stream.isLive) {
               
                self.imgAir.hidden=YES;
                self.imgLive.hidden=NO;
                UIImage *image = [UIImage imageNamed:@"Live-label.png"];
                [self.imgLive setImage:image];
                NSLog(@"Live True");
            }else{
               
                self.imgAir.hidden=NO;
                self.imgLive.hidden=YES;
                UIImage *image = [UIImage imageNamed:@"Offair-label.png"];
                [self.imgAir setImage:image];
                NSLog(@"Not Live");
                
            }
            return ;
        }
    }
 
   // [self.tblview reloadData];
}

-(void)ClickPlay
{
    // [self.playerController.view addSubview: self.activityView];
   // [self.activityView startAnimating];
     self.playButton.hidden=YES;
    if (streamForPlay.streamID) {
        [self showPlayerWithStream:streamForPlay];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Video streaming not Available."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    
//    for (int i=0; i<self.dataController.streams.count; i++) {
//        
//        NHSStream *stream = self.dataController.streams[i];
//        NSLog(@"streamlistid %@",stream.streamID);
//        NSLog(@"streamlistid %@",self.ChpStreamId);
//        if ([stream.streamID isEqualToString:self.ChpStreamId]) {
//            self.playButton.hidden=YES;
//            [self showPlayerWithStream:stream];
//            if (stream.isLive) {
//                self.lblLive.text=@"Live";
//                UIImage *image = [UIImage imageNamed:@"red_circle2.png"];
//                [self.imgLive setImage:image];
//                NSLog(@"Live True");
//            }else{
//                self.lblLive.text=@"Live broadcast is over.\nShowing Recording now.";
//                UIImage *image = [UIImage imageNamed:@"Artboard.png"];
//                [self.imgLive setImage:image];
//                NSLog(@"Not Live");
//                
//            }
//
//            return ;
//        }
//        
//    }

}


-(IBAction)onclickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickRefreshButton:(id)sender
{
      self.playButton.hidden=YES;
      [self.dataController refresh];
                [self.playerController stop];
                [self.playerController.view removeFromSuperview];
                self.playerController = nil;
   
    for (int i=0; i<self.dataController.streams.count; i++) {
        
        NHSStream *stream = self.dataController.streams[i];
        NSLog(@"streamlistid %@",stream.streamID);
        NSLog(@"streamlistid %@",self.ChpStreamId);
        if ([stream.streamID isEqualToString:self.ChpStreamId]) {
            streamForPlay=stream;
             [self showPlayerWithStream:stream];
            if (stream.isLive) {
                
                self.imgAir.hidden=YES;
                self.imgLive.hidden=NO;
                UIImage *image = [UIImage imageNamed:@"Live-label.png"];
                [self.imgLive setImage:image];
                NSLog(@"Live True");
            }else{
                self.imgAir.hidden=NO;
                self.imgLive.hidden=YES;
                UIImage *image = [UIImage imageNamed:@"Offair-label.png"];
                [self.imgAir setImage:image];
                NSLog(@"Not Live");
                
            }
            return ;
        }
    }

    
}


- (void)onStreamView:(NHSStream *)stream controller:(NHSStreamPlayerController*)controller
{
    NSLog(@"StreamView");

}
- (void)onStreamPlaying:(NHSStream *)stream controller:(NHSStreamPlayerController*)controller
{
 [self.activityView stopAnimating];

}
- (void)onStreamStopped:(NHSStream *)stream controller:(NHSStreamPlayerController*)controller
{
NSLog(@"StreamStopped");
}
- (void)onStreamStalled:(NHSStream *)stream controller:(NHSStreamPlayerController*)controller
{
NSLog(@"Stalled");

}



@end
