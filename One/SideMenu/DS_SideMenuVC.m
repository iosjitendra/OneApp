//
//  DS_SideMenuVC.m
//  DSale_Sale
//
//  Created by Daksha_Mac4 on 1/3/16.
//  Copyright © 2016 Daksha_Mac4. All rights reserved.
//

#import "DS_SideMenuVC.h"
#import "DS_SidemenuCell.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "AppDelegate.h"
//#import "STCollapseTableView.h"
#import "ECSServiceClass.h"
//#import "DealJSON.h"
//#import "Deal.h"
//#import "DS_HomeScreen.h"
#import "MBProgressHUD.h"
//#import "Categories.h"
#import "UIExtensions.h"
//
#import "BC_ContactCell.h"
//#import "CategoryHeader.h"
#import "MVYSideMenuController.h"
//#import "DS_ProductScreen.h"
#import "BC_ProfileVC.h"
#import "ECSAppHelper.h"
#import "CH_HomeVC.h"
#import "CH_LoginVC.h"
#import "BC_WebPageVC.h"
#import "DS_LaunchScreen.h"
#import "ALRegisterUserClientService.h"
#import "AppData.h"
#import "MenuLink.h"
@interface DS_SideMenuVC ()<UITableViewDelegate,UITableViewDataSource>

{
    BOOL ischecked;
    NSMutableArray *nameArrayList;
    NSString *selectedcell;
}
@property (weak, nonatomic) IBOutlet UICollectionView *Contacts_CollectionView;

@property (strong, nonatomic) NSMutableArray *slidemenuArray;
@property (nonatomic, strong) NSMutableArray* dataArray1;
@property (nonatomic, strong) NSMutableArray* headers;
@property (nonatomic, retain) CH_HomeVC * homeScreen;
@property(strong,nonatomic)IBOutlet UIView *viewHighlighted;
@property(strong,nonatomic)IBOutlet UIView *viewReplace;
@property(strong,nonatomic)IBOutlet UIView *viewFooter;
@property(strong,nonatomic)IBOutlet UIView *viewHeader;
@property(strong,nonatomic)IBOutlet UILabel *lblHighlighted;
@property(strong,nonatomic)IBOutlet UILabel *lblGotit;
@property(strong,nonatomic)IBOutlet UIButton *btnGotit;;

//@property(strong,nonatomic)IBOutlet UIScrollView *tutScroll;
@property(strong,nonatomic)IBOutlet UILabel *lblHeader;
@property(strong,nonatomic)IBOutlet UILabel *lblAlert;
- (IBAction)clickToCrsoss:(id)sender;
@property NSInteger selectedHeaderIndex;

@end

@implementation DS_SideMenuVC



- (void)viewDidLoad {
    // [self.sideMenuTable tableViewScrollToBottomAnimated:NO];
    [self.Contacts_CollectionView  registerNib:[UINib nibWithNibName:@"BC_ContactCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
     [self.Contacts_CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    self.sideMenuTable.delegate=self;
    self.sideMenuTable.dataSource=self;
    [super viewDidLoad];
    

    
    self.lblHighlighted.lineBreakMode = UILineBreakModeWordWrap;
    self.lblHighlighted.numberOfLines = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight<=568) {
        
      
    }
        NSString *menuMsg=@"With one tap easily access important information!";
    
    self.viewHighlighted.frame=CGRectMake(0, self.view.frame.size.height/2 +80, 290, self.view.frame.size.height/2);
    // [self.viewHighlighted addSubview:self.tutScroll];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"DontShowForSideMenu"];
    if ([myString isEqualToString:@"DontShowAgain"]) {
        NSLog(@"dont show the tutorial");
        //[self.view addSubview:self.viewHighlighted];
    }else{
        
        [self.view addSubview:self.viewHighlighted];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [self.viewHighlighted addGestureRecognizer:tapRecognizer];
    
    self.lblHighlighted.text=menuMsg;
    [self.viewHighlighted addSubview:self.lblHighlighted];
   
    [self.lblHeader setFontKalra:22];
    
    
    [self.navigationController setNavigationBarHidden:YES];
      NSLog(@"token %@",self.appUserObject.apiToken);
    if (self.appUserObject.apiToken) {
        [self startServiceToGetAppInfo];
    }
    
    
   
   
}

//-(void)viewWillAppear:(BOOL)animated{
//    self.view.frame=CGRectMake(0, 0, 290, self.view.frame.size.height);
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView   viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        [headerView addSubview:_viewFooter];
        reusableview = headerView;
    }
    return reusableview;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return nameArrayList.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BC_ContactCell *cell =
    (BC_ContactCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                forIndexPath:indexPath];
//    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicatorView.color=[UIColor darkGrayColor];
//    activityIndicatorView.frame=CGRectMake( cell.img_view.frame.size.width/2,  cell.img_view.frame.size.height/2, 0, 0);
//    cell.img_view.layer.cornerRadius = cell.img_view.frame.size.width / 2;
//    cell.img_view.clipsToBounds = YES;
    
    
    MenuLink * connectionObject = [nameArrayList objectAtIndex:indexPath.row];
    NSString *strimage = connectionObject.image;
    
    
    if ([strimage isEqualToString:@""]) {
        cell.img_view.image = [UIImage imageNamed:@"blank_placeholder.png"];
        
    }else{
        
        [cell.img_view ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }
    

    cell.lblName.text=connectionObject.label;
    [cell.lblName setFontKalra:13];
    [cell.lblCity setHidden:YES];
    
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * contentScreen = nil;
    
    MenuLink * object = [nameArrayList objectAtIndex:indexPath.item];
    
    NSString *url =[NSString stringWithFormat:@"%@",object.url];
    contentScreen = [[BC_WebPageVC alloc]initWithURL:url andTitle:object.label];
    
    if(contentScreen){
        [self.sideMenuController.navigationController pushViewController:contentScreen animated:NO];
        
    }

    
    
}



-(void)startServiceToGetAppInfo
{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(serviceToAppInfo) withObject:nil];
    
    
}



-(void)serviceToAppInfo
{
    

    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    //[class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];//username
    NSLog(@"token %@",self.appUserObject.apiToken);
    [class addParam:self.appUserObject.first forKey:@"username"];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/getUsersAppInfo",SERVERURLPATH]];
    
    [class setCallback:@selector(callBackServiceToGetAllContact:)];
    [class setController:self];
    [class runService];
}




-(void)callBackServiceToGetAllContact:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    
    if(response.isValid)
    {
        
        nameArrayList=[[NSMutableArray alloc]init];
        
        NSArray * notification=[[rootDictionary objectForKey:@"appData"]objectForKey:@"menuLinks"];
       self.lblHeader.text=[[rootDictionary objectForKey:@"appData"]objectForKey:@"appName"];
        if ([rootDictionary objectForKey:@"message"]) {
            self.lblAlert.text=[rootDictionary objectForKey:@"message"];
        }
        for (NSDictionary * dictionary in notification)
        {
            MenuLink  *object=[MenuLink instanceFromDictionary:dictionary];
            
              [nameArrayList addObject:object];
                   }
        
      
        
       
    }
    if (nameArrayList.count) {
        
        self.lblAlert.hidden=YES;
    }
    
    [self.Contacts_CollectionView reloadData];
  
}




