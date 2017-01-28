//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BC_ProfileVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SAMTextView.h"
#import "JJMaterialTextField.h"
#import "ECSServiceClass.h"
//#import "iToast.h"
#import "ECSTopBar.h"
#import "BC_ResetPassword.h"
#import "CHE_EditImageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface BC_ProfileVC ()<UITextFieldDelegate>
{
    BOOL isProfileUpdate;
}

@property BOOL isImageUploadRequired;
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtFirstName;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtLastName;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtEmail;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtPhone;
@property (weak, nonatomic) IBOutlet UIPickerView *pickrView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImag;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property(weak,nonatomic)IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)clickToResetPassword:(id)sender;

- (IBAction)clickToUpdate:(id)sender;
- (IBAction)clickToUploadImage:(id)sender;
@end


@implementation BC_ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isProfileUpdate=NO;
   // self.btnEdit.hidden=YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
//        [[[[iToast makeText:@"Updated"]
//           setGravity:iToastGravityTop] setDuration:iToastDurationLong] show];
        
    });
    
    self.btnUpdate.layer.borderWidth = 0.0;
    self.resetButton.layer.borderWidth = 0.0;

     //self.btnSignUp.layer.borderColor = UIColor.blueColor().CGColor
   
    //[self settingTopView:self.viewTop onController:self andTitle:@"Profile"];
    
    self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2;
    self.imgUserProfile.clipsToBounds = YES;
   //[self startServiceToGetUserDetail];
    

    
    
    UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FIRST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LAST NAME" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PHONE" attributes:@{NSForegroundColorAttributeName: color}];
//    UIFont *font1 = [UIFont fontWithName:@"Karla-Regular" size:11];
//    self.txtFirstName.font=font1;
//    self.txtLastName.font=font1;
//    self.txtEmail.font=font1;
//    self.txtPhone.font=font1;
    
   
    
    [self textFieldInitialization];
//    [self setTextFieldImages];
//    [self setTextFieldsPadding];
//     self.txtPhone.delegate=self;
//    [self.txtPhone setNumberKeybord];
    
    self.txtPhone.delegate=self;
    [self.txtPhone setNumberKeybord];
    self.txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.btnUserImag.layer.cornerRadius = self.btnUserImag.frame.size.height/2;
    self.btnUserImag.clipsToBounds = YES;
    
    // border
//    [[UIColor colorWithRed:0.5f green:0.2f blue:0.7f alpha:1.0f] CGColor];
//    [self.imgUserProfile.layer setBorderColor:[[UIColor clearColor] CGColor]];
//    [self.imgUserProfile.layer setBorderWidth:0.0f];
//    
//    // drop shadow
//    [self.imgUserProfile.layer setShadowColor:[UIColor clearColor].CGColor];
//    [self.imgUserProfile.layer setShadowOpacity:0.0];
//    [self.imgUserProfile.layer setShadowRadius:0.0];
//    [self.btnUserImag.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    [self startServiceToGetUserDetail];

    //self.btnEdit.hidden=YES;
    [self.btnEdit setButtonTitle:@"Upload"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotificationProfile"
                                               object:nil];
    


    
}
- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    [self.btnEdit setButtonTitle:@"edit"];
    self.appUserObject.profileImage=@"";
    if (notification.object) {
        self.imgUserProfile.image=notification.object;
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldInitialization
{
    self.txtFirstName.enableMaterialPlaceHolderForMoreDisplace = YES;
    self.txtFirstName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    self.txtFirstName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.txtFirstName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    self.txtLastName.enableMaterialPlaceHolderForMoreDisplace = YES;
    self.txtLastName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    self.txtLastName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.txtLastName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtEmail.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtEmail.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtEmail.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtEmail.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtPhone.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtPhone.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtPhone.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtPhone.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 600)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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


-(void)myTextfield :(NSString *)phoneNum{
    
}

-(void)setTextFieldImages{
    
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 19)];
    [userImage setImage:[UIImage imageNamed:@"drop-down-icon.png"]];
    

    
    
}

-(void)setTextFieldsPadding
{
    [self.txtFirstName setRightPadding];
    [self.txtLastName setRightPadding];
    [self.txtEmail setRightPadding];
  
    [self.txtPhone setRightPadding];
}

-(void)resignTextResponder
{
    
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    
    [self.txtPhone resignFirstResponder];
    
}



-(IBAction)ClickResetPassword:(id)sender{
    
    BC_ResetPassword *nav=[[BC_ResetPassword alloc]initWithNibName:@"BC_ResetPassword" bundle:nil];
    [self.navigationController pushViewController:nav animated:YES];
}


- (IBAction)clickToUpdate:(id)sender {
    
    [self resignTextResponder];
    
    if (self.txtFirstName.text.length==0)
    {
        [ECSAlert showAlert:@"Please enter your first name"];

    }
//    else if (self.txtLastName.text.length==0)
//    {
//        [ECSAlert showAlert:@"Please enter your last name"];
//
//    }
    
//    else if (self.txtPhone.text.length==0)
//    {
//        [ECSAlert showAlert:@"Please enter the Phone number"];
//
//    }
    else if (self.txtPhone.text.length < 10)
    {
        [ECSAlert showAlert:@"Please enter valid phone number"];
    }
    
    
    else
    {
        [self startServiceToUpdate];
        
    }
    
}


