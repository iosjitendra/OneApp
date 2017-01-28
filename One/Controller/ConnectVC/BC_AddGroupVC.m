//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//


#import "ECSHelper.h"
#import "BC_AddGroupVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SAMTextView.h"
#import "BC_ChooseMemberVC.h"
#import "JJMaterialTextField.h"
#import "ECSServiceClass.h"
#import "GroupObject.h"
//#import <iToast.h>
#import "CHE_EditImageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface BC_AddGroupVC ()<UITextFieldDelegate>{
    NSMutableArray *arrayGroups;
}
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgGroupProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnGroupImage;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtGroupName;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)clickToUploadImage:(id)sender;
- (IBAction)clickToNext:(id)sender;
@end


@implementation BC_AddGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self settingTopView:self.viewTop onController:self andTitle:@"Add new group"];
    self.imgGroupProfile.layer.cornerRadius = self.imgGroupProfile.frame.size.width / 2;
    self.imgGroupProfile.clipsToBounds = YES;
    UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtGroupName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Group Name" attributes:@{NSForegroundColorAttributeName: color}];
   
//    UIFont *font1 = [UIFont fontWithName:@"Karla-Regular" size:12];
//    self.txtGroupName.font=font1;
    self.txtGroupName.text=self.selectedGroupData.name;
    
    NSString *strimage = self.selectedGroupData.image;
    if(strimage){
    [self.imgGroupProfile ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    }
    [self textFieldInitialization];
  //  [self setTextFieldImages];
    [self setTextFieldsPadding];
    [self.btnEdit setButtonTitle:@"Upload"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotificationProfile"
                                               object:nil];

}

- (void) receiveTestNotification:(NSNotification *) notification
{
   
     [self.btnEdit setButtonTitle:@"edit"];
    if (notification.object) {
        self.imgGroupProfile.image=notification.object;
    }
   
}
-(void)setTextFieldImages{
    
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 19)];
    [userImage setImage:[UIImage imageNamed:@"drop-down-icon.png"]];
    
    
    
    
}


//-(IBAction)editProfileImage:(id)sender{
//    
//    
//    
//    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
//    contentScreen.selectedImage=self.imgGroupProfile.image;
//    [self.navigationController pushViewController:contentScreen animated:YES];
//    
//    
//}
-(void)textFieldInitialization
{
    self.txtGroupName.enableMaterialPlaceHolder = YES;
    self.txtGroupName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    self.txtGroupName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.txtGroupName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTextFieldsPadding
{
    [self.txtGroupName setRightPadding];
   
}

-(void)resignTextResponder
{
    
    [self.txtGroupName resignFirstResponder];
   
    
}

- (IBAction)clickToNext:(id)sender {
    
    [self resignTextResponder];
    
    if (self.txtGroupName.text.length==0)
    {
        //[ECSAlert showAlert:@"Please write the group name"];
//        [[[[iToast makeText:@"Please enter the group name"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

    }

    else
    {
        [self startServiceToCreateGroups];

        
    }
    
}
- (IBAction)clickToUploadImage:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
    
    [actionSheet showInView:self.view];
    
    
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.imgGroupProfile.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *cameraImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
   // UIImage *newImage = [self imageWithImage:cameraImage scaledToSize:CGSizeMake(100, 100)];
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.jpg"];
    NSLog(@"savedImagePath %@",savedImagePath);
    
    
    NSData *_data = UIImageJPEGRepresentation(cameraImage,0.8);
    
    
    [_data writeToFile:savedImagePath atomically:YES];
    
    
    
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    self.imgGroupProfile.image=image;
    if (self.imgGroupProfile.image) {
         self.btnEdit.hidden=NO;
    }
   
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    [self editProfileImagedirectioly];
}

-(void)startServiceToCreateGroups
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToCreateGroups) withObject:nil];
    
    
}

-(void)serviceToCreateGroups
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:IMAGE];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/createGroup",SERVERURLPATH]];
    //[class addImageData:UIImageJPEGRepresentation(self.imgGroupProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
    if (  [self.btnEdit.titleLabel.text isEqualToString:@"Upload"]) {
        NSLog(@"");
//         [class addImageData:UIImageJPEGRepresentation(self.imgGroupProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
           }else{
        [class addImageData:UIImageJPEGRepresentation(self.imgGroupProfile.image, 0.5) withName:@"profilepic.png"  forKey:@"image"];
    }
    [class addParam:self.txtGroupName.text forKey:@"name"];
    [class setCallback:@selector(callBackServiceToGetCreateGroups:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetCreateGroups:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        [ECSAlert showAlert:@"Group has been created successfully"];
        NSNumber *groupId=[rootDictionary objectForKey:@"Group"];
        BC_ChooseMemberVC * contactVc= [[BC_ChooseMemberVC alloc]initWithGroupDetail:groupId];
        [self.navigationController pushViewController:contactVc animated:YES];
        if(arrayGroups == nil)
            arrayGroups = [[NSMutableArray alloc]init];
        else [arrayGroups removeAllObjects];
        
        NSArray * notification=[rootDictionary objectForKey:@"Groups"];
        for (NSDictionary * dictionary in notification)
        {
            GroupObject  *object=[GroupObject instanceFromDictionary:dictionary];
            [arrayGroups addObject:object];
        }
       
        
    }
    else {
        
       // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

    }
    
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
    contentScreen.selectedImage=self.imgGroupProfile.image;
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
                                                                                  self.imgGroupProfile.image=img;
                                                                                  //self.isImageUploadRequired = YES;
                                                                                  CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
                                                                                  contentScreen.selectedImage=self.imgGroupProfile.image;
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
            contentScreen.selectedImage=self.imgGroupProfile.image;
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

@end
