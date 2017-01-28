//
//  BC_InvitationScreen.m
//  BergerCounty
//
//  Created by Daksha on 9/30/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "BC_InvitationScreen.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "ECSServiceClass.h"
//#import "BC_HomeScreenVC.h"
#import "DS_SideMenuVC.h"
//#import "iToast.h"
#import "CH_SignupVC.h"
#import "ECSHelper.h"
@interface BC_InvitationScreen ()<UITextFieldDelegate>{
    NSUInteger newLength;
}
@property(weak,nonatomic)IBOutlet UITextField *textAccessCode;
@property(weak,nonatomic)IBOutlet UILabel *lblAccess;
@property(weak,nonatomic)IBOutlet UILabel *lblAccessText;
@property(strong,nonatomic)IBOutlet UIButton *btnNext;
@end

@implementation BC_InvitationScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     self.textAccessCode.delegate = self;
   // self.textAccessCode.keyboardType = UIKeyboardTypeNumberPad;
    
//    NSString *string = @"Enter Invitation Code ";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    
//    float spacing = 5.3f;
//    [attributedString addAttribute:NSKernAttributeName
//                             value:@(spacing)
//                             range:NSMakeRange(0, [string length])];
//    
//    self.lblAccess.attributedText = attributedString;
    self.btnNext.titleLabel.textColor=[UIColor lightGrayColor];
    self.btnNext.enabled = NO;
    self.textAccessCode.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [ self.textAccessCode becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textField.text];
//    [attributedString addAttribute:NSKernAttributeName
//                             value:@(22.86)
//                             range:NSMakeRange(0, self.textAccessCode.text.length)];
    
    self.textAccessCode.attributedText = attributedString;
    newLength = [textField.text length] + [string length] - range.length;
    if ( newLength) {
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      
        self.btnNext.enabled = YES;
        
    }else{
        
        
        [self.btnNext setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.btnNext.enabled = NO;
    }

   
    return YES;
}

-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickNext:(id)sender{
   // [self startServiceToInvite];
//    CH_SignupVC *accountScreen = [[CH_SignupVC alloc]initWithNibName:@"CH_SignupVC" bundle:nil];
//    accountScreen.invitationCode=self.textAccessCode.text;
//    [self.navigationController pushViewController:accountScreen animated:YES];
   // [self presentViewController:accountScreen animated:YES completion:nil];
    [self startServiceToInvite];
}

-(void)startServiceToInvite
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToInvite) withObject:nil];
    
    
}

-(void)serviceToInvite
{
//URL: http://www.buckworm.com/laravel/index.php/api/v1/checkInvitationCode
//Method: Post
//Param: accessCode

    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/check-one-app-invite-code-validity",SERVERURLPATH]];
    [class addParam:self.textAccessCode.text forKey:@"code"];
    

//    
//URL: https://www.buckworm.com/laravel/index.php/api/v1/check-one-app-invite-code-validity
//Method: Post
//param: code
  // [class addParam:@"Bergen County" forKey:@"source"];
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToInvite:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToInvite:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Code exists!"]) {
            CH_SignupVC *accountScreen = [[CH_SignupVC alloc]initWithNibName:@"CH_SignupVC" bundle:nil];
             accountScreen.invitationCode=self.textAccessCode.text;
            [self.navigationController pushViewController:accountScreen animated:YES];
        }
        
    
    else {
        
         [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        
    }
        
//    [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//       setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}

}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField == self.textAccessCode) {
        [textField resignFirstResponder];
         [self startServiceToInvite];
//        CH_SignupVC *accountScreen = [[CH_SignupVC alloc]initWithNibName:@"CH_SignupVC" bundle:nil];
//        accountScreen.invitationCode=self.textAccessCode.text;
//        [self.navigationController pushViewController:accountScreen animated:YES];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