-(void)startServiceToUpdate
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToUpdate) withObject:nil];
    
    
}

-(void)serviceToUpdate
{
//self.isImageUploadRequired
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    if(self.isImageUploadRequired)
    {
        [class setServiceMethod:IMAGE];
        [class addImageData:UIImageJPEGRepresentation(self.imgUserProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"profileImage"];
    }
    else [class setServiceMethod:POST];
//params: name,emails, password, user_type, username all are required
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/users/%@",SERVERURLPATH,self.appUserObject.userId]];
   
    [class addParam:self.txtFirstName.text forKey:@"first"];
    [class addParam:self.txtLastName.text forKey:@"last_name"];
    [class addParam:self.txtEmail.text forKey:@"email"];
    NSString *str = self.txtPhone.text;
    
    str = [str stringByReplacingOccurrencesOfString:@" - "
                                         withString:@""];
     [class addParam:str forKey:@"phone_no"];
    [class setCallback:@selector(callBackServiceToGetUpdate:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetUpdate:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        isProfileUpdate=YES;
        [ECSToast showToast:@"Updated" view:self.view];
        self.appUserObject.first=self.txtFirstName.text;
        self.appUserObject.lastName=self.txtLastName.text;
        self.appUserObject.phoneNo=self.txtPhone.text;
        self.isImageUploadRequired = NO;
        [self.appUserObject saveToUserDefault];
        //[self textFieldInitialization];
        
    }
    else {
        
       // [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
        [ECSToast showToast:[rootDictionary objectForKey:@"errors"] view:self.view];
    }
    
}


-(void)startServiceToGetUserDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetUserDetail) withObject:nil];
    
    
}

-(void)serviceToGetUserDetail
{
    //http://www.buckworm.com/laravel/index.php/api/v1/getUserDetails/{userId}
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];params: name,emails, password, user_type, username all are required
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/getUserDetails/%@",SERVERURLPATH,self.appUserObject.userId]];
   
    [class setCallback:@selector(callBackServiceToGetGetUserDetail:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetGetUserDetail:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        self.appUserObject = [AppUserObject instanceFromDictionary:[rootDictionary objectForKey:@"user"]];
        
        [self.appUserObject saveToUserDefault];
      
        
        self.txtLastName.text=self.appUserObject.lastName;
        self.txtFirstName.text=self.appUserObject.first;
         //self.txtPhone.text=self.appUserObject.phoneNo;
         self.txtEmail.text=self.appUserObject.email;

            if([self.txtPhone.text isEqualToString:@"0"]){
                self.txtPhone.text =@"";
         
            }else{
                if(self.appUserObject.phoneNo.length==10)
                {
                NSMutableString *mu = [NSMutableString stringWithString:self.appUserObject.phoneNo];
                [mu insertString:@" - " atIndex:3];
                [mu insertString:@" - " atIndex:9];
                self.txtPhone.text=mu;
                }else{
                    self.txtPhone.text=self.appUserObject.phoneNo;
                }
            }
//
        NSLog(@"ttt %@",self.appUserObject.profileImage);
        if (self.appUserObject.profileImage ==(id)[NSNull null] ||[self.appUserObject.profileImage isEqualToString:@""]) {
            NSLog(@"ttt %@",self.appUserObject.profileImage);
           [self.btnEdit setButtonTitle:@"Upload"];
           
        }else{
            [self.activityProfileImage startAnimating];
            [self.imgUserProfile ecs_setImageWithURL:[NSURL URLWithString:self.appUserObject.profileImage] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 [self.activityProfileImage stopAnimating];
             }];
            [self.btnEdit setButtonTitle:@"edit"];
     
        }
        
         }

    else {
        
        // [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
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




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
   if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]){
         if(buttonIndex==0)
        {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
         else if(buttonIndex==1){
             imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                         imagePickerController.delegate = self;
                         [self presentViewController:imagePickerController animated:YES completion:nil];
         }
        else if(buttonIndex==2)
        {

            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                         usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                             if (nil != group) {
                                                 // be sure to filter the group so you only get photos
                                                 [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                                 
                                                 if (group.numberOfAssets > 0) {
                                                     [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                                                             options:0
                                                                          usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                                              if (nil != result) {
//                                                                                  ALAssetRepresentation *repr = [result defaultRepresentation];
//                                                                                  // this is the most recent saved photo
//                                                                                  UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage]];
                                                                                  ALAssetRepresentation *rep = [result defaultRepresentation];
                                                                                  UIImage *img = [UIImage
                                                                                                  imageWithCGImage:[rep fullScreenImage]
                                                                                                  scale:[rep scale]
                                                                                                  orientation:UIImageOrientationUp];
                                                                                 // UIImage *img = [UIImage imageWithCGImage:[rep fullResolutionImage]];

                                                                                  self.btnEdit.hidden=NO;
                                                                                  self.imgUserProfile.image=img;
                                                                                    self.isImageUploadRequired = YES;
                                                                                  CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
                                                                                  contentScreen.selectedImage=self.imgUserProfile.image;
                                                                                  [self.navigationController pushViewController:contentScreen animated:YES];
                                                                                  *stop = YES;
                                                                              }
                                                                          }];
                                                 }
                                             }
                                             
                                             *stop = NO;
                                         } failureBlock:^(NSError *error) {
                                             NSLog(@"error: %@", error);
                                         }];
        }

    }
   
   else{
    if (buttonIndex==0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Ok" ,nil];
        alert.tag=101;
        [alert show];
        
    }
   else if(buttonIndex==1)
    {
        
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePickerController.delegate = self;
//        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
        contentScreen.selectedImage=self.imgUserProfile.image;
        [self.navigationController pushViewController:contentScreen animated:YES];
        

    }
    else if(buttonIndex==2)
    {
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePickerController.delegate = self;
//        [self presentViewController:imagePickerController animated:YES completion:nil];
        
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.delegate = self;
                [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if(buttonIndex == 1){
           // self.appUserObject.profileImage=nil;
            NSLog(@"self.appUserObject.profileImage %@",self.appUserObject.profileImage);
            if ([self.appUserObject.profileImage isEqualToString:@""]) {
                [self.btnEdit setButtonTitle:@"Upload"];
                
               
              //  NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
                 self.imgUserProfile.image=nil;
                
                self.imgUserProfile.image=[UIImage imageNamed:@"add-photo.png"];
               self.imgUserProfile.clipsToBounds = YES;
                self.imgUserProfile.backgroundColor=[UIColor whiteColor];
               
                if(isProfileUpdate==YES){
                    isProfileUpdate=NO;
                    [self startServiceDeleteUserProfileImage];
                }
                
            }else{
            //self.btnEdit.hidden=YES;
             [self startServiceDeleteUserProfileImage];
        }
        }
        //Do something
    }
    else
    {
        //Do something else
    }
}
-(void)startServiceDeleteUserProfileImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteUserProfileImage) withObject:nil];
    
    
}

