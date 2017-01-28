//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "BC_UpdateContactVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SAMTextView.h"
#import "ECSServiceClass.h"
#import "GroupObject.h"
#import "ContactObject.h"
#import "JJMaterialTextfield.h"
//#import "iToast.h"
#import "CHE_EditImageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DS_GroupListCell.h"
#import "THContactPickerViewController.h"
#import "THContact.h"
@interface BC_UpdateContactVC ()<UITextFieldDelegate>
{
    NSString *selectPicker;
    NSNumber *group_id;
    NSNumber *contact_id;
     BOOL isProfileUpdate;
    THContact *user;
    
}
@property (nonatomic, retain) GroupObject * groupObject;
@property (nonatomic, retain) NSMutableArray * arrayGroups;
@property (nonatomic, retain) NSNumber * contactID;
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtFirstName;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtLastName;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtEmail;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtPhone;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtAddGroup;
@property (weak, nonatomic) IBOutlet UIPickerView *pickrView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImag;
@property (weak, nonatomic) IBOutlet UIButton *btnFav;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (nonatomic, retain) NSMutableArray * arraySelected;
@property (nonatomic, retain) NSMutableArray * arraySelectedGroups;
@property (weak, nonatomic) IBOutlet UITableView  *tblGroup;
@property (weak, nonatomic) IBOutlet UITableView  *tblContactDetails;
@property (nonatomic, retain) NSMutableArray * arraySelectedGroupsId;
@property (nonatomic, retain) NSMutableArray * arraySelectedGroupsImges;
@property (strong, nonatomic) IBOutlet UIView *viewGpList;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
//addButton
@property (weak, nonatomic) IBOutlet UIButton  *addButton;
@property BOOL *isFav;

- (IBAction)clickToCancel:(id)sender;
- (IBAction)clickToDelete:(id)sender;

- (IBAction)clickToUpdateContact:(id)sender;
- (IBAction)clickToUploadImage:(id)sender;
@end


@implementation BC_UpdateContactVC

-(id)initWithContactDetail:(NSNumber *)ContactId
{
    self = [self initWithNibName:@"BC_UpdateContactVC" bundle:nil];
    self.contactID = ContactId;
    
    return self;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
      isProfileUpdate=NO;
   // [self settingTopView:self.viewTop onController:self andTitle:@"Update contact"];
   
    self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2;
    self.imgUserProfile.clipsToBounds = YES;
    [self.btnFav addTarget:self action:@selector(clickToChoose:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setTextFieldImages];
//    [self setTextFieldsPadding];
    self.txtPhone.delegate=self;
    [self.txtPhone setNumberKeybord];
    self.txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    [self.txtAddGroup setInputView:self.pickrView];
    
    [self.txtAddGroup setNumberKeybord];
    [self startServiceGetUserData];
    UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
    //     self.txtAddGroup.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add to Group" attributes:@{NSForegroundColorAttributeName: color}];
    UIFont *font1 = [UIFont fontWithName:@"Karla-Bold" size:16];
    //  self.txtAddGroup.font=font1;
    self.txtFirstName.font=font1;
    self.txtLastName.font=font1;
    self.txtEmail.font=font1;
    self.txtPhone.font=font1;
    
    [self.btnEdit setButtonTitle:@"Upload"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recivedCropedImage:)
                                                 name:@"TestNotificationProfile"
                                               object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(ForPhoneContactShow:) name:@"carryingDataofFilter" object:nil];

    
    [self setMaterialDesignForTexts];
    
    self.arraySelected=[[NSMutableArray alloc]init];
    self.arraySelectedGroups=[[NSMutableArray alloc]init];
    self.arraySelectedGroupsId=[[NSMutableArray alloc]init];
    self.arraySelectedGroupsImges=[[NSMutableArray alloc]init];
    self.tblContactDetails.tableHeaderView=self.viewHeader;
    self.tblContactDetails.tableFooterView=self.viewFooter;
  self.tblContactDetails.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.tblGroup.separatorStyle = UITableViewCellSeparatorStyleNone;
   [self  startServiceToAllGroups];

}





