//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "BC_AddContactVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SAMTextView.h"
#import "ECSServiceClass.h"
#import "GroupObject.h"
#import "ECSAppHelper.h"
#import "JJMaterialTextField.h"
//#import "iToast.h"
#import "SaveContactObject.h"
#import "CHE_EditImageVC.h"

#import "ALChatManager.h"

#import <Applozic/ALDataNetworkConnection.h>
#import <Applozic/ALDBHandler.h>
#import <Applozic/ALContact.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "THContactPickerViewController.h"
#import "THContact.h"
#import "DS_GroupListCell.h"
//#import "DS__ContactVC.h"
@interface BC_AddContactVC ()<UITextFieldDelegate>
{
    THContact *user;
    NSString *selectPicker;
    NSNumber *group_id;
    NSMutableArray *arrayContacts;
}
@property (nonatomic, retain) GroupObject * groupObject;
@property (nonatomic, retain) SaveContactObject * saveContObject;
@property (nonatomic, retain) NSMutableArray * arrayGroups;
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
@property  (weak, nonatomic) IBOutlet UIButton *btnFav;
@property  (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (nonatomic, retain) NSMutableArray * arraySelected;
@property (nonatomic, retain) NSMutableArray * arraySelectedGroups;
@property (nonatomic, retain) NSMutableArray * arraySelectedGroupsId;
@property (weak, nonatomic) IBOutlet UITableView  *tblGroup;
@property (weak, nonatomic) IBOutlet UITableView  *tblContactDetails;
@property (weak, nonatomic) IBOutlet UIButton  *addButton;
@property (strong, nonatomic) IBOutlet UIView *viewGpList;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
@property  BOOL isFav;
- (IBAction)clickToAddContact:(id)sender;
- (IBAction)clickToUploadImage:(id)sender;
@end


@implementation BC_AddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self settingTopView:self.viewTop onController:self andTitle:@"Add new contact"]; Add to Group
    
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
    
    self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2;
    self.imgUserProfile.clipsToBounds = YES;
    [self.btnFav addTarget:self action:@selector(clickToChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self textFieldInitialization];
//    [self setTextFieldImages];
//    [self setTextFieldsPadding];
    self.txtPhone.delegate=self;
    [self.txtPhone setNumberKeybord];
    self.txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    [self.txtAddGroup setInputView:self.pickrView];
    [self.txtAddGroup setNumberKeybord];
    selectPicker=@"groups";
   // [self startServiceToAllGroups];
    if ([self.openWithGroup isEqualToString:@"GROUP"]) {
        
        self.txtAddGroup.hidden=YES;
    }else{
        self.txtAddGroup.hidden=NO;
         self.txtAddGroup.delegate=self;
    }
   
    
    
    self.txtFirstName.text=self.selectedContactsData.firstName;
    self.txtLastName.text=self.selectedContactsData.lastName;
    self.txtPhone.text=self.selectedContactsData.phoneNo;
    self.txtAddGroup.text=self.selectedContactsData.groupName;
    self.txtEmail.text=self.selectedContactsData.email;
   
//    NSString *strimage = self.selectedContactsData.image;
//    if (strimage) {
//         self.btnEdit.hidden=NO;
//        [self.imgUserProfile ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//    }
   
   
    if ([self.selectedContactsData.isFav isEqualToString:@"1"]) {
        self.isFav = YES;
           [self.btnFav setImage:[UIImage imageNamed:@"Favorite-icon.png"] forState:UIControlStateNormal];
    }

    arrayContacts=[[NSMutableArray alloc]init];
    self.arraySelected=[[NSMutableArray alloc]init];
    self.arraySelectedGroupsId=[[NSMutableArray alloc]init];
    self.arraySelectedGroups=[[NSMutableArray alloc]init];
    self.tblContactDetails.tableHeaderView=self.viewHeader;
      self.tblContactDetails.tableFooterView=self.viewFooter;
    self.tblContactDetails.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tblGroup.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self  startServiceToAllGroups];
    [self.btnEdit setButtonTitle:@"Upload"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SetResizeProfileImage:)
                                                 name:@"TestNotificationProfile"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(ForPhoneContactShow:) name:@"carryingDataofFilter" object:nil];
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

