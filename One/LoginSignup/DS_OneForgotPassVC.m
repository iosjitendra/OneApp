//
//  DS_OneForgotPassVC.m
//  One
//
//  Created by Daksha on 1/20/17.
//  Copyright © 2017 Daksha. All rights reserved.
//

#import "DS_OneForgotPassVC.h"
#import "ECSAppHelper.h"
#import "MBProgressHUD.h"
#import "ECSServiceClass.h"
#import "AppUserObject.h"
#import "ECSAppHelper.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
@interface DS_OneForgotPassVC ()<UITextFieldDelegate>
{
    int number;
    NSString *Char;
    NSUInteger newLength;
    BOOL isCharSeleted;
     BOOL isNumSeleted;
    BOOL isTotalLengthEight;
    BOOL isPasswordReseted;
}
@property(weak,nonatomic)IBOutlet UITextField *textAccessCode;
@property(weak,nonatomic)IBOutlet UILabel *lblAccess;
//@property(weak,nonatomic)IBOutlet UILabel *lblAccessText;//
@property(strong,nonatomic)IBOutlet UIButton *btnNext;
@property(strong,nonatomic)IBOutlet UIButton *showPass;
@property(strong,nonatomic)IBOutlet UIButton *btnForgotPassword;

@property(strong,nonatomic)IBOutlet UIButton *btnChar;
@property(strong,nonatomic)IBOutlet UIButton *btnNum;
@property(strong,nonatomic)IBOutlet UIButton *btnEightLength;
@property(weak,nonatomic)IBOutlet UILabel *lblChar;
@property(weak,nonatomic)IBOutlet UILabel *lblNum;
@property(weak,nonatomic)IBOutlet UILabel *lblEightLength;
@property(strong,nonatomic)IBOutlet UIView *viewCofm;
@property(weak,nonatomic)IBOutlet UIImageView *userProfileImg;

@end

@implementation DS_OneForgotPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textAccessCode.delegate = self;
    self.btnNext.titleLabel.textColor=[UIColor lightGrayColor];
    self.textAccessCode.autocorrectionType = UITextAutocorrectionTypeNo;
    self.btnNext.enabled = NO;
    self.showPass.hidden=NO;
    isCharSeleted=NO;
    isTotalLengthEight=NO;
    isNumSeleted=NO;
    self.textAccessCode.secureTextEntry = YES;
  //  self.viewCofm.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     self.viewCofm.hidden=NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *imagedatea= [prefs stringForKey:@"usersDetails"];
     //[ECSUserDefault  saveObject:object ToUserDefaultForKey:@"usersDetails"];
    if (imagedatea.length>0) {
        [self.userProfileImg ecs_setImageWithURL:[NSURL URLWithString:imagedatea] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             
         }];
    }
     if(self.userData.profileImage.length>0)
    [self.userProfileImg ecs_setImageWithURL:[NSURL URLWithString:self.userData.profileImage] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    isPasswordReseted=NO;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textField.text];
