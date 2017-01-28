//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BC_ForgotPassword.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SAMTextView.h"

#import "JJMaterialTextField.h"
#import "ECSServiceClass.h"
//#import "iToast.h"
@interface BC_ForgotPassword ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtEmail;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImag;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;


- (IBAction)clickToBack:(id)sender;

- (IBAction)clickToSubmit:(id)sender;
- (IBAction)clickToUploadImage:(id)sender;
@end


@implementation BC_ForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnLogin.layer.borderWidth = 0.0;

     //self.btnSignUp.layer.borderColor = UIColor.blueColor().CGColor
    
   // [self settingTopView:self.viewTop onController:self andTitle:@"Login"];
    
    self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2;
    self.imgUserProfile.clipsToBounds = YES;
    
    
    UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
//    UIFont *font1 = [UIFont fontWithName:@"Karla-Regular" size:12];
//    self.txtEmail.font=font1;
    
    [self textFieldInitialization];
//    [self setTextFieldImages];
//    [self setTextFieldsPadding];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewDidAppear:(BOOL)animated
{
    
    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 600)];
}

-(void)textFieldInitialization
{
    _txtEmail.enableMaterialPlaceHolder = YES;
    _txtEmail.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtEmail.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtEmail.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    

    
    
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


-(void)setTextFieldImages{
    
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 19)];
    [userImage setImage:[UIImage imageNamed:@"drop-down-icon.png"]];
    

    
    
}

-(void)setTextFieldsPadding
{

    [self.txtEmail setRightPadding];
   
}

-(void)resignTextResponder
{
    

    [self.txtEmail resignFirstResponder];
   
    
}



- (IBAction)clickToBack:(id)sender {
//    BC_LoginVC * contactVc= [[BC_LoginVC alloc]initWithNibName:@"BC_LoginVC" bundle:nil];
//    
//    NSMutableArray * arrayViewController = self.navigationController.viewControllers.mutableCopy;
//    [arrayViewController removeObject:self];
//    
//    
//    [UIView beginAnimations: @"View Flip" context: nil];
//    [UIView setAnimationDuration: 1.0];
//    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView: self.navigationController.view cache: NO];
//    
//    [arrayViewController addObject:contactVc];
//    [self.navigationController setViewControllers:arrayViewController];
//    //  [self.navigationController pushViewController:contactVc animated:YES];
//    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //code to be executed with the dismissal is completed
        // for example, presenting a vc or performing a segue
    }];
    
}

- (IBAction)clickToSubmit:(id)sender {
    
    [self resignTextResponder];
    
 if(self.txtEmail.text.length==0)
    {
        [ECSAlert showAlert:@"Please enter your email address"];
      

    }
    else if (![self validateEmail:self.txtEmail.text]){
        
        [ECSAlert showAlert:@"Please enter a valid email address"];
      
        
    }
    else{
  

        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Are you sure want to change password?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        
       // alertView.tag=11;
        [alertView show];
   
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        [self startServiceToForgotPassword];
    }
}


-(void)startServiceToForgotPassword
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToForgotPassword) withObject:nil];
    
    
}

-(void)serviceToForgotPassword
{
    // http://www.buckworm.com/laravel/api/v1/reset/{username}
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    [class addHeader:APP_KEY_VAL forKey:APP_KEY];
     [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/reset/%@",SERVERURLPATH,self.txtEmail.text]];
    [class addParam:@"3" forKey:@"ISGPC"];
   
   
    [class addParam:@"oneresetpass://" forKey:@"redirect_uri"];
    [class addParam:@"Oneapp" forKey:@"source"];
    
   
   
    [class setCallback:@selector(callBackServiceToForgotPassword:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToForgotPassword:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
      //A password reset link has been sent to your email.
       
        if ([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"A password Reset Link is send to your Mail."]) {
             [ECSAlert showAlert:@"A password reset link has been sent to your email."];
        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
        }
        if(self.navigationController==Nil)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else{
            //            BC_ContactScreenVC * contactVc= [[BC_ContactScreenVC alloc]initWithNibName:@"BC_ContactScreenVC" bundle:nil];
            //            [self.navigationController pushViewController:contactVc animated:YES];
        }
        
    }
    else {
        
     
//        [[[[iToast makeText:[rootDictionary objectForKey:@"errors"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
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
    
    self.imgUserProfile.image=image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}





@end