- (void)SetResizeProfileImage:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
  [self.btnEdit setButtonTitle:@"edit"];
    NSLog(@"notification.object%@",notification.object);
    if (notification.object) {
        self.imgUserProfile.image=notification.object;
    }
    
}
-(void)textFieldInitialization
{
    self.txtFirstName.enableMaterialPlaceHolder = YES;
    self.txtFirstName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
  //  self.txtFirstName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.txtFirstName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    self.txtLastName.enableMaterialPlaceHolder = YES;
    self.txtLastName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
  //  self.txtLastName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.txtLastName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtEmail.enableMaterialPlaceHolder = YES;
    _txtEmail.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
  //  _txtEmail.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtEmail.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtPhone.enableMaterialPlaceHolder = YES;
    _txtPhone.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
  //  _txtPhone.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtPhone.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    

    
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == self.txtEmail)
    {
         [self.tblContactDetails setContentOffset:CGPointMake(0, 80)];
//        selectPicker = @"groups";
//        [self.pickrView reloadAllComponents];
        
    }
    
    
    
    return YES;
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

- (IBAction)clickToAddContact:(id)sender {
    
    [self resignTextResponder];
    
    if (self.txtFirstName.text.length==0 && self.txtLastName.text.length==0)
    {
        [ECSAlert showAlert:@"Please enter your first name or last name"];


    }
//    else if (self.txtLastName.text.length==0)
//    {
//       // [ECSAlert showAlert:@"Please enter your last name"];
//        [[[[iToast makeText:@"Please enter your last name"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
//    }
//    else if(self.txtEmail.text.length==0)
//    {
//       // [ECSAlert showAlert:@"Please enter your email address"];
//        [[[[iToast makeText:@"Please enter your email address"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
//    }
    else if (![self validateEmail:self.txtEmail.text]&& self.txtPhone.text.length < 10 ){
        
        [ECSAlert showAlert:@"Please enter a valid email address Or phone number"];

    }

//    else if (self.txtPhone.text.length < 10)
//    {
//        [ECSAlert showAlert:@"Please enter valid phone number"];
//    }
    
    
    else
    {
        [self startServiceAddContact];
        
    }
    
}
-(void)startServiceAddContact
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToAddContact) withObject:nil];
    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          self.txtFirstName.text,@"firstName",
//                          self.txtLastName.text,@"lastName",
//                          self.txtEmail.text,@"email",
//                          self.txtPhone.text,@"phone",
//                          nil];
//    
//    
//    SaveContactObject  *object=[SaveContactObject instanceFromDictionary:dict];
//    [arrayContacts addObject:object];
//    
//    self.saveContObject = [SaveContactObject instanceFromDictionary:dict];
//    
//    [self.saveContObject saveToUserDefault];
//    
//    
//    NSLog(@"saved %@", arrayContacts);
    
    
}

