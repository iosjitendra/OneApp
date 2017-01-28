//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "BC_GroupDetailVC.h"
#import "ConnectionObject.h"
#import "ChooseMemberCell.h"
#import "ECSServiceClass.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GroupObject.h"
#import "ContactObject.h"
#import "GroupDetailViewCell .h"
#import "BC_ChooseMemberVC.h"
//#import "SVPullToRefresh.h"
//#import "iToast.h"
#import "CHE_EditImageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BC_UpdateContactVC.h"
@interface BC_GroupDetailVC ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isProfileUpdate;
    BOOL isimageChanged;
}
@property BOOL isImageUploadRequired;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSString * contactID;
@property (nonatomic, retain) NSMutableArray * arrayGroupMembers;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupName;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView  *tblContacts;
@property (nonatomic, retain) NSMutableArray * arrayConnection;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImag;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIView *viewEditGroup;
@property (weak, nonatomic) IBOutlet UITextField *txtEditGroupName;

- (IBAction)ClickToDeleteGroup:(id)sender;
- (IBAction)clickToUploadImage:(id)sender;
- (IBAction)clickToAddMembers:(id)sender;
- (IBAction)clickToEdit:(id)sender;

//@property (strong, nonatomic) IBOutlet UIView *viewTop;
- (IBAction)clickToBack:(id)sender;
@property BOOL isChecked;
@property BOOL isEditMode;
@end

@implementation BC_GroupDetailVC


-(id)initWithGroupDetail:(NSNumber *)GroupID
{
    self = [self initWithNibName:@"BC_GroupDetailVC" bundle:nil];
    self.groupID = GroupID;
   
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isimageChanged=NO;
    isProfileUpdate=NO;
    
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2;
    self.imgView.clipsToBounds = YES;
    [self startServiceToGroupDetail];
     [self.btnEdit setButtonTitle:@"Upload"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotificationProfile"
                                               object:nil];
    
    self.txtEditGroupName.text=self.txtGroupName.text;
    NSLog(@"self.groupID =%@",self.selectedGroupData.groupObjectId);
    
}


- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    [self.btnEdit setButtonTitle:@"edit"];
    if (notification.object) {
        self.imgView.image=notification.object;
    }

   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //[self.tblContacts triggerPullToRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (isimageChanged==YES) {
        NSLog(@"Image Changed");
    }else{
    [self startServiceToGroupDetail];
    }
    [self.tblContacts reloadData];
}


//-(IBAction)editProfileImage:(id)sender{
//    
//    
//    
//    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
//    contentScreen.selectedImage=self.imgView.image;
//    [self.navigationController pushViewController:contentScreen animated:YES];
//    
//    
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

     return self.arrayGroupMembers.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        
    static NSString *CellIdentifier = @"GroupDetailObject";
    GroupDetailViewCell *cell = (GroupDetailViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ContactObject * groupObject = [self.arrayGroupMembers objectAtIndex:indexPath.row];
    
    if(!cell){
        UINib *nib = [UINib nibWithNibName:@"GroupDetailViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (![groupObject.image isEqualToString:@""] ) {
        [cell.imgView ecs_setImageWithURL:[NSURL URLWithString:[groupObject.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
   
    
    [cell.btnDelete addTarget:self action:@selector(ClickToDeleteMember:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag=indexPath.row;
    
    [cell.btnEdit addTarget:self action:@selector(ClickToEditMember:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnEdit.tag=indexPath.row;
    _contactID=groupObject.contactId.stringValue;
    [cell.lblText setText:[NSString stringWithFormat:@"%@ %@",groupObject.firstName,groupObject.lastName]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
}
- (IBAction)clickToEdit:(id)sender{
    
    if(!self.isEditMode)
    {
        self.isEditMode = YES;
        [self.btnDone setButtonTitle:@"Done"];
        //[self.ViewAddress setHidden:NO];
    }
    else
    {
        
        [self startServiceUpdateContact];
        
    }
    
    
}


-(void)editProfileImagedirectioly{
    
    
    
    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
    contentScreen.selectedImage=self.imgView.image;
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
                                                                                  isimageChanged=YES;
                                                                                  self.imgView.image=img;
                                                                                  self.isImageUploadRequired = YES;
                                                                                  CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
                                                                                  contentScreen.selectedImage=self.imgView.image;
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
            alert.tag=1010;
            [alert show];
            
        }
        else if(buttonIndex==1)
        {
            
            //        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //        imagePickerController.delegate = self;
            //        [self presentViewController:imagePickerController animated:YES completion:nil];
            
            CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
            contentScreen.selectedImage=self.imgView.image;
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



- (IBAction)clickToChoose:(id)sender {
    UIButton *btn=(UIButton *)sender;
   
    if(self.isChecked == NO )
    {
        self.isChecked = YES;
        [btn setImage:[UIImage imageNamed:@"checked-icon.png"] forState:UIControlStateNormal];
        
        
        
    }
    else {
        self.isChecked = NO;
        [btn setImage:[UIImage imageNamed:@"check-box-icon.png"] forState:UIControlStateNormal];
    }
    
}
-(void)startServiceUpdateContact
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToUpdateContact) withObject:nil];
    
    
}

-(void)serviceToUpdateContact
{
   
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:IMAGE];
    // [class addHeader:APP_KEY_VAL forKey:APP_KEY];
    // [class addHeader:DEVICE_ID_VAL forKey:DEVICE_ID];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/UpdateGroup/%@",SERVERURLPATH,self.selectedGroupData.groupObjectId]];
    [class addParam:self.txtEditGroupName.text forKey:@"name"];
    if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]) {
        NSLog(@"");
    }else{
        [class addImageData:UIImageJPEGRepresentation(self.imgView.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
    }
    //[class addImageData:UIImageJPEGRepresentation(self.imgView.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
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
        
       
         [self.txtGroupName resignFirstResponder];
        
//    }
//    else {
//        
//        [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Group updated successfully"]) {
            
            isProfileUpdate=YES;
            self.viewEditGroup.hidden=YES;
            self.txtGroupName.text=self.txtEditGroupName.text;
            [ECSAlert showAlert:@"Updated."];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        }
        
        
    }
    else {
        if (rootDictionary) {
            [ECSAlert showAlert:response.stringValue];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
    }

}






-(void)startServiceDeleteGroup
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteGroup) withObject:nil];
    
    
}

-(void)serviceToDeleteGroup
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/deleteGroup/%@",SERVERURLPATH,self.selectedGroupData.groupObjectId]];
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToDeleteGroup:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteGroup:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Deleted successfully."]) {
            [ECSAlert showAlert:@"Deleted successfully!"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }

        
        
    }
    else {
        
        [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}


-(void)startServiceToGroupDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGroupDetail) withObject:nil];
    
    
}