-(void)serviceToDeleteUserProfileImage
{
    //http://www.buckworm.com/laravel/index.php/api/v1/removeUserProfilePic/{userId}
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/removeUserProfilePic/user/%@",SERVERURLPATH,self.appUserObject.userId]];
    [class addParam:@"ios" forKey:@"device_type"];
   // [class addParam:@"user" forKey:@"type"];
    [class setCallback:@selector(callBackServiceToDeleteUserProfileImage:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteUserProfileImage:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Image removed successfully."]) {
            [ECSAlert showAlert:@"Deleted!"];
            self.btnEdit.hidden=NO;
           [self.btnEdit setButtonTitle:@"Upload"];
            self.imgUserProfile.image=nil;
           // NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
            self.imgUserProfile.image=[UIImage imageNamed:@"add-photo.png"];
            self.imgUserProfile.backgroundColor=[UIColor whiteColor];
        }else{
             self.imgUserProfile.image=nil;
           // self.imgUserProfile.image = [UIImage imageNamed:@"add-photo.png"];
            [self.imgUserProfile setImage:[UIImage imageNamed:@"add-photo.png"]];
            [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        }
        
        
    }
    else {
        
        //[ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    
    self.btnEdit.hidden=NO;
    self.imgUserProfile.image=image;
    [self.btnUserImag setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        self.isImageUploadRequired = YES;
    }];
    [self editProfileImagedirectioly];
}


-(IBAction)editProfileImage:(id)sender{
    if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                                 delegate:(id<UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Library", @"Camera",@"Last Photo Taken", nil];
        
        [actionSheet showInView:self.view];
    }else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                                 delegate:(id<UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete "
                                                        otherButtonTitles:@"Resize", @"Choose New", nil];
        
        [actionSheet showInView:self.view];

        
    }
    
    
   
    
}
 -(void)editProfileImagedirectioly{
    
    
    
    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
    contentScreen.selectedImage=self.imgUserProfile.image;
    [self.navigationController pushViewController:contentScreen animated:YES];
    
    
}

- (IBAction)clickToResetPassword:(id)sender {
    
//    BC_ResetPassword * contactVc= [[BC_ResetPassword alloc]initWithNibName:@"BC_ResetPassword" bundle:nil];
//    NSMutableArray * arrayViewController = self.navigationController.viewControllers.mutableCopy;
//    [arrayViewController removeObject:self];
//    [UIView beginAnimations: @"View Flip" context: nil];
//    [UIView setAnimationDuration: 1.0];
//    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: self.navigationController.view cache: NO];
//    
//    [arrayViewController addObject:contactVc];
//    [self.navigationController setViewControllers:arrayViewController];
//   // [self.navigationController pushViewController:contactVc animated:YES];
//    [UIView commitAnimations];

    
    
}

- (IBAction)clickToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