-(void)serviceToAddContact
{
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:IMAGE];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/SaveFundraiserContacts",SERVERURLPATH]];
     NSString *userID = [self.appUserObject.userId stringValue];
    [class addParam:userID forKey:@"fundraiser_id"];
    [class addParam:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:self.isFav]] forKey:@"isFav"];
    [class addParam:self.txtFirstName.text forKey:@"first_name"];
    [class addParam:self.txtLastName.text forKey:@"last_name"];
    [class addParam:self.txtEmail.text forKey:@"email"];
   
    NSString *str = self.txtPhone.text;
    
    str = [str stringByReplacingOccurrencesOfString:@" - "
                                         withString:@""];
    [class addParam:str forKey:@"phone_no"];
   // NSString *groupId=self.arraySelectedGroupsId.description;
    NSString *joinedComponents = [self.arraySelectedGroupsId componentsJoinedByString:@","];
   // llkfd
    [class addParam:joinedComponents forKey:@"groupid"];
    [class addParam:self.txtAddGroup.text forKey:@"groupName"];
   // self.imgUserProfile
     if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]) {
        NSLog(@"jjj");
          // self.imgUserProfile.image = [UIImage imageNamed:@"blank_placeholder.png"];
        
    }else{
        if (user.imageData) {
            [class addImageData:user.imageData withName:@"profilepic.png" forKey:@"image"];
        }else{
         [class addImageData:UIImageJPEGRepresentation(self.imgUserProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
        }
    }
   
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToAddContact:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToAddContact:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        //Data saved succesfully.
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Data saved succesfully."]) {
            
            
            [ECSAlert showAlert:@"Updated"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        //else{
       // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        
       // }
        
    }
    else {
        
        [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}





-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    self.imgUserProfile.image=image;
    if (image) {
         self.btnEdit.hidden=NO;
    }
   
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    [self editProfileImagedirectioly];
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
        if(self.arrayGroups.count)
        {
            self.lblAlert.hidden=YES;

        }
        else
        {
              self.lblAlert.hidden=NO;

            //[[iToast makeText:@"There is no group for this contact"]show];
        }
        
    }
    else {
        
        // [ECSAlert showAlert:@"there is no group"];
    }
    [self.tblGroup reloadData];
     [self.tblContactDetails reloadData];
    
}

-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Resize", @"Choose New", nil];
        
        [actionSheet showInView:self.view];
        
        
    }

}
-(void)editProfileImagedirectioly{
    
    
    
    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
    contentScreen.selectedImage=self.imgUserProfile.image;
    [self.navigationController pushViewController:contentScreen animated:YES];
    
    
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
                                                                                  //self.isImageUploadRequired = YES;
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
       
        if(buttonIndex==0)
        {
            
            //        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //        imagePickerController.delegate = self;
            //        [self presentViewController:imagePickerController animated:YES completion:nil];
            
            CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
            contentScreen.selectedImage=self.imgUserProfile.image;
            [self.navigationController pushViewController:contentScreen animated:YES];
            
            
        }
        else if(buttonIndex==1)
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

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    
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
    
    [cell.btnCheck addTarget:self action:@selector(clickToChooseGroup:) forControlEvents:UIControlEventTouchUpInside];
    
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

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES ];
}

- (IBAction)clickToChooseGroup:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [_arraySelected containsObject:strContact];
    
      GroupObject * connectionObject = [self.arrayGroups objectAtIndex:btn.tag];
    
    if(flag == NO )
    {
        [_arraySelected addObject:strContact];
        [self.arraySelectedGroups addObject:connectionObject];
        [self.arraySelectedGroupsId addObject:connectionObject.groupObjectId];
    }
    else {
   
        
        [self.arraySelectedGroups removeObject:connectionObject];
        
          [self.arraySelectedGroupsId removeObject:connectionObject.groupObjectId];
        [_arraySelected removeObject:strContact];
        
        
        
    }
    NSLog(@"_arraySelected %@",_arraySelected);
    
    [self.tblGroup reloadData];
}

-(IBAction)onClickEditGroup:(id)sender{
    self.viewGpList.hidden=NO;

    self.viewGpList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.viewGpList];
    
}

-(IBAction)onclickOfDone:(id)sender{
     [self.tblContactDetails reloadData];
//    UIImage *btnImage = [UIImage imageNamed:@"editbutton.png"];
//    [self.addButton setImage:btnImage forState:UIControlStateNormal];
    if (self.arraySelectedGroups.count) {
        UIImage *btnImage = [UIImage imageNamed:@"editbutton.png"];
        [self.addButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"add button.png"];
        [self.addButton setImage:btnImage forState:UIControlStateNormal];
    }

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