-(void)serviceToGroupDetail
{
    /*https://www.buckworm.com/laravel/index.php/api/v1/getGroupMembers/{group_id}*/
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/getGroupMembers/%@",SERVERURLPATH,self.selectedGroupData.groupObjectId]];
   // [class addParam:self.groupID forKey:@"group_id"];
    [class setCallback:@selector(callBackServiceToGetGroupDetail:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetGroupDetail:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    
    if(response.isValid)
    {
        
        self.txtGroupName.text=[[rootDictionary objectForKey:@"Groups"]objectForKey:@"name"];
        NSString *strimage = [[rootDictionary objectForKey:@"Groups"]objectForKey:@"image"];
        
        if ([strimage isEqualToString:@""]) {
            isimageChanged=NO;
            [self.btnEdit setButtonTitle:@"Upload"];
            self.imgView.image = [UIImage imageNamed:@"add-photo.png"];
        }else{
            isimageChanged=NO;
             [self.btnEdit setButtonTitle:@"edit"];
            [self.imgView ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];

        }
        
        
        if(self.arrayGroupMembers == nil)
            self.arrayGroupMembers = [[NSMutableArray alloc]init];
        else [self.arrayGroupMembers removeAllObjects];
        
        NSArray * notification=[[rootDictionary objectForKey:@"Groups"]objectForKey:@"groupMembers"];
        for (NSDictionary * dictionary in notification)
        {
            ContactObject  *object=[ContactObject instanceFromDictionary:dictionary];
            [self.arrayGroupMembers addObject:object];
        }
        [self.tblContacts reloadData];
        
    }
    else {
        
       // [ECSAlert showAlert:@"there is no group detail"];
    }
    
}
-(void)startServiceDeleteMember
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteMember) withObject:nil];
    
    
}

-(void)serviceToDeleteMember
{
    //http://www.buckworm.com/laravel/index.php/api/v1/removecontactFromGroupMember
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/removecontactFromGroupMember",SERVERURLPATH]];
    [class addParam:self.contactID forKey:@"contact_id"];
    [class addParam:self.selectedGroupData.groupObjectId.stringValue forKey:@"group_id"];
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToDeleteMember:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteMember:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        if([[rootDictionary objectForKey:@"message"] isEqualToString:@"Oops!! something went wrong. Please try again later."])
        {
             [ECSAlert showAlert:@"Oops!! something went wrong. Please try again later."];
        } else if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Delete Contacts Group successfully"]){
             [ECSAlert showAlert:@"Member removed!"];
             [self startServiceToGroupDetail];
        }else{
             [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
        }
            
       
   
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    else {
        
       // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
}



- (IBAction)clickToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}

