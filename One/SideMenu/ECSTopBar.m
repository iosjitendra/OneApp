//
//  ECSTopBar.m
//  TrustYoo
//
//  Created by Developer on 9/9/14.
//  Copyright (c) 2014 Shreesh Garg. All rights reserved.
//

#import "ECSTopBar.h"
#import "UIExtensions.h"
#import "UIAppExtensions.h"
//#import "DS_SearchScreen.h"
//#import "DS_CartScreen.h"

@interface ECSTopBar ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) NSString *imagestr;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
- (IBAction)clickToOpenCart:(id)sender;
- (IBAction)clickToOpenSearch:(id)sender;
- (IBAction)clickToOpenSideMenu:(id)sender;
@property (nonatomic, retain) UIViewController * controller;
@property (nonatomic, retain) NSString * heading;



@end

@implementation ECSTopBar
-(id)initWithController:(UIViewController *)controller withTitle:(NSString *)headerTitle withImage:(NSString *)imgNamestr
{
    
    self = [self initWithNibName:@"ECSTopBar" bundle:nil];
    self.controller = controller;
   self.heading = headerTitle;
    
    self.imagestr=imgNamestr;
    return self;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   

   
    [super viewDidLoad];
    
   
   
         [self.lblHeading setText:self.heading];
//        NSString *str = @"Country Hills PTA";
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//        
//        // Set font, notice the range is for the whole string
//        UIFont *font = [UIFont fontWithName:@"Karla-Bold" size:18];
//        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(13, 4)];
//        
//        // Set background color, again for entire range
//        [attributedString addAttribute:NSForegroundColorAttributeName
//                                 value:[UIColor grayColor]
//                                 range:NSMakeRange(13, 4)];
//        
//        [self.lblHeading setAttributedText:attributedString];
    
            self.lblHeading.textColor=[UIColor blackColor];
         // self.lblHeading.text=@"One";
    
     [self.lblHeading setFontKalra:22];
    
    
       UIImage *btnImage = [UIImage imageNamed:self.imagestr];
       [self.btnBack setImage:btnImage forState:UIControlStateNormal];
    if ([self.imagestr isEqualToString:@"menu-icon.png"] ) {
          [self.view setBackgroundColor :[UIColor colorWithRed:140.0/255.0f green:190.0/255.0f blue:196.0/255.0f alpha:1]];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"menu-icon.png"];
        [self.btnRight setImage:btnImage forState:UIControlStateNormal];
    [self.view setBackgroundColor :[UIColor colorWithRed:140.0/255.0f green:190.0/255.0f blue:196.0/255.0f alpha:1]];
    }
 
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToOpenSideMenu:(id)sender
{
    //[self.delegate addClubsToBounce:self.arraySelectedClubs];
    //[self.navigationController popViewControllerAnimated:YES];
    
    if([self.controller canPerformAction:@selector(openSideMenuButtonClicked:) withSender:sender])
    {
        [self.controller performSelector:@selector(openSideMenuButtonClicked:) withObject:sender];
    }
    else
    {
         
         [self.controller.navigationController popViewControllerAnimated:YES];
    }
}







-(void)openSideMenuButtonClicked:(UIButton *)sender{


};




@end