-(void)ForPhoneContactShow:(NSNotification *) notification
{
    
    user = notification.object;
    //    user = notification.object;
    
    self.txtLastName.text = user.lastName;
    self.txtFirstName.text= user.firstName;
    
    if (user.phone.length==10) {
        NSString *str = user.phone;
        
        str = [str stringByReplacingOccurrencesOfString:@""
                                             withString:@""];
        self.txtPhone.text = str;
        
    }
    else if (user.phone.length==12){
        NSString *str = user.phone;
        
        str = [str stringByReplacingOccurrencesOfString:@"-"
                                             withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"("
                                             withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@")"
                                             withString:@""];
        NSString *code = [str substringFromIndex: [str length] - 10];
        self.txtPhone.text = code;
    } else if (user.phone.length==11){
        NSString *str = user.phone;
        
        str = [str stringByReplacingOccurrencesOfString:@"-"
                                             withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"("
                                             withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@")"
                                             withString:@""];
        NSString *code = [str substringFromIndex: [str length] - 10];
        self.txtPhone.text = code;
    }else{
        NSString *str = user.phone;
        
        str = [str stringByReplacingOccurrencesOfString:@"-"
                                             withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"("
                                             withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@")"
                                             withString:@""];
        NSString *code = [str substringFromIndex: [str length] - 10];
        self.txtPhone.text = code;
        
    }
    if (self.txtPhone.text.length==10) {
        {
            NSMutableString *mu = [NSMutableString stringWithString:self.txtPhone.text];
            [mu insertString:@" - " atIndex:3];
            [mu insertString:@" - " atIndex:9];
            self.txtPhone.text=mu;
        }
    }
    self.txtEmail.text=user.email;
    //    if (user.imageData) {
    //        [self.btnEdit setButtonTitle:@"edit"];
    //          [self.imgUserProfile setImage:[UIImage imageWithData:user.imageData]];
    //    }
    
    // NSLog(@"user.imageData %@",user.imageData);
    
}

- (void) recivedCropedImage:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    [self.btnEdit setButtonTitle:@"edit"];
    if (notification.object) {
      self.imgUserProfile.image=notification.object;
    }
   
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == self.txtEmail)
    {
        [self.tblContactDetails setContentOffset:CGPointMake(0, 80)];
        //        selectPicker = @"groups";
        //        [self.pickrView reloadAllComponents];
        
    }
    
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([selectPicker isEqualToString:@"groups"]) {
        return self.arrayGroups.count;
    }
    
    
    return 1;
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if ([selectPicker isEqualToString:@"groups"]) {
        GroupObject * object = [self.arrayGroups objectAtIndex:row];
        return object.name;
        
    }
    
    return  @"";
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([selectPicker isEqualToString:@"groups"]) {
        GroupObject * object = [self.arrayGroups objectAtIndex:row];
        group_id = object.groupObjectId;
        [self.txtAddGroup setText:object.name];
    }
    
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.txtAddGroup)
    {
        [self openStatePicker:textField];
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == self.txtAddGroup)
    {
        if(textField.text.length == 0 && self.arrayGroups.count > 0)
        {
            GroupObject * object = [self.arrayGroups objectAtIndex:0];
            group_id = object.groupObjectId;
            [self.txtAddGroup setText:object.name];
        }
    }
}


- (IBAction)openStatePicker:(id)sender {
    
    
    selectPicker = @"groups";
    [self  startServiceToAllGroups];
    
    
    
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setTextFieldImages{
    
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 19)];
    [userImage setImage:[UIImage imageNamed:@"drop-down-icon.png"]];
    
    self.txtAddGroup.rightView = userImage;
    self.txtAddGroup.rightViewMode = UITextFieldViewModeAlways;
    
    
}

-(void)setTextFieldsPadding
{
    [self.txtFirstName setRightPadding];
    [self.txtLastName setRightPadding];
    [self.txtEmail setRightPadding];
    [self.txtAddGroup setLeftPadding];
    [self.txtPhone setRightPadding];
}

-(void)resignTextResponder
{
    
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtAddGroup resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    
}



-(void)setMaterialDesignForTexts
{
    
    
   self.txtFirstName.enableMaterialPlaceHolder = YES;
    self.txtLastName.enableMaterialPlaceHolder = YES;
    self.txtEmail.enableMaterialPlaceHolder = YES;
    self.txtAddGroup.enableMaterialPlaceHolder = YES;
    self.txtPhone.enableMaterialPlaceHolder = YES;

}

