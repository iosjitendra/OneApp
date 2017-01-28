//
//  CHE_EditImageVC.m
//  CountryHillElementary
//
//  Created by Daksha on 9/13/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CHE_EditImageVC.h"
//#import "BABViewController.h"
#import "BABCropperView.h"

@interface CHE_EditImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet BABCropperView *cropperView;
@property (weak, nonatomic) IBOutlet UIImageView *croppedImageView;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;

@end

@implementation CHE_EditImageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.cropperView.cropSize = CGSizeMake(320.0f, 320.0f);
  //  self.cropperView.cropSize = CGSizeMake(500.0f, 500.0f);for circle
    self.cropperView.image=self.selectedImage;
    self.cropperView.cropsImageToCircle = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(!self.cropperView.image) {
        
        [self showImagePicker];
    }
}

- (void)showImagePicker {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    [self.cropButton setTitle:@"Done" forState:UIControlStateNormal];
}

#pragma mark - Button Targets

- (IBAction)cropButtonPressed:(id)sender {
    
    if(self.cropperView.hidden) {
         self.croppedImageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.cropperView.hidden = NO;
        self.croppedImageView.hidden = YES;
        [self.cropButton setTitle:@"Done" forState:UIControlStateNormal];
       // [self showImagePicker];
    }
    else {
        self.croppedImageView.frame=CGRectMake(0, 200, self.view.frame.size.width, 250);
        __weak typeof(self)weakSelf = self;
        
        [self.cropperView renderCroppedImage:^(UIImage *croppedImage, CGRect cropRect){
            
            [weakSelf displayCroppedImage:croppedImage];
        }];
       
    }
   
}

- (void)displayCroppedImage:(UIImage *)croppedImage {
    
    self.cropperView.hidden = YES;
    self.croppedImageView.hidden = NO;
    self.croppedImageView.image = croppedImage;
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TestNotificationProfile"
     object:self.croppedImageView.image];
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self.cropButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
}

-(IBAction)onClickBack:(id)sender{
   
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.cropperView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