- (IBAction)ClickToDeleteMember:(id)sender {
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
       ContactObject * groupObject = [self.arrayGroupMembers objectAtIndex:btn.tag];
    _contactID=groupObject.contactId.stringValue;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure you want to delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 2001;
    [alert show];
    alert = nil;
    
    
}


- (IBAction)ClickToEditMember:(id)sender {
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    ContactObject * groupObject = [self.arrayGroupMembers objectAtIndex:btn.tag];
    self.contactID=groupObject.contactId.stringValue;
    BC_UpdateContactVC *contentScreen = [[BC_UpdateContactVC alloc]initWithNibName:@"BC_UpdateContactVC" bundle:nil];
    contentScreen.memContactId=self.contactID;
    
    [self.navigationController pushViewController:contentScreen animated:YES];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 2001)
    {
        if (buttonIndex==1)
        {
            [self startServiceDeleteMember];
            
        }
    }else if(alertView.tag == 2002)
    {
        if (buttonIndex==1)
        {
            [self startServiceDeleteGroup];
            
        }
    }
    else if (alertView.tag == 1010){
     if(buttonIndex == 1){
            [self startServiceDeleteUserGroupProfileImage];
        }
        
        //Do something
    
        //Do something else
    }
    if (alertView.tag == 1012)
    {
        if(buttonIndex == 1){
            NSLog(@"self.appUserObject.profileImage %@",self.appUserObject.profileImage);
            if ([self.appUserObject.profileImage isEqualToString:@""]) {
                [self.btnEdit setButtonTitle:@"Upload"];
                
                
                NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
                
                
                self.imgView.image=[UIImage imageNamed:nothingString];
                
                self.imgView.backgroundColor=[UIColor whiteColor];
                
                if(isProfileUpdate==YES){
                    isProfileUpdate=NO;
                    [self startServiceDeleteUserGroupProfileImage];
                }
                
            }else{
                             [self startServiceDeleteUserGroupProfileImage];
            }
        }
        //Do something
    }

}



- (IBAction)ClickToDeleteGroup:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure you want to delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 2002;
    [alert show];
    alert = nil;
    
    
}


- (IBAction)clickToAddMembers:(id)sender {
    
    BC_ChooseMemberVC * contactVc= [[BC_ChooseMemberVC alloc]initWithGroupDetail:self.selectedGroupData.groupObjectId];
    contactVc.arrayGroupMembers=self.arrayGroupMembers;
   
    [self.navigationController pushViewController:contactVc animated:YES];
}



//
//- (IBAction)clickToUploadImage:(id)sender {
//    
//    
//
//    
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

-(void)startServiceDeleteUserGroupProfileImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteUserGroupProfileImage) withObject:nil];
    
    
}

-(void)serviceToDeleteUserGroupProfileImage
{
    
    //removeUserProfilePic/{ type }/{ Id }
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/removeUserProfilePic/group/%@",SERVERURLPATH,self.selectedGroupData.groupObjectId]];
    [class addParam:@"ios" forKey:@"device_type"];
   // [class addParam:@"group" forKey:@"type"];
    [class setCallback:@selector(callBackServiceToDeleteUserGroupProfileImage:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteUserGroupProfileImage:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Image removed successfully."]) {
            [ECSAlert showAlert:@"Deleted!"];
             [self.btnEdit setButtonTitle:@"Upload"];
            NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
            
            
            self.imgView.image=[UIImage imageNamed:nothingString];
            
            self.imgView.backgroundColor=[UIColor whiteColor];
           // [self.navigationController popViewControllerAnimated:YES];
        }else{
             [self.btnEdit setButtonTitle:@"Upload"];
            NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
            
            
            self.imgView.image=[UIImage imageNamed:nothingString];
            
            self.imgView.backgroundColor=[UIColor whiteColor];
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
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    isimageChanged=YES;
      self.btnEdit.hidden=NO;
    self.imgView.image=image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    [self editProfileImagedirectioly];
}
-(IBAction)OnClickRenameGroup:(id)sender
{
     self.viewEditGroup.hidden=NO;
    self.viewEditGroup.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.txtEditGroupName.text=self.txtGroupName.text;
    [self.view addSubview:self.viewEditGroup];
}
-(IBAction)OnClickRename:(id)sender
{
      [self.txtEditGroupName resignFirstResponder];
         [self startServiceUpdateContact];
}
-(IBAction)OnClickRenameCancel:(id)sender
{
      [self.txtEditGroupName resignFirstResponder];
    self.viewEditGroup.hidden=YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField == self.txtEditGroupName) {
        [textField resignFirstResponder];
          }
    return YES;
}
@end
