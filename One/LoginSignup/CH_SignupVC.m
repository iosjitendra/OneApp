//
//  CH_SignupVC.m
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 26/07/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CH_SignupVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "JJMaterialTextField.h"
#import "UIExtensions.h"
#import "MBProgressHUD.h"
//#import "iToast.h"
#import "ECSServiceClass.h"
#import "ECSHelper.h"
#import "UIExtensions.h"

#import "ECSConfig.h"
//#import "ALChatManager.h"
#import "ECSAppHelper.h"
#import <Applozic/ALDataNetworkConnection.h>
#import <Applozic/ALDBHandler.h>
#import <Applozic/ALContact.h>
#import "ALChannel.h"
#import "Applozic/ALChannelService.h"
#import "ALNewContactsViewController.h"
#import "ALMessagesViewController.h"
#import "AppUserObject.h"
@interface CH_SignupVC ()<UITextFieldDelegate>
{
    BOOL isImgSelected;
}
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *firstSignupView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContactFirst;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtName;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtPass;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtEmail;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtPhone;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtLostName;
@property(strong,nonatomic)IBOutlet UIButton *cameraButton;
@property(strong,nonatomic)IBOutlet UIButton *btnNext;
@property(strong,nonatomic)IBOutlet UIButton *btnSignupNext;
@property(strong,nonatomic)IBOutlet UIButton *btnOkay;
@end

@implementation CH_SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popUpView.hidden=YES;
    self.btnNext.layer.cornerRadius = 0;
   
    self.btnOkay.clipsToBounds = YES;
    self.btnOkay.layer.borderWidth=0.0f;
    
    self.btnNext.clipsToBounds = YES;
    self.btnNext.layer.borderWidth=0.0f;
    self.btnSignupNext.layer.cornerRadius = 0; // this value vary as per your desire
    self.btnSignupNext.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSignupNext.clipsToBounds = YES;
    self.cameraButton.layer.cornerRadius = 0;
    self.cameraButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.cameraButton.clipsToBounds = YES;
    self.cameraButton.layer.borderWidth=1.0f;
    isImgSelected=NO;
    UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FIRST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PHONE" attributes:@{NSForegroundColorAttributeName: color}];
     self.txtLostName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LAST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    UIFont *font1 = [UIFont fontWithName:@"Karla-Regular" size:16];
    self.txtPass.font=font1;
    self.txtName.font=font1;
    self.txtEmail.font=font1;
   self.txtPhone.font=font1;
     self.txtLostName.font=font1;
    self.txtLostName.delegate=self;
    
    [self textFieldInitialization];
//    [self setTextFieldImages];
//    [self setTextFieldsPadding];
    
    //self.firstSignupView.hidden=NO;
    //self.firstSignupView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
   // [self.view addSubview:self.firstSignupView];
    self.txtPhone.delegate=self;
   self.txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    [self.txtPhone setNumberKeybord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidEndEditing:(JJMaterialTextfield *)textField{
    if (textField.text.length==0) {
        [textField showError];
    }else{
        [textField hideError];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
    
}

-(void)textFieldInitialization
{
    _txtName.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtPass.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtPass.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtPass.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    //_txtPass.lineColor=[UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    _txtPass.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtEmail.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtEmail.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtEmail.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
  //  _txtEmail.lineColor=[UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];

    _txtEmail.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtPhone.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtPhone.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtPhone.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtPhone.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtLostName.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtLostName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtLostName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtLostName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
}




-(void)viewDidAppear:(BOOL)animated
{
   // self.popUpView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 600)];
      [self.scroll_addContactFirst setContentSize:CGSizeMake(self.scroll_addContactFirst.frame.size.width, 600)];
}



//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    if(textField==self.txtPhone)
//    {
//        return (newLength > 10) ? NO : YES;
//    }
//    else return YES;
//}

-(void)setTextFieldImages{
    
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 19)];
    [userImage setImage:[UIImage imageNamed:@"drop-down-icon.png"]];
    
    
    
    
}

-(void)setTextFieldsPadding
{
    [self.txtName setRightPadding];
    [self.txtPass setRightPadding];
    [self.txtEmail setRightPadding];
   
    [self.txtPhone setRightPadding];
     [self.txtLostName setRightPadding];
}

