//
//  DS_LaunchScreen.m
//  One
//
//  Created by Daksha on 1/10/17.
//  Copyright © 2017 Daksha. All rights reserved.
//

#import "DS_LaunchScreen.h"
#import "CH_LoginVC.h"
#import "CH_SignupVC.h"
#import "BC_InvitationScreen.h"
#import "DS_OneLoginVC.h"
@interface DS_LaunchScreen ()

@end

@implementation DS_LaunchScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onClickLogin:(id)sender{
//    CH_LoginVC *contentScreen = [[CH_LoginVC alloc]initWithNibName:@"CH_LoginVC" bundle:nil];
//    [self.navigationController pushViewController:contentScreen animated:YES];
    
    DS_OneLoginVC *contentScreen =  [[DS_OneLoginVC alloc]initWithNibName:@"DS_OneLoginVC" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];

}
-(IBAction)onClickSignup:(id)sender{
    //CH_SignupVC
    
    BC_InvitationScreen *contentScreen =  [[BC_InvitationScreen alloc]initWithNibName:@"BC_InvitationScreen" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];

}

-(IBAction)onClickNewLogin:(id)sender{
    //CH_SignupVC
    
    DS_OneLoginVC *contentScreen =  [[DS_OneLoginVC alloc]initWithNibName:@"DS_OneLoginVC" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];
    
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