-(IBAction)clickGotIt:(id)sender{
    self.viewHighlighted.hidden=YES;
    
    
}

-(void)viewTransitionRight :(UIView *)baseView to:(UIView *) newView{
    [UIView transitionFromView:baseView
                        toView:newView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished){
                        // [self.viewReplace removeFromSuperview];
                    }];
    
}
-(void)viewTransitionLeft :(UIView *)baseView to:(UIView *) newView{
    [UIView transitionFromView:baseView
                        toView:newView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished){
                        //[self.viewReplace removeFromSuperview];
                    }];
    
}

-(IBAction)checkMark:(id)sender
{
    
    UIButton *check = (UIButton*)sender;
    if(ischecked == NO){
        ischecked=YES;
        [check setImage:[UIImage imageNamed:@"dontshowagainchecked.png"] forState:UIControlStateNormal];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"DontShowAgain" forKey:@"DontShowForSideMenu"];
        
    }
    else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"ShowAgain" forKey:@"DontShowForSideMenu"];
        ischecked=NO;
        [check setImage:[UIImage imageNamed:@"dontshowagain.png"] forState:UIControlStateNormal];
    }
}


- (void)scrollToBottom
{
    [self.sideMenuTable setContentOffset:CGPointMake(0, 430)];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"screenSize %f",screenSize.height);
    if (screenSize.height >= 736){
        [self.sideMenuTable setContentOffset:CGPointMake(0, 360)];
    }
    
    if (screenSize.height == 568){
        [self.sideMenuTable setContentOffset:CGPointMake(0, 520)];
    }
}
- (void)scrollToBottom1
{ if(self.appUserObject==nil){
    [self.sideMenuTable setContentOffset:CGPointMake(0, 0)];
}else{
    [self.sideMenuTable setContentOffset:CGPointMake(0, 0)];
}
}
-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    self.viewHighlighted.hidden=YES;
    // self.viewHighletedSecond.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    //self.view.frame=CGRectMake(0, 0, 290, self.view.frame.size.height);
}
-(void)viewWillAppear:(BOOL)animated {
    
    self.view.frame=CGRectMake(0, 0, 290, self.view.frame.size.height);
    self.appUserObject = [AppUserObject getFromUserDefault];
    if (!nameArrayList.count) {
        
        if (self.appUserObject.apiToken) {
            [self startServiceToGetAppInfo];
        }
    }
   
    //  [self.slideViewTable setContentOffset:CGPointMake(0,0) animated:YES];
 
    
    NSLog(@"CAll API view will appear");
}










- (IBAction)clickToCrsoss:(id)sender {
    
    
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    if (sideMenuController) {
        [sideMenuController closeMenu];
    }
}

-(IBAction)onClickProfile:(id)sender{
      UIViewController * contentScreen = nil;
    [self.sideMenuController closeMenu];
    
    
    contentScreen =[[BC_ProfileVC alloc]initWithNibName:@"BC_ProfileVC" bundle:nil];
    [self.sideMenuController.navigationController pushViewController:contentScreen animated:NO];
}
-(IBAction)onClickLogout:(id)sender{
    UIViewController * contentScreen = nil;
    [self.sideMenuController closeMenu];
    [AppUserObject removeFromUserDefault];
    
    ALRegisterUserClientService * alUserClientService = [[ALRegisterUserClientService alloc]init];
    [alUserClientService logoutWithCompletionHandler:^{
        
        
        
    }];
    //DS_LaunchScreen
    //contentScreen = (CH_LoginVC *) [[CH_LoginVC alloc]initWithNibName:@"CH_LoginVC" bundle:nil];
  contentScreen = (DS_LaunchScreen *) [[DS_LaunchScreen alloc]initWithNibName:@"DS_LaunchScreen" bundle:nil];
    if(contentScreen){
        [self.sideMenuController.navigationController pushViewController:contentScreen animated:NO];
        
    }

}

@end

