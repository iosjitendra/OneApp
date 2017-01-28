//
//  CH_DemoVC.m
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 29/07/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CH_DemoVC.h"

@interface CH_DemoVC ()
@property(strong,nonatomic)IBOutlet UIView *PopupView;
@end

@implementation CH_DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _PopupView.layer.cornerRadius = 5;
    _PopupView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