- (IBAction)clickToCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)clickToDelete:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag = 2001;
    [alert show];
    alert = nil;
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 2001)
    {
        if (buttonIndex==1)
        {
           [self startServiceDeleteContact];
            
        }
    }else if (alertView.tag==1015) {
        if(buttonIndex == 1){
            [self startServiceDeleteUserProfileImage];
        }
    }
   else if (alertView.tag == 1011)
    {
        if (buttonIndex == 0){
            
        }else if(buttonIndex == 1){
            NSLog(@"self.appUserObject.profileImage %@",self.appUserObject.profileImage);
            if ([self.appUserObject.profileImage isEqualToString:@""]) {
                
                 [self.btnEdit setButtonTitle:@"Upload"];
                
                NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
                
                
                self.imgUserProfile.image=[UIImage imageNamed:nothingString];
                
                self.imgUserProfile.backgroundColor=[UIColor whiteColor];
                
                if(isProfileUpdate==YES){
                    isProfileUpdate=NO;
                    [self startServiceDeleteUserProfileImage];
                }
                
            }else{
               [self.btnEdit setButtonTitle:@"Upload"];
                NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
                
                
                self.imgUserProfile.image=[UIImage imageNamed:nothingString];
                
                self.imgUserProfile.backgroundColor=[UIColor whiteColor];
                
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

- (IBAction)clickToUpdateContact:(id)sender {
    
    [self resignTextResponder];
    
    if (self.txtFirstName.text.length==0 && self.txtLastName.text.length==0)
    {
        [ECSAlert showAlert:@"Please enter your first name or last name"];
    }
  
    else if (![self validateEmail:self.txtEmail.text]&& self.txtPhone.text.length < 10 ){
        
        [ECSAlert showAlert:@"Please enter a valid email address Or phone number"];
        
    }
    else
    {
        [self startServiceUpdateContact];
        
    }
    
}
-(void)startServiceUpdateContact
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToUpdateContact) withObject:nil];
    
    
}




-(void)serviceToUpdateContact
{
/*https://www.buckworm.com/laravel/index.php/api/v1/updateFundraisersContact/{contact_id}*/


/*Params:fundraiser_id,first_name,last_name,email,phone_no,image,isFav(0,1),groupid

*/
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:IMAGE];
    // [class addHeader:APP_KEY_VAL forKey:APP_KEY];
    // [class addHeader:DEVICE_ID_VAL forKey:DEVICE_ID];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    if (self.memContactId) {
         [class setServiceURL:[NSString stringWithFormat:@"%@v1/updateFundraisersContact/%@",SERVERURLPATH,self.memContactId]];
    }else{
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/updateFundraisersContact/%@",SERVERURLPATH,self.selectedContactsData.contactId]];
    }
    
    [class addParam:self.appUserObject.userId.stringValue forKey:@"fundraiser_id"];
    [class addParam:self.txtFirstName.text forKey:@"first_name"];
     [class addParam:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:self.isFav]] forKey:@"isFav"];
    [class addParam:self.txtLastName.text forKey:@"last_name"];
    [class addParam:self.txtEmail.text forKey:@"email"];
    NSString *str = self.txtPhone.text;
    
    str = [str stringByReplacingOccurrencesOfString:@" - "
                                         withString:@""];
    [class addParam:str forKey:@"phone_no"];
     NSString *joinedComponents = [self.arraySelectedGroupsId componentsJoinedByString:@","];
    [class addParam:joinedComponents forKey:@"groupid"];
    if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]) {
        NSLog(@"");
    }else{
        [class addImageData:UIImageJPEGRepresentation(self.imgUserProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
    }
   // [class addImageData:UIImageJPEGRepresentation(self.imgUserProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
    
    
    
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToUpdateContact:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToUpdateContact:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
      
        
        isProfileUpdate=YES;
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Data saved succesfully."]) {
            [ECSAlert showAlert:@" Contact updated!"];
          
            [self.navigationController popViewControllerAnimated:YES];

        }else{
//            [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

        }
                [self dismissViewControllerAnimated:YES completion:^{
            
        }];

        
    }
    else {
        
//       // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
}