//        [attributedString addAttribute:NSKernAttributeName
//                                 value:@(4.86)
//                                 range:NSMakeRange(0, self.textAccessCode.text.length)];
//    
//    self.textAccessCode.attributedText = attributedString;
    newLength = [textField.text length] + [string length] - range.length;
   
    
   
    NSCharacterSet *setToRemove =
    [NSCharacterSet characterSetWithCharactersInString:@"0123456789 "];
    NSCharacterSet *setToKeep = [setToRemove invertedSet];
    
    NSString *newString =
    [[string componentsSeparatedByCharactersInSet:setToKeep]
     componentsJoinedByString:@""];
    if ([newString intValue]) {
        //[self checkboxButton:nil];
        self.lblNum.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
        isNumSeleted=YES;
         [self.btnNum setImage:[UIImage imageNamed:@"green-checkmark.png"] forState:UIControlStateNormal];
    }else{
         //[self.btnNum setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
    }

   // NSString * num = [self.textAccessCode.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *trimmedString = nil;
    
    NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    trimmedString = [string stringByTrimmingCharactersInSet:numbersSet];
    
    if (trimmedString.length) {
        [self checkboxButton:trimmedString];
    }
    
    
    if ( newLength) {
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.btnNext.enabled = YES;
       
    }else{
        
        [self.btnChar setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
        [self.btnNum setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
        isNumSeleted=NO;
        isCharSeleted=NO;
        self.lblChar.textColor=[UIColor blackColor];
        self.lblNum.textColor=[UIColor blackColor];
        self.lblEightLength.textColor=[UIColor blackColor];
        [self.btnNext setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.btnNext.enabled = NO;
    }
    
    if (newLength>=8) {
        isTotalLengthEight=YES;
         self.lblEightLength.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
        
        [self.btnEightLength setImage:[UIImage imageNamed:@"green-checkmark.png"] forState:UIControlStateNormal];
    }else{
        isTotalLengthEight=NO;
         self.lblEightLength.textColor=[UIColor lightGrayColor];
        [self.btnEightLength setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
    }
    
    if (range.length==1 && string.length==0)
    {
        NSString *trimString = nil;
        
        NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        trimString = [self.textAccessCode.text stringByTrimmingCharactersInSet:numberSet];
        if (trimString.length) {
            isCharSeleted=YES;
             self.lblChar.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
             [self.btnChar setImage:[UIImage imageNamed:@"green-checkmark.png"] forState:UIControlStateNormal];
        }else{
            self.lblChar.textColor=[UIColor lightGrayColor];
            isCharSeleted=NO;
            [self.btnChar setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
        }
        
        if (newLength>=8) {
            self.lblEightLength.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
            // self.lblNum.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
            isTotalLengthEight=YES;
            [self.btnEightLength setImage:[UIImage imageNamed:@"green-checkmark.png"] forState:UIControlStateNormal];
        }else{
             self.lblEightLength.textColor=[UIColor lightGrayColor];
            isTotalLengthEight=NO;
            [self.btnEightLength setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
        }
        NSString *newString =
        [[self.textAccessCode.text componentsSeparatedByCharactersInSet:setToKeep]
         componentsJoinedByString:@""];
        if([newString intValue]){
            self.lblNum.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
            [self.btnNum setImage:[UIImage imageNamed:@"green-checkmark.png"] forState:UIControlStateNormal];
            isNumSeleted=YES;
        }else{
            self.lblNum.textColor=[UIColor lightGrayColor];
            isNumSeleted=NO;
            [self.btnNum setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
        }
        if ( newLength) {
            [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.btnNext.enabled = YES;
            
        }else{
              isCharSeleted=NO;
              isNumSeleted=NO;
            [self.btnChar setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
            [self.btnNum setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
            self.lblChar.textColor=[UIColor lightGrayColor];
            self.lblNum.textColor=[UIColor lightGrayColor];
            self.lblEightLength.textColor=[UIColor lightGrayColor];
            [self.btnNext setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.btnNext.enabled = NO;
        }
//        if (isCharSeleted&& isNumSeleted&&isTotalLengthEight==YES) {
//            [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [self.btnNext setTitle:@"" forState:UIControlStateNormal];
//            [self.btnNext setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
//        }else{
//            [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [self.btnNext setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [self.btnNext setTitle:@"Reset" forState:UIControlStateNormal];
//        }

        return YES;
    }
    
//    if (isCharSeleted&& isNumSeleted&&isTotalLengthEight==YES) {
//        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.btnNext setTitle:@"" forState:UIControlStateNormal];
//       [self.btnNext setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
//    }else{
//        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.btnNext setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [self.btnNext setTitle:@"Reset" forState:UIControlStateNormal];
//    }
    return YES;
}


-(void)checkboxButton :(NSString*)str
{
    

    if(str){
         self.lblChar.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:126/255.0 alpha:1];
        isCharSeleted=YES;
        [self.btnChar setImage:[UIImage imageNamed:@"green-checkmark.png"] forState:UIControlStateNormal];
  
    }
    else{
          isCharSeleted=NO;
        self.lblChar.textColor=[UIColor lightGrayColor];
        [self.btnChar setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
    }
}
-(IBAction)onClickNext:(id)sender{
    
    
    [self.textAccessCode resignFirstResponder];
    if (isPasswordReseted==YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   if ([self.lblAccess.text isEqualToString:@"New Password"]){
        
        if ( [self.textAccessCode.text isEqualToString:@""]) {
            self.btnNext.enabled = NO;
            [ECSAlert showAlert:@"Please Enter Password "];
        }
      else if (self.textAccessCode.text.length>=8) {
         
           [self startServiceToUpdatePassword];
       }
//        else if ( self.btnNext.enabled==YES) {
//            [ECSAlert showAlert:@"Please Call Login Api"];
//        }
       
        
    }
  
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.btnEightLength setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
    [self.btnChar setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
    [self.btnNum setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
    self.lblChar.textColor=[UIColor blackColor];
    self.lblNum.textColor=[UIColor blackColor];
    self.lblEightLength.textColor=[UIColor blackColor];
    self.btnNext.enabled = NO;
    self.btnNext.titleLabel.textColor=[UIColor lightGrayColor];
    textField.text = @"";
    [textField resignFirstResponder];
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
     [textField resignFirstResponder];
    if (textField == self.textAccessCode) {
       
        //        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //        self.btnNext.enabled = YES;
        
        if ([self.lblAccess.text isEqualToString:@"New Password"]){
            if ( [self.textAccessCode.text isEqualToString:@""]) {
                self.btnNext.enabled = NO;
                [self.btnChar setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
                [self.btnNum setImage:[UIImage imageNamed:@"check marka.png"] forState:UIControlStateNormal];
                [ECSAlert showAlert:@"Please Enter Password "];
            }
            
            else if (self.textAccessCode.text.length>=8) {
                
                 [self startServiceToUpdatePassword];
               
            }
        }
        
    }
    
    return YES;
}

- (IBAction)ShowPass:(UIButton *)sender {
    if (self.textAccessCode.secureTextEntry == YES) {
        [ self.showPass setTitle:@"Hide" forState:(UIControlStateNormal)];
        
        self.textAccessCode.secureTextEntry = NO;
        
    }
    
    else
    {
        [ self.showPass setTitle:@"Show" forState:(UIControlStateNormal)];
        self.textAccessCode.secureTextEntry = YES;
    }
    
    
}


-(void)startServiceToUpdatePassword
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToUpdatePassword) withObject:nil];
    
    
}

-(void)serviceToUpdatePassword
{
  
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    
    
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/%@",SERVERURLPATH,@"ResetNewPassword"]];
    // [class setServiceURL:[NSString stringWithFormat:@"https://www.buckworm.com/laravel/index.php/api/v1/ResetNewPassword"]];
    [class addParam:_username1 forKey:@"username"];
    [class addParam:self.token forKey:@"token"];
    [class addParam:self.textAccessCode.text forKey:@"newpassword"];
    [class setCallback:@selector(callBackServiceToGetUpdatePassword:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetUpdatePassword:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        //  ;
       
            
            if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Password Reset Successfully."]) {
                
               isPasswordReseted=YES;
                [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [self.btnNext setTitle:@"" forState:UIControlStateNormal];
                 [self.btnNext setImage:[UIImage imageNamed:@"white-check-icon.png"] forState:UIControlStateNormal];
                // self.viewCofm.hidden=NO;
               // [self.view addSubview:self.viewCofm];
            }
        else{
            
            
            if ([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"Profile successfully updated!"]) {
                
                [ECSAlert showAlert:@"Updated"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
                
                
            }
            
            
            
        }
    }
    else {
       [ECSAlert showAlert:response.stringValue];
    }
    
}

-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickConfBack:(id)sender{
       //
    self.viewCofm.hidden=YES;
   // [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickOk:(id)sender{
    
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