-(void)resignTextResponder
{
    
    [self.txtName resignFirstResponder];
    [self.txtPass resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    
    [self.txtPhone resignFirstResponder];
       [self.txtLostName resignFirstResponder];
    
}

-(IBAction)onClickOkay:(id)sender{
    self.popUpView.hidden=YES;
    //    BC_LoginVC * contactVc= [[BC_LoginVC alloc]initWithNibName:@"BC_LoginVC" bundle:nil];
    //              [self.navigationController pushViewController:contactVc animated:NO];
    //[self.navigationController pop];
//    NSArray *viewContrlls=[[NSArray alloc] initWithArray:[[self navigationController] viewControllers]];
//    id obj=[viewContrlls objectAtIndex:2];
//    [[self navigationController] popToViewController:obj animated:YES];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];

    
}

-(IBAction)onClickNext:(id)sender{
    
    self.popUpView.hidden=NO;
                 self.popUpView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:self.popUpView];
    
}
-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startServiceToSignUp
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToSignUp) withObject:nil];
    
    
}



-(BOOL)isValidPassword:(NSString *)passwordString
{
    int numberofCharacters = 0;
    BOOL lowerCaseLetter,upperCaseLetter,digit,specialCharacter = 0;
    if([self.txtPass.text length] >= 6)
    {
        for (int i = 0; i < [self.txtPass.text length]; i++)
        {
            unichar c = [self.txtPass.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            
        }
    }
    
    if( digit && lowerCaseLetter )
    {
          [self startServiceToSignUp];
    }else{
         [ECSAlert showAlert:@"Please Ensure that you have at least one character and one digit"];
//        [[[[iToast makeText:@"Please Ensure that you have at least one character and one digit"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
    
    
    return YES;
}


-(void)serviceToSignUp
{
    //https://www.buckworm.com/laravel/index.php/api/v1/addGroupMember
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:IMAGE];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/usersignup",SERVERURLPATH]];
    //user_role=private
    [class addParam:@"private" forKey:@"user_role"];
    [class addParam:self.txtName.text forKey:@"first"];
    [class addParam:self.txtLostName.text forKey:@"last_name"];
    [class addParam:self.txtEmail.text forKey:@"email"];
    [class addParam:@"contact" forKey:@"usertype"];
    [class addParam:self.txtEmail.text forKey:@"username"];
    [class addParam:@"School" forKey:@"donate_to_choice"];
    [class addParam:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:@"deviceId"];
    [class addParam:@"iOS" forKey:@"deviceType"];
    
    [class addParam:self.txtPass.text forKey:@"password"];
    NSString *str = self.txtPhone.text;
    
    str = [str stringByReplacingOccurrencesOfString:@" - "
                                         withString:@""];
    
    [class addParam:str forKey:@"phone_no"];
    [class addParam:self.invitationCode forKey:@"invitationCode"];
    [class addParam:@"One APP" forKey:@"source"];
   
    if (isImgSelected==YES)
         [class addImageData:UIImageJPEGRepresentation(self.imgUserProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"profileImage"];
    
   
    [class setCallback:@selector(callBackServiceToGetSignUp:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetSignUp:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        NSString *strValue=[rootDictionary objectForKey:@"statusDescription"];
       //  [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
        
       
        if ([strValue isEqualToString:@"Your account is ready, please verify email address to activate your account."]) {
            self.popUpView.hidden=NO;
            self.popUpView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:self.popUpView];
        }else{
              [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];

        }
        
        
    }
   
    if (!rootDictionary) {
         [ECSAlert showAlert:response.stringValue];
    }
    
}


- (IBAction)clickToSignUp:(id)sender {
    
    [self resignTextResponder];
    
    if (self.txtName.text.length==0)
    {
        [ECSAlert showAlert:@"Please enter your first name"];

    }
   
    else if(self.txtEmail.text.length==0)
    {
         [ECSAlert showAlert:@"Please enter your email address"];
        
    }
    else if (![self validateEmail:self.txtEmail.text]){
        
        [ECSAlert showAlert:@"Please enter a valid email address"];
        
    }
    else  if (self.txtPhone.text.length==0)
    {
    [ECSAlert showAlert:@"Please enter the phone number"];
        
        
    }
//  else if (self.txtPhone.text.length < 10)
//    {
//    [ECSAlert showAlert:@"Please enter valid phone number"];
//        
//    
//    }
    else if (self.txtPass.text.length <=6)
    {
    [ECSAlert showAlert:@"This Password is too short"];
        
    }
   else if (![self isValidPassword:self.txtPass.text]){
       
        // [ECSAlert showAlert:@"Please enter a valid password passwordaddress"];
        //          [[[[iToast makeText:@"Please Ensure that you have at least one character and one digit"]
        //             setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        
   }
       
        
      //  [self startServiceToSignUp];
   
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if(textField == self.txtPhone) // need to add this check as we have several atext fields 1
    {
        
        if (range.length==1 && string.length==0) // added by shreesh to check if user has tapped on back button
        {
            return YES;
        }
        NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 -   "];
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int charCount = [newString length];
        
        if (charCount == 3 || charCount == 9) {
            if ([string isEqualToString:@""]){
                return YES;
            }else{
                newString = [newString stringByAppendingString:@" - "];
            }
        }
        
        if (charCount == 4 || charCount == 10) {
            if (![string isEqualToString:@" - "]){
                newString = [newString substringToIndex:[newString length]-1];
                newString = [newString stringByAppendingString:@" - "];
            }
        }
        
        if ([newString rangeOfCharacterFromSet:[numSet invertedSet]].location != NSNotFound
            || [string rangeOfString:@" - "].location != NSNotFound
            || charCount > 16) {
            return NO;
        }
        
        self.txtPhone.text = newString;
        return NO;

    }
    else return YES;
    
  
}

-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (IBAction)clickToUploadImage:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Library", @"Camera", nil];
    
    [actionSheet showInView:self.view];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    //NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex==0)
    {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if(buttonIndex==1)
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    if (image) {
        isImgSelected=YES;
    }
    self.imgUserProfile.image=image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
//-(IBAction)onClickSignupFirst:(id)sender{
//    [self startServiceToSignupFirst];
//}
-(IBAction)onClickSignupFirstBack:(id)sender{
     self.firstSignupView.hidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startServiceToSignupFirst
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToSignupFirst) withObject:nil];
    
    
}

-(void)serviceToSignupFirst
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    [class setServiceURL:[NSString stringWithFormat:@"%@v3/signup",SERVERURLPATH]];
    
    [class addParam:self.txtEmail.text forKey:@"email"];
    [class addParam:self.txtPass.text forKey:@"password"];
    
    [class addParam:@"ios" forKey:@"platform"];
           [class addParam:@"test" forKey:@"invitationCode"];
    
    [class addParam:@"regular" forKey:@"user_role"];
    [class addParam:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:@"deviceId"];
    [class addParam:@"iOS" forKey:@"deviceType"];
    [class setCallback:@selector(callBackServiceToGetSignupFirst:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetSignupFirst:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
      
        self.appUserObject = [AppUserObject instanceFromDictionary:[rootDictionary objectForKey:@"user"]];
        
        [self.appUserObject saveToUserDefault];
        //
        //        [[[[iToast makeText:[rootDictionary objectForKey:@"statusDescription"]]
        //           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        if ([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"Success"]) {
            
            
            self.firstSignupView.hidden=YES;
//            ALUser * user = [[ALUser alloc] init];
//            [user setUserId:[ECSAppHelper getUniqueApplogicName:[NSString stringWithFormat:@"%@",self.appUserObject.userId] andEmail:self.appUserObject.email]];
//            [user setEmail:[self.txtEmail text]];
//            [user setPassword:@""];
//            [user setImageLink:@""];
//            
//            
//            [ALUserDefaultsHandler setUserId:user.userId];
//            [ALUserDefaultsHandler setEmailId:user.email];
//            [ALUserDefaultsHandler setPassword:user.password];
//            [ALUserDefaultsHandler setUserAuthenticationTypeId:(short)CLIENT];
//            
//            ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:APPLOZIC_KEY];
//            [chatManager registerUser:user];
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"ON_ADD_A_F" object:nil];
             [ECSAlert showAlert:@"Success"];
            [self.navigationController popViewControllerAnimated:NO];
            //[self.view removeFromSuperview];
        }else{
            
            [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
        }
        
        
        
        
    }
    else {
        
        [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        
    }
    
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