- (IBAction)clickToChoose:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    if(self.isFav == NO )
    {
        self.isFav = YES;
        [btn setImage:[UIImage imageNamed:@"Favorite-icon.png"] forState:UIControlStateNormal];
        
        
        
    }
    else {
        self.isFav = NO;
        [btn setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    
}





-(void)startServiceGetUserData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(serviceGetUserData) withObject:nil];
    
    
    
    
}

-(void)serviceGetUserData
{
    /*http://www.buckworm.com/laravel/index.php/api/v1/getContactDetails/{contact_id}*/
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    if (self.memContactId) {
         [class setServiceURL:[NSString stringWithFormat:@"%@v1/getContactDetails/%@",SERVERURLPATH,self.memContactId]];
    }else{
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/getContactDetails/%@",SERVERURLPATH,self.selectedContactsData.contactId]];
    }
   
    [class setCallback:@selector(callBackServiceToGetProfile:)];
    [class setController:self];
    [class runService];
}


-(void)callBackServiceToGetProfile:(ECSResponse *)response
{
    NSDictionary * rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    
    if(response.isValid)
    {
        
        NSArray * group=[rootDictionary objectForKey:@"Groups"];
        for (NSDictionary * dictionary in group)
        {
            GroupObject  *connectionObject=[GroupObject instanceFromDictionary:dictionary];
              [self.arraySelectedGroupsId addObject:connectionObject.groupObjectId];
            //[self.arraySelectedGroupsImges addObject:connectionObject.image];
            [self.arraySelectedGroups addObject:connectionObject];
            
        }
        if (self.arraySelectedGroups.count) {
            UIImage *btnImage = [UIImage imageNamed:@"editbutton.png"];
            [self.addButton setImage:btnImage forState:UIControlStateNormal];
        }else{
            UIImage *btnImage = [UIImage imageNamed:@"add button.png"];
            [self.addButton setImage:btnImage forState:UIControlStateNormal];
        }
        
        NSArray * contact=[rootDictionary objectForKey:@"contacts"];
        for (NSDictionary * dictionary in contact)
        {
            ContactObject  *object=[ContactObject instanceFromDictionary:dictionary];
            
            [self.txtFirstName setText:object.firstName];
            [self.txtLastName setText:object.lastName];
            [self.txtEmail setText:object.email];
            if (object.phoneNo.length>=10) {
                NSMutableString *mu = [NSMutableString stringWithString:object.phoneNo];
                [mu insertString:@" - " atIndex:3];
                [mu insertString:@" - " atIndex:9];
                self.txtPhone.text=mu;
            }
            
            [self.txtAddGroup setText:object.groupName];
            
            if ([object.image isEqualToString:@""]) {
                [self.btnEdit setButtonTitle:@"Upload"];
                self.imgUserProfile.image = [UIImage imageNamed:@"blank_placeholder.png"];
            }else{
                [self.btnEdit setButtonTitle:@"edit"];
                [self.imgUserProfile ecs_setImageWithURL:[NSURL URLWithString:[object.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
            }
            if(object.isFav.intValue == 1 )
            {
                
                [self.btnFav setImage:[UIImage imageNamed:@"Favorite-icon.png"] forState:UIControlStateNormal];
                
                
                
            }
            else {
                
                [self.btnFav setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
            }
            
        }
        
        
        
    }
    
    else
        [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self.tblContactDetails reloadData];
}

-(void)startServiceDeleteContact
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteContact) withObject:nil];
    
    
}

-(void)serviceToDeleteContact
{

    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/deleteContact/%@",SERVERURLPATH,self.selectedContactsData.contactId]];
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToDeleteContact:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteContact:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
      
       // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Deleted successfully."]) {
            [ECSAlert showAlert:@"Deleted successfully!"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
      
    }
    else {
        
        //[ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}


-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

//- (IBAction)clickToUploadImage:(id)sender {
//    
//    
//    [self resignTextResponder];
//    if (self.btnEdit.hidden==YES) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
//                                                                 delegate:(id<UIActionSheetDelegate>)self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
//        
//        [actionSheet showInView:self.view];
//    }else{
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
//                                                                 delegate:(id<UIActionSheetDelegate>)self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:@"Delete Photo"
//                                                        otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
//        
//        [actionSheet showInView:self.view];
//        
//    }
//}
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



-(void)startServiceDeleteUserProfileImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteUserProfileImage) withObject:nil];
    
    
}

-(void)serviceToDeleteUserProfileImage
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/removeUserProfilePic/contact/%@",SERVERURLPATH,self.selectedContactsData.contactId]];
    [class addParam:@"ios" forKey:@"device_type"];
   // [class addParam:@"contact" forKey:@"type"];
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
            NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
            self.imgUserProfile.image=[UIImage imageNamed:nothingString];
            self.imgUserProfile.backgroundColor=[UIColor whiteColor];
            
            [self.btnEdit setButtonTitle:@"Upload"];
           // [self.navigationController popViewControllerAnimated:YES];
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
            alert.tag=1015;
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








- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    self.imgUserProfile.image=image;
    self.btnEdit.hidden=NO;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
    contentScreen.selectedImage=self.imgUserProfile.image;
    [self.navigationController pushViewController:contentScreen animated:YES];

}

-(void)startServiceToAllGroups
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToAllGroups) withObject:nil];
    
    
}

-(void)serviceToAllGroups
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/allGroup",SERVERURLPATH]];
    
    [class setCallback:@selector(callBackServiceToGetAllGroups:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetAllGroups:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        
        if(self.arrayGroups == nil)
            self.arrayGroups = [[NSMutableArray alloc]init];
        else [self.arrayGroups removeAllObjects];
        
        NSArray * groupArray=[rootDictionary objectForKey:@"Groups"];
        for (NSDictionary * dictionary in groupArray)
        {
            GroupObject  *object=[GroupObject instanceFromDictionary:dictionary];
            [self.arrayGroups addObject:object];
        }
        if(groupArray.count > 0)
        {
            self.lblAlert.hidden=YES;
//            [self.pickrView reloadAllComponents];
//            [self.txtAddGroup becomeFirstResponder];
        }
        else
        {
            self.lblAlert.hidden=NO;
//            [self.txtAddGroup performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:YES];
           // [[iToast makeText:@"There is no group for this contact"]show];
        }
        
    }
    else {
        
        // [ECSAlert showAlert:@"there is no group"];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tblContactDetails) {
        return self.arraySelectedGroups.count;
    }
    
    return self.arrayGroups.count;
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"ConnectionObject";
    GroupObject * connectionObject;
    if (tableView==self.tblContactDetails) {
        connectionObject = [self.arraySelectedGroups objectAtIndex:indexPath.row];
    }else{
    connectionObject = [self.arrayGroups objectAtIndex:indexPath.row];
    }
    DS_GroupListCell *cell = (DS_GroupListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        UINib *nib = [UINib nibWithNibName:@"DS_GroupListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
        NSString *strimage = connectionObject.image;
        
        if ([strimage isKindOfClass:[NSNull class]]) {
            strimage = @"";
            
        }else if ([strimage isEqualToString:@""]){
            
        }
        else{
            [cell.imgView ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }

         [cell.lblText setText:[NSString stringWithFormat:@"%@ ",connectionObject.name]];
    
    [cell.btnCheck addTarget:self action:@selector(clickToChooseGroupUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL flag=   [_arraySelected containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
    
    
    
    if(tableView ==self.tblContactDetails){
        cell.btnCheck.hidden=YES;
    }else{
        cell.btnCheck.hidden=NO;
    }
    
    if(flag == NO )
    {
        
        
        [cell.btnCheck setImage:[UIImage imageNamed:@"check-box-icon.png"] forState:UIControlStateNormal];
        
    }
    else {
        
        
        [cell.btnCheck setImage:[UIImage imageNamed:@"checked-icon.png"] forState:UIControlStateNormal];
    }
    
    //    for (int i=0; i<self.arrayGroupMembers.count; i++) {
    //        ContactObject * connection = [self.arrayGroupMembers objectAtIndex:i];
    //        if ([connection.contactId isEqual:connectionObject.contactId]) {
    //             NSString *strContact=  [NSString stringWithFormat:@"%li",(long)indexPath.row];
    //            [_arraySelected addObject:strContact];
    //            [cell.btnCheck setImage:[UIImage imageNamed:@"checked-icon.png"] forState:UIControlStateNormal];
    //        }
    //    }
    
    
    cell.btnCheck.tag=indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}



- (IBAction)clickToChooseGroupUpdate:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [_arraySelected containsObject:strContact];
    
    GroupObject * connectionObject = [self.arrayGroups objectAtIndex:btn.tag];
    
    if(flag == NO )
    {
        [_arraySelected addObject:strContact];
        [self.arraySelectedGroups addObject:connectionObject];
        [self.arraySelectedGroupsImges addObject:connectionObject];
          [self.arraySelectedGroupsId addObject:connectionObject.groupObjectId];
    }
    else {
        
          [self.arraySelectedGroupsId removeObject:connectionObject.groupObjectId];
        [self.arraySelectedGroupsImges removeObject:connectionObject];
        [self.arraySelectedGroups removeObject:connectionObject];
        [_arraySelected removeObject:strContact];
        
        
        
    }
    NSLog(@"_arraySelected %@",_arraySelected);
     NSLog(@"arraySelectedGroups %@",self.arraySelectedGroups);
    NSLog(@"self.arraySelectedGroupsId %@",self.arraySelectedGroupsId);
    NSLog(@"self.arraySelectedGroupsId %@",self.arraySelectedGroupsImges);
    
    [self.tblGroup reloadData];
}

-(IBAction)onClickEditGroup:(id)sender{
     self.arraySelectedGroupsImges=[[NSMutableArray alloc]init];
    for (int i=0; i<self.arraySelectedGroups.count; i++) {
        GroupObject  *connectionObject = [self.arraySelectedGroups objectAtIndex:i];
        NSString *alertName=connectionObject.groupObjectId.stringValue ;
        for (int j=0; j<self.arrayGroups.count; j++) {
            GroupObject  *connectionObject = [self.arrayGroups objectAtIndex:j];
            NSString *name=connectionObject.groupObjectId.stringValue;
            NSString *strContact=[NSString stringWithFormat:@"%i",j];
           
            if ([alertName isEqualToString:name]) {
                // [arraySavedGroupName addObject:alertName];
                  [self.arraySelectedGroupsImges addObject:connectionObject];
                [self.arraySelected addObject:strContact];
            }
        }
    }

    self.viewGpList.hidden=NO;
    
    self.viewGpList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.viewGpList];
    
}

-(IBAction)onclickOfDone:(id)sender{
    [self.arraySelectedGroups removeAllObjects] ;
    self.arraySelectedGroups=[[NSMutableArray alloc]init];
  //  self.arraySelectedGroups=nil;
  //
      NSLog(@"self.arraySelectedGroupsImges %@",self.arraySelectedGroupsImges);
   // self.arraySelectedGroups =self.arraySelectedGroupsImges;
     [self.arraySelectedGroups addObjectsFromArray:self.arraySelectedGroupsImges];
    NSLog(@"self.arraySelectedGroups %@",self.arraySelectedGroups);
    if (self.arraySelectedGroups.count) {
        UIImage *btnImage = [UIImage imageNamed:@"editbutton.png"];
        [self.addButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"add button.png"];
        [self.addButton setImage:btnImage forState:UIControlStateNormal];
    }

    [self.tblContactDetails reloadData];
//    UIImage *btnImage = [UIImage imageNamed:@"editbutton.png"];
//    [self.addButton setImage:btnImage forState:UIControlStateNormal];
    self.viewGpList.hidden=YES;
}

-(IBAction)onclickOfBack:(id)sender{
    [self.tblContactDetails reloadData];
    self.viewGpList.hidden=YES;
}

-(IBAction)onClickContactFromPhone:(id)sender{
    //DS__ContactVC
    THContactPickerViewController *contactPicker = [[THContactPickerViewController alloc] initWithNibName:@"THContactPickerViewController" bundle:nil];
    [self.navigationController pushViewController:contactPicker animated:YES];
    //    DS__ContactVC *contactPicker = [[DS__ContactVC alloc] initWithNibName:@"DS__ContactVC" bundle:nil];
    //    [self.navigationController pushViewController:contactPicker animated:YES];
}

@end
