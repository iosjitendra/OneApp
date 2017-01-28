//
//  CH_ChatScreen.m
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 27/07/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#define TAG_FOR_GROUP_MEMBER_INVITATION   122222

#import "CH_ChatScreen.h"
#import "BC_ContactCell.h"
#import "UIExtensions.h"
#import "UIAppExtensions.h"
#import "ECSConfig.h"

#import "AppUserObject.h"
#import "CH_DemoVC.h"
#import "ECSMessage.h"
#import "ECSServiceClass.h"
#import "MBProgressHUD.h"
#import "ContactObject.h"
#import "CHE_ContactTableCell.h"
#import "BC_AddContactVC.h"
#import "BC_AddGroupVC.h"
#import "SaveContactObject.h"
#import "GroupObject.h"
#import "BC_UpdateContactVC.h"
#import "BC_GroupDetailVC.h"
#import "ECSHelper.h"
#import "ALChatManager.h"
#import "ECSAppHelper.h"
#import <Applozic/ALDataNetworkConnection.h>
#import <Applozic/ALDBHandler.h>
#import <Applozic/ALContact.h>
#import "ALChannel.h"
#import "Applozic/ALChannelService.h"
#import "ALNewContactsViewController.h"
#import "ALMessagesViewController.h"
#import "IQAudioRecorderViewController.h"
//#import "DVGFeatureListTableViewController.h"
#import "DVGCameraViewController.h"
#import "ALUserService.h"
#import "DS_ContactCell.h"
//#import <lame/lame.h>


@interface CH_ChatScreen ()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate,IQAudioRecorderViewControllerDelegate>
{
    IBOutlet UIBarButtonItem *buttonPlayAudio;
    NSString *audioFilePath;
    NSString *toPathString ;
    
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tableView;
    NSMutableArray *arrayContacts;
    NSMutableArray *imageArray;
    NSMutableArray *searchArray;
    NSMutableArray *arrayForSaveContactList;
    NSMutableArray *arrayGroups;
    NSString *selectedIndGroups;
    NSMutableArray *arrayFavourites;
    NSMutableArray *arrayGroupMembers;
     NSMutableArray *arrayGroupMembersObject;
    NSMutableArray * arrayALuserGrpMember;
   NSMutableArray *arrEmai;
    BOOL ischecked;
}


@property (weak, nonatomic) IBOutlet UILabel *lblVideoBroadcast;
@property (weak, nonatomic) IBOutlet UILabel *lblVoiceBroadCast;

- (IBAction)clickOnHelpBtn:(id)sender;
@property (strong,nonatomic)ALChannelService * creatingChannel;
@property (weak, nonatomic) IBOutlet UIView *viewHelp;
@property (weak, nonatomic) IBOutlet UICollectionView *Contacts_CollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_iconButtons;
@property (strong, nonatomic) IBOutlet UIView *viewNotifyPopUp;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *viewConnectSegment;
@property (weak, nonatomic) IBOutlet UIView *conferenceView;
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIView *viewIndividulSegment;
@property(weak,nonatomic)IBOutlet UIButton *btnIndv;
@property(weak,nonatomic)IBOutlet UIButton *btnGroup;
@property(weak,nonatomic)IBOutlet UIButton *btnContactGroup;
@property(weak,nonatomic)IBOutlet UIButton *btnHelp;

@property (strong, nonatomic) IBOutlet UIView *viewChatTutorial;
@property (strong, nonatomic) IBOutlet UIView *viewChatTutorialForGp;

@property (nonatomic, strong) ContactObject *ContactsData;
@property (nonatomic, retain) GroupObject * groupObject;
@property (nonatomic, retain) SaveContactObject * saveContObject;
@property (nonatomic, strong) IQAudioRecorderViewController *iQAudioRecorderViewController;
@property(weak,nonatomic) IBOutlet UILabel *lblContactTitle;
@property(weak,nonatomic) IBOutlet UILabel *lblContactalerttitle;
@property(weak,nonatomic) IBOutlet UILabel *lblContactAddTitle;
- (IBAction)mLaunchChatList:(id)sender;
- (IBAction)mChatLaunchButton:(id)sender;


@end

@implementation CH_ChatScreen

- (void)viewDidLoad {
    
    
      [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [super viewDidLoad];
    self.lblContactAddTitle.hidden=YES;
    self.lblContactalerttitle.hidden=YES;
     [self.Contacts_CollectionView  registerNib:[UINib nibWithNibName:@"DS_ContactCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view from its nib.
    imageArray=[[NSMutableArray alloc]init];
    [imageArray addObject:@"website-icon.png"];
    [imageArray addObject:@"faculty-contacts.png"];
    [imageArray addObject:@"comments.png"];
    [imageArray addObject:@"aftercare.png"];
    [imageArray addObject:@"cafeteria-info.png"];
       arrEmai=[[NSMutableArray alloc]init];
   // tableView.frame=CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height);
    _activityView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.center=self.view.center;
    [self.view addSubview: _activityView];
    searchBar.hidden=YES;
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor colorWithRed:255/255.0 green:246/255.0 blue:246/255.0 alpha:1]];

    [self startServiceToGetAllConatct];
    [self allowsHeaderViewsToFloat];
    tableView.separatorColor = [UIColor clearColor];
    searchArray=[[NSMutableArray alloc]init];
    arrayForSaveContactList=[[NSMutableArray alloc]init];
    selectedIndGroups=@"indv";
   
     [self.btnIndv setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    tableView.tableHeaderView=_headerView;

}

-(IBAction)checkboxButton:(id)sender
{
    
    UIButton *check = (UIButton*)sender;
    if(ischecked == NO){
        ischecked=YES;//dontshowagainchecked
        [check setImage:[UIImage imageNamed:@"dontshowagainchecked.png"] forState:UIControlStateNormal];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"DontShowAgain" forKey:@"DontShow"];
        
    }
    else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"ShowAgain" forKey:@"DontShow"];
        ischecked=NO;
        [check setImage:[UIImage imageNamed:@"dontshowagain.png"] forState:UIControlStateNormal];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self.scroll_iconButtons setContentSize:CGSizeMake(self.scroll_iconButtons.frame.size.width, 750)];
    

    [_Contacts_CollectionView reloadData];
}


-(void)viewWillAppear:(BOOL)animated{
    if ([selectedIndGroups isEqualToString:@"indv"]) {
          [self serviceToAllContact];
    }else{
         [self startServiceToAllGroups];
    }
    
}


-(IBAction)onclickContact:(id)sender{
    self.viewConnectSegment.frame=CGRectMake(15, 61, 125, 4);
}

-(IBAction)onclickChat:(id)sender{
    
    self.viewChatTutorial.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"DontShow"];
    if ([myString isEqualToString:@"DontShowAgain"]) {
        NSLog(@"dont show the tutorial");
        _activityView.center=self.view.center;
        [_activityView startAnimating];
        [self.view addSubview:_activityView];
        
        self.viewConnectSegment.frame=CGRectMake(self.view.frame.size.width-100, 61, 91, 4);
        ALUser *user = [[ALUser alloc] init];
        [user setUserId:[ALUserDefaultsHandler getUserId]];
        [user setEmail:[ALUserDefaultsHandler getEmailId]];
        [user setPassword:@""];
        [user setDisplayName:[NSString stringWithFormat:@"%@ %@",self.appUserObject.first,self.appUserObject.lastName]];
        // [ALUserDefaultsHandler setDisplayName:user.displayName];
        [user setImageLink:self.appUserObject.profileImage];
        ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:APPLOZIC_KEY];
        [chatManager registerUserAndLaunchChat:user andFromController:self forUser:nil withGroupId:nil];
        
        // [self.view addSubview:self.viewHighleted];
    }else{
        
        self.viewChatTutorial.hidden=NO;
        [self.view addSubview:self.viewChatTutorial];
    }

    
   
    
}
-(IBAction)onclickIndividual:(id)sender{
    
    self.viewIndividulSegment.frame=CGRectMake(14, 52, 123, 4);
    [self.btnIndv setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnGroup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    selectedIndGroups=@"indv";
    [tableView reloadData];
    [self startServiceToGetAllConatct];
}

-(IBAction)onclickGroup:(id)sender{
     self.viewIndividulSegment.frame=CGRectMake(self.view.frame.size.width-100, 52, 91, 4);
    [self.btnGroup setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnIndv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectedIndGroups=@"group";
    [self startServiceToAllGroups];
    self.lblContactAddTitle.text=@"No group added";
    [tableView reloadData];
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
        
        
        if(arrayGroups == nil)
            arrayGroups = [[NSMutableArray alloc]init];
        else [arrayGroups removeAllObjects];
        
        NSArray * groupArray=[rootDictionary objectForKey:@"Groups"];
        for (NSDictionary * dictionary in groupArray)
        {
            GroupObject  *object=[GroupObject instanceFromDictionary:dictionary];
            [arrayGroups addObject:object];
        }
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"You are not created any group."]) {
            self.lblContactAddTitle.text=@"No group added";
            self.lblContactAddTitle.hidden=NO;
        }else{
              self.lblContactAddTitle.hidden=YES;
        }
                [tableView reloadData];
        
    }
    else {
        
        // [ECSAlert showAlert:@"there is no group"];
    }
    
}


-(void)startServiceToGetAllConatct
{
    
    
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      [self performSelectorInBackground:@selector(serviceToAllContact) withObject:nil];


}



-(void)serviceToAllContact
{
    //          @"http://www.buckworm.com/laravel/index.php/api/"
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    NSLog(@"token %@",self.appUserObject.apiToken);
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/allContacts",SERVERURLPATH]];
    
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
        
        arrayContacts=[[NSMutableArray alloc]init];
        //        if(self.arrayConnection == nil)
                    arrayFavourites = [[NSMutableArray alloc]init];
        //        else [self.arrayConnection removeAllObjects];
        //
        NSArray * notification=[rootDictionary objectForKey:@"contacts"];
        for (NSDictionary * dictionary in notification)
        {
            ContactObject  *object=[ContactObject instanceFromDictionary:dictionary];
           
            [arrayContacts addObject:object];
            if ( [object.isFav isEqualToString:@"1"]) {
                [arrayFavourites addObject:object];
            }
        }
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"No contacts found."]) {
            self.lblContactalerttitle.hidden=NO;
            self.lblContactalerttitle.text=@"Your favorite contacts will show here!";
            self.lblContactAddTitle.hidden=NO;
            self.lblContactAddTitle.text=@"No contacts added";
        }else{
           // self.lblContactalerttitle.hidden=YES;
              self.lblContactAddTitle.hidden=YES;
        }
        
        
      

        
        
    }
    else {
        
        
    }
    
    [tableView reloadData];
   
    
}






-(void)viewWillDisappear:(BOOL)animated {
    self.viewConnectSegment.frame=CGRectMake(15, 61, 125, 4);
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  
  
    
    NSLog(@"searchText %@",searchText);
   
    
   
}





-(void)serviceToSearchContact :(NSString *)searchText
{
    //          @"http://www.buckworm.com/laravel/index.php/api/"
    // http://www.buckworm.com/laravel/index.php/api/v1/searchAllContacts/{search text}
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    NSLog(@"token %@",self.appUserObject.apiToken);
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/searchAllContacts/%@",SERVERURLPATH,searchText]];
    
    [class setCallback:@selector(callBackServiceToGetSearchContact:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetSearchContact:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        arrayContacts=[[NSMutableArray alloc]init];
        //        if(self.arrayConnection == nil)
        //            self.arrayConnection = [[NSMutableArray alloc]init];
        //        else [self.arrayConnection removeAllObjects];
        //
        NSArray * notification=[rootDictionary objectForKey:@"contacts"];
        for (NSDictionary * dictionary in notification)
        {
            ContactObject  *object=[ContactObject instanceFromDictionary:dictionary];
            [arrayContacts addObject:object];
        }
        arrayForSaveContactList=arrayContacts;
        
        
       
        
    }
    else {
        
        
    }
   
    [tableView reloadData];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (arrayFavourites.count>0) {
        self.lblContactalerttitle.hidden=YES;
    }else{
        self.lblContactalerttitle.hidden=NO;
    }
    return arrayFavourites.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 15.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DS_ContactCell *cell =
    (DS_ContactCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                forIndexPath:indexPath];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.color=[UIColor darkGrayColor];
    activityIndicatorView.frame=CGRectMake( cell.img_view.frame.size.width/2,  cell.img_view.frame.size.height/2, 0, 0);
    cell.img_view.layer.cornerRadius = cell.img_view.frame.size.width / 2;
    cell.img_view.clipsToBounds = YES;
    
   
    ContactObject * connectionObject = [arrayFavourites objectAtIndex:indexPath.row];
    NSString *strimage = connectionObject.image;
 
    
    if ([strimage isEqualToString:@""]) {
     cell.img_view.image = [UIImage imageNamed:@"blank_placeholder.png"];
    
    }else{
        
        [cell.img_view ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
       
    }
    
    
    cell.img_view.layer.cornerRadius = cell.img_view.frame.size.height/2;
    cell.img_view.clipsToBounds = YES;
    
    // border
    [cell.img_view.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cell.img_view.layer setBorderWidth:2.0f];
    
    // drop shadow
    [cell.img_view.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.img_view.layer setShadowOpacity:0.8];
    [cell.img_view.layer setShadowRadius:3.0];
    [cell.img_view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    
     cell.lblName.text=connectionObject.firstName;
    [cell.lblName setFontKalra:13];
        [cell.lblCity setHidden:YES];

   

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

     self.viewNotifyPopUp.hidden=NO;
        self.ContactsData = [arrayFavourites objectAtIndex:indexPath.item];
        self.lblContactTitle.text= [NSString stringWithFormat:@"Notify %@ %@",self.ContactsData.firstName,self.ContactsData.lastName];
      [self.btnContactGroup setButtonTitle:@"Edit Contact"];
    
    NSString *message =  self.lblContactTitle.text;
    self.conferenceView.hidden=YES;
    self.callView.hidden=NO;
    self.btnHelp.hidden=NO;

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange  subStringRange = [message rangeOfString:@"Notify"];
  

    UIFont *font = [UIFont fontWithName:@"Karla-Regular" size:16];
    [string addAttribute:NSFontAttributeName value:font range:subStringRange];

    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:subStringRange];
    
    [self.lblContactTitle setAttributedText:string];
    
        self.viewNotifyPopUp.hidden = NO;
        self.viewNotifyPopUp.autoresizesSubviews = YES;
        [self.viewNotifyPopUp setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        CATransition *transition=[CATransition animation];
        transition.duration=0.5f;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        
        transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
        [self.viewNotifyPopUp.layer addAnimation:transition forKey:nil];
        [self.view addSubview:self.viewNotifyPopUp];
    
    if(self.screenWidth == 640 || self.screenWidth == 320)
    {
        [self.lblVoiceBroadCast setText:@"Voice\nBroadcast"];
        [self.lblVideoBroadcast setText:@"Video\nBroadcast"];
        [self.lblVideoBroadcast setFrame:CGRectMake(0, 70, self.lblVideoBroadcast.frame.size.width, 55)];
        [self.lblVoiceBroadCast setFrame:CGRectMake(0, 70, self.lblVideoBroadcast.frame.size.width, 55)];
        
        
    }
    
    
    // Here we are adding a condition for iPhone 5
    
    if(self.screenWidth == 640 || self.screenWidth == 320)
    {
        [self.lblVoiceBroadCast setText:@"Voice\nBroadcast"];
        [self.lblVideoBroadcast setText:@"Video\nBroadcast"];
        [self.lblVideoBroadcast setFrame:CGRectMake(0, 70, self.lblVideoBroadcast.frame.size.width, 55)];
        [self.lblVoiceBroadCast setFrame:CGRectMake(0, 70, self.lblVideoBroadcast.frame.size.width, 55)];
        
        
    }
        
    
    
    
    
    
}



-(IBAction)onClickEditContact:(id)sender{
    
    BC_AddContactVC *vc=[[BC_AddContactVC alloc]initWithNibName:@"BC_AddContactVC" bundle:nil];
    vc.selectedContactsData=self.ContactsData;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([selectedIndGroups isEqualToString:@"indv"]){
         return arrayContacts.count;
    }else{
        return arrayGroups.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";//This is the identifier in storyboard
    CHE_ContactTableCell *cell = (CHE_ContactTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        UINib *nib = [UINib nibWithNibName:@"CHE_ContactTableCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
  
  
    if ([selectedIndGroups isEqualToString:@"indv"]) {
         ContactObject * connectionObject = [arrayContacts objectAtIndex:indexPath.row];

          NSString *strimage = connectionObject.image;
        if ([strimage isEqualToString:@""]) {
      
            NSString *nothingString = [NSString  stringWithFormat:@"blank_placeholder.png"];
            
            
            cell.userImg.image=[UIImage imageNamed:nothingString];
            
       
        }else{
            [cell.userImg ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
        
        cell.nameLabel.text=[NSString stringWithFormat:@"%@ %@",connectionObject.firstName,connectionObject.lastName];

    }else{
          GroupObject * connectionObject = [arrayGroups objectAtIndex:indexPath.row];

          cell.nameLabel.text=connectionObject.name;
         NSString *strimage = connectionObject.image;
        if ([strimage isEqualToString:@""]){
           
       [ cell.userImg setImage:[UIImage imageNamed:@"Groupplaceholder.png"]];
        }else{
            [cell.userImg ecs_setImageWithURL:[NSURL URLWithString:[strimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
    }
    
    [cell.nameLabel setFontKalra:13];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    lbl.backgroundColor=[UIColor colorWithRed:255/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
  
    
    if ([selectedIndGroups isEqualToString:@"indv"]) {
         self.viewNotifyPopUp.hidden=NO;
        self.ContactsData = [arrayContacts objectAtIndex:indexPath.item];
        
        self.conferenceView.hidden=YES;
        self.callView.hidden=NO;
        self.btnHelp.hidden=NO;
        
        self.lblContactTitle.text= [NSString stringWithFormat:@"Notify %@ %@",self.ContactsData.firstName,self.ContactsData.lastName];
        NSString *message =  self.lblContactTitle.text;
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange  subStringRange = [message rangeOfString:@"Notify"];
        
        
        UIFont *font = [UIFont fontWithName:@"Karla-Regular" size:16];
        [string addAttribute:NSFontAttributeName value:font range:subStringRange];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:subStringRange];
        
        [self.lblContactTitle setAttributedText:string];
        
        self.viewNotifyPopUp.hidden = NO;
        self.viewNotifyPopUp.autoresizesSubviews = YES;
        [self.viewNotifyPopUp setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        CATransition *transition=[CATransition animation];
        transition.duration=0.5f;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        
        transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [self.btnContactGroup setButtonTitle:@"Edit Contact"];
        
        [self.viewNotifyPopUp.layer addAnimation:transition forKey:nil];
        [self.view addSubview:self.viewNotifyPopUp];
        
        if(self.screenWidth == 640 || self.screenWidth == 320)
        {
            [self.lblVoiceBroadCast setText:@"Voice\nBroadcast"];
            [self.lblVideoBroadcast setText:@"Video\nBroadcast"];
            [self.lblVideoBroadcast setFrame:CGRectMake(0, 70, self.lblVideoBroadcast.frame.size.width, 55)];
            [self.lblVoiceBroadCast setFrame:CGRectMake(0, 70, self.lblVideoBroadcast.frame.size.width, 55)];
            
            
        }
        
    }else{
         
         self.conferenceView.hidden=NO;
         self.callView.hidden=YES;
         self.groupObject = [arrayGroups objectAtIndex:indexPath.item];
         [self startServiceToGroupDetail];
        
         
         
     }
}
- (BOOL)allowsHeaderViewsToFloat{
    return NO;
}



- (void)showGroupOptionView:(GroupObject *)object
{
    
    self.conferenceView.hidden=NO;
    self.callView.hidden=YES;
    self.lblContactTitle.text= [NSString stringWithFormat:@"Notify %@ ",object.name];
    NSString *message =  self.lblContactTitle.text;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange  subStringRange = [message rangeOfString:@"Notify"];
    
   
    
    UIFont *font = [UIFont fontWithName:@"Karla-Regular" size:16];
    [string addAttribute:NSFontAttributeName value:font range:subStringRange];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:subStringRange];
    //[string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:subStringRange];
    [self.lblContactTitle setAttributedText:string];
    
    self.viewNotifyPopUp.hidden = NO;
    self.viewNotifyPopUp.autoresizesSubviews = YES;
    [self.viewNotifyPopUp setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    CATransition *transition=[CATransition animation];
    transition.duration=0.5f;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type=kCATransitionFade;
    [self.btnContactGroup setButtonTitle:@"Edit Group"];
    [self.viewNotifyPopUp.layer addAnimation:transition forKey:nil];
    [self.view addSubview:self.viewNotifyPopUp];



}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
   
    
    return 98;
}
#pragma mark - Search Bar delegate



- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;
{
    NSLog(@"arrayForSaveContactList %@",arrayForSaveContactList);
    searchBar.text = @"";
    arrayContacts=nil;
    arrayContacts=arrayForSaveContactList;
    [tableView reloadData];
    
}




-(IBAction)onCancel:(id)sender{
      self.viewNotifyPopUp.hidden = YES;
    
}

-(IBAction)onClickChatBtn:(id)sender{
  
    _activityView.center=self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];
    
    self.viewNotifyPopUp.hidden = YES;
     NSLog(@"self.ContactsData.appLogicId %@",self.ContactsData.appLogicId);
    if ([selectedIndGroups isEqualToString:@"indv"])
    {
        
        // Here we need to check if user is already resgiter with aplogic or not
        
        if (self.ContactsData.appLogicId.length > 0)
        {
            // It means user is register wih applogic, we just need to launch the chat
            NSLog(@"self.ContactsData.appLogicId %@",self.ContactsData.appLogicId);
            ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:APPLOZIC_KEY];
            [chatManager launchChatForUserWithDisplayName:self.ContactsData.appLogicId withGroupId:nil andwithDisplayName:self.ContactsData.firstName andFromViewController:self];
            
            
        }
        else
        {
            // It means user is not register with the applogic as we should invite them
            
            NSString *nss=[NSString stringWithFormat:@"%@ is not on the %@ %@",self.ContactsData.firstName,[ECSAppHelper getAppName],@"app yet. Invite them to download the app to chat with them! "];
            [_activityView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:nss delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite", nil];
            alert.tag = 2001;
            [alert show];
            alert = nil;
            
            
        }
    }
    else{
    
        
        // arrEmai=[[NSMutableArray alloc]init];
        
        if(arrayGroupMembers.count < 2)
        {
            [_activityView removeFromSuperview];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Group Members"
                                                  message:@"Please select minimum two members"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
            
        }
        
        
        
        if (arrayGroupMembers.count) {
            
            NSMutableArray * nonChatContcats = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < arrayGroupMembersObject.count; i++)
            {
                ContactObject * object = arrayGroupMembersObject[i];
                if(object.appLogicId.length == 0)
                [nonChatContcats addObject:object];
                
            }
            
            
            
            if(nonChatContcats.count)
            {
                
                 [_activityView removeFromSuperview];
                // It means we need to show the alert message
                
                NSString * alertTitle = @"Hang on!";
                NSString * message = @"";
                NSString * invitationButtonTitle = @"";
                
                if(nonChatContcats.count == 1)
                {
                    ContactObject * object = nonChatContcats[0];
                    message = [NSString stringWithFormat:@"%@ needs",object.firstName];
                    invitationButtonTitle = @"Send an invitaion";
                    
                }
                else if(nonChatContcats.count > 1 && nonChatContcats.count < 5)
                {
                    
                    
                    for (int j = 0 ; j < nonChatContcats.count; j++)
                    {
                        ContactObject * object = nonChatContcats[j];
                        if(j == nonChatContcats.count-1)
                        {
                            message = [message substringToIndex:message.length - 2]; // removng last ,
                            message = [message stringByAppendingString:[NSString stringWithFormat:@" and %@ need",object.firstName]];
                        }
                        else  message = [message stringByAppendingString:[NSString stringWithFormat:@"%@, ",object.firstName]];
                        
                    }
                    invitationButtonTitle = @"Send them an invitaion";
                    
                }
                
                else if(nonChatContcats.count > 4)
                {
                    
                    
                    for (int j = 0 ; j < nonChatContcats.count; j++)
                    {
                        ContactObject * object = nonChatContcats[j];
                        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@, ",object.firstName]];
                        
                    }
                    message = [message substringToIndex:message.length - 2];
                    message = [NSString stringWithFormat:@"%@ and %lu other need",message,nonChatContcats.count-4];
                    invitationButtonTitle = @"Send them an invitaion";
                    
                }
                
                
                message = [NSString stringWithFormat:@"%@ to download the app and sign up first to join this chat!",message];
                NSLog(@"nonChatContcats %lu",(unsigned long)nonChatContcats.count);
                 NSLog(@"arrayGroupMembers %lu",(unsigned long)arrayGroupMembers.count);
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitle message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:invitationButtonTitle, nil];
                
                if(arrayGroupMembers.count - nonChatContcats.count> 0) // To sue that user has at least two person to chat
                [alert addButtonWithTitle:@"Start chat with others"];
                [alert setTag:TAG_FOR_GROUP_MEMBER_INVITATION];
                [alert show];
                return;
                
                
                
                
            }
            else
            {
                [self startChatingWithGroup];
            }
            
            
        }
    }
    
}

-(void)startChatingWithGroup
{
   //self.groupObject.appLogicId.integerValue
    NSLog(@"self.groupObject.appLogicId.integerValue %ld",self.groupObject.appLogicId.integerValue);
    
    ALChannelService * channelService = [ALChannelService new];
    [channelService getChannelInformation:[NSNumber numberWithInteger:self.groupObject.appLogicId.integerValue] orClientChannelKey:nil withCompletion:^(ALChannel *alChannel) {
        
        ALChatLauncher * chatLauncher = [[ALChatLauncher alloc] initWithApplicationId:APPLOZIC_KEY];
        [chatLauncher launchIndividualChat:nil withGroupId:alChannel.key
                   andViewControllerObject:self andWithText:@""];
    }];
    
//    
//    ALChatLauncher * chatLauncher = [[ALChatLauncher alloc] initWithApplicationId:APPLOZIC_KEY];
//    [chatLauncher launchIndividualChat:nil withGroupId:[NSNumber numberWithInteger:self.groupObject.appLogicId.integerValue] andViewControllerObject:self andWithText:@""];

    
    
//     [self launchChatForContact:self.groupObject.name withGroupId:self.groupObject.appLogicId];
    
    //by sir
   //    ALChatLauncher * chatLauncher = [[ALChatLauncher alloc] initWithApplicationId:APPLOZIC_KEY];
//    [chatLauncher launchIndividualChat:nil withGroupId:[NSNumber numberWithInteger:1346939] andViewControllerObject:self andWithText:@""];
    //by me
//        NSMutableArray * canChatEmailsArray = [[NSMutableArray alloc]init];
//        for (int i = 0 ; i < arrayGroupMembersObject.count; i++)
//        {
//            ContactObject * object = arrayGroupMembersObject[i];
//            if(object.appLogicId.length > 0)
//            [canChatEmailsArray addObject:object.appLogicId];
//            
//        }
//    NSLog(@"canChatEmailsArray %@",canChatEmailsArray);
//     self.creatingChannel = [[ALChannelService alloc] init];
//    [self.creatingChannel createChannel:self.groupObject.name orClientChannelKey:nil andMembersList:canChatEmailsArray andImageLink:self.groupObject.image
//                              withCompletion:^(ALChannel *alChannel) {
//     
//                                  
//     
//                              }];
    
    
   
    
                             
                             
                             
    
    


    // Fisrt we need to filter out the user who can chat
    
//    NSMutableArray * canChatEmailsArray = [[NSMutableArray alloc]init];
//    for (int i = 0 ; i < arrayGroupMembersObject.count; i++)
//    {
//        ContactObject * object = arrayGroupMembersObject[i];
//        if(object.appLogicId.integerValue > 0)
//        [canChatEmailsArray addObject:[ECSAppHelper getUniqueApplogicName:[NSString stringWithFormat:@"%@",object.email] andEmail:object.email]];
//        
//    }
//    
//    //[ECSAppHelper getUniqueApplogicName:[NSString stringWithFormat:@"%@",object.email] andEmail:object.email]
//    
//    
//    self.creatingChannel = [[ALChannelService alloc] init];
//    [self.creatingChannel createChannel:self.groupObject.name orClientChannelKey:nil andMembersList:canChatEmailsArray andImageLink:self.groupObject.image
//                         withCompletion:^(ALChannel *alChannel) {
//                             
//                              [self launchChatForContact:self.groupObject.name withGroupId:alChannel.key];
//                         
//                         }];
//}

//         if (arrEmai.count) {
//                 // [ECSAlert showAlert:@"some user not registered  with app."];
//              NSString *nss=[NSString stringWithFormat:@"%@ is not on the %@ %@",self.groupObject.name,@"Norwood",@"app yet.Invite them to download the app to chat with them! "];
//              [_activityView removeFromSuperview];
//              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:nss delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite by Email", nil];
//              alert.tag = 2002;
//              [alert show];
//              alert = nil;
//              
//              
//          }else{
//          
//      }
//      
//      
//
  }



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 2001)
    {
        if (buttonIndex==1)
        {
            // [self startServiceDeleteContact];Hi,
          
            NSString *mailBody= [ECSAppHelper getInvitationMailBody];
            NSMutableArray *contactArr=[[NSMutableArray alloc]init];
            [contactArr addObject:self.ContactsData.email];
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            if ([MFMailComposeViewController canSendMail]) {
                mc.mailComposeDelegate = self;
                [mc setSubject:@"You’re invited!"];
                [mc setMessageBody:mailBody isHTML:NO];
                [mc setToRecipients:contactArr];
                
                [self presentViewController:mc animated:YES completion:NULL];
                
            }

            
        }
    }
    else if (alertView.tag==2002){
        if (buttonIndex==1)
        {
            // [self startServiceDeleteContact];
           
               NSString *mailBody= [ECSAppHelper getInvitationMailBody];

                NSArray *array = [arrEmai copy];
                NSString *emailTitle = @"You’re invited!";
                // Email Content
               // NSString *messageBody = @"";
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                if ([MFMailComposeViewController canSendMail]) {
                    mc.mailComposeDelegate = self;
                    [mc setSubject:emailTitle];
                    [mc setMessageBody:mailBody isHTML:NO];
                    [mc setToRecipients:array];
                    
                    [self presentViewController:mc animated:YES completion:NULL];
            
                }
        }

        
    }
    
    else if (alertView.tag == TAG_FOR_GROUP_MEMBER_INVITATION)
    {
    
        if(buttonIndex == 1)
        {
            NSMutableArray * nonChatContcatsEmails = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < arrayGroupMembersObject.count; i++)
            {
                ContactObject * object = arrayGroupMembersObject[i];
                if(object.appLogicId.length == 0)
                [nonChatContcatsEmails addObject:object.email];
                
            }
            
            NSString *mailBody= [ECSAppHelper getInvitationMailBody];

            NSString *emailTitle = @"You’re invited!";
            // Email Content
            // NSString *messageBody = @"";
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            if ([MFMailComposeViewController canSendMail]) {
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:mailBody isHTML:NO];
                [mc setToRecipients:nonChatContcatsEmails];
                
                [self presentViewController:mc animated:YES completion:NULL];
                
            }
        }
        else if (buttonIndex == 2) [self startChatingWithGroup];
    }
}



-(void)checkRegisteredUser :(NSString*)UserId
{
    
  }



-(void)launchChatForContact:(NSString *)contactId  withGroupId:(NSNumber*)channelKey
{
          //ALChannelService * createChanelForGroup = [[ALChannelService alloc] init];
     ALChatLauncher * chatLauncher = [[ALChatLauncher alloc] initWithApplicationId:APPLOZIC_KEY];
     [chatLauncher launchIndividualChat:nil withGroupId:channelKey andViewControllerObject:self andWithText:@""];
    
    
   
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
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/getGroupMembers/%@",SERVERURLPATH,self.groupObject.groupObjectId]];
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
        
        [self showGroupOptionView:self.groupObject];
        if(arrayGroupMembers == nil)
            arrayGroupMembers = [[NSMutableArray alloc]init];
        else [arrayGroupMembers removeAllObjects];
        
        if(arrayGroupMembersObject == nil)
        arrayGroupMembersObject = [[NSMutableArray alloc]init];
        else [arrayGroupMembersObject removeAllObjects];
        
        
        //arrayGroupMembersObject
        if(arrayALuserGrpMember == nil)
            arrayALuserGrpMember = [[NSMutableArray alloc]init];
        else [arrayALuserGrpMember removeAllObjects];
        
      
        
        
        
        NSArray * notification=[[rootDictionary objectForKey:@"Groups"]objectForKey:@"groupMembers"];
        for (NSDictionary * dictionary in notification)
        {
            ContactObject  *object=[ContactObject instanceFromDictionary:dictionary];
            [arrayGroupMembersObject addObject:object];
            [arrayGroupMembers addObject:[ECSAppHelper getUniqueApplogicName:[NSString stringWithFormat:@"%@",object.email] andEmail:object.email]];
            
          
            
        }
      
        
    }
    else
    {
        [ECSAlert showApiError:rootDictionary respString:response.stringValue error:response.error];
    
    }
    
}




- (IBAction)clickToMessage:(id)sender {
   // NSString *strTitle=[NSString stringWithFormat:@"%@ %@",@"test",@"test"];
     NSString *messageBody=@" ";
    if ([selectedIndGroups isEqualToString:@"indv"]){
        NSLog(@"self.ContactsData.phoneNo %@",self.ContactsData.phoneNo);
        if (self.ContactsData.phoneNo.length==10) {
            NSString *strTitle=[NSString stringWithFormat:@"%@",self.ContactsData.phoneNo];
            NSString *messageBody=@" ";
            NSMutableArray *array = [[ NSMutableArray alloc]init];
            [array addObject:strTitle];
            if([MFMessageComposeViewController canSendText])
            {
                MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
                messageComposer.body = messageBody;
                messageComposer.messageComposeDelegate = self;
                
                messageComposer.recipients = array;
                
                //        [messageComposer setRecipients:array];
                [self presentViewController: messageComposer animated:YES completion:nil];
                messageComposer = nil;
            }
        }else{
             [ECSAlert showAlert:@"Please update a phone number to text."];
        }
   
    }else{
        {
           
            NSMutableArray *contactArr=[[NSMutableArray alloc]init];
            for (int i = 0 ; i < self.groupObject.contacts.count; i++)
            {
                ContactObject *varObject = [self.groupObject.contacts objectAtIndex:i];
                [contactArr addObject:varObject.phoneNo];
                
            }
            
            if (contactArr.count) {
                if([MFMessageComposeViewController canSendText])
                {
                    MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
                    messageComposer.body = messageBody;
                    messageComposer.messageComposeDelegate = self;
                    [messageComposer setRecipients:contactArr];
                    //  messageComposer.recipients = joinedString;
                    [self presentViewController: messageComposer animated:YES completion:nil];
                    messageComposer = nil;
                }
            }else{
               [ECSAlert showAlert:@"Please update a phone number to text."];
            }
           
          
           

    }
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Message cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Message not sent.");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(IBAction)OnClickEmail:(id)sender{
    // [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if ([selectedIndGroups isEqualToString:@"indv"]){
        NSLog(@"self.ContactsData.email %@",self.ContactsData.email);
        if ([self.ContactsData.email isEqualToString:@""]) {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:nil message:@"Please update an email address for this contact first." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }else{
           
   //  [[ECSMessage sharedInstance] sendMailTo:self.ContactsData.email subject:@"" body:@"" withController:self];
           NSMutableArray *contactArr=[[NSMutableArray alloc]init];
            [contactArr addObject:self.ContactsData.email];
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            if ([MFMailComposeViewController canSendMail]) {
                mc.mailComposeDelegate = self;
                [mc setSubject:@""];
                [mc setMessageBody:@"" isHTML:NO];
                [mc setToRecipients:contactArr];
                
                [self presentViewController:mc animated:YES completion:NULL];
                
            }

            
        }
   
    }else{
        
        
        
        NSMutableArray *contactArr=[[NSMutableArray alloc]init];
        ContactObject *varObject;
        for (int i = 0 ; i < self.groupObject.contacts.count; i++)
        {
            
            varObject = [self.groupObject.contacts objectAtIndex:i];
            
            [contactArr addObject:varObject.email];
            
        }
        if (varObject.email.length>=10 ) {
        
        NSArray *array = [contactArr copy];
        NSString *emailTitle = @"";
        // Email Content
        NSString *messageBody = @"";
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
             if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:array];
        
        [self presentViewController:mc animated:YES completion:NULL];
          
             }
        }else{
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:nil message:@"Please update an email address for this contact first." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
            
        }
    }
}





-(IBAction)OnClickText:(id)sender{
    
}
-(IBAction)OnClickCall:(id)sender{

    if ([selectedIndGroups isEqualToString:@"indv"]){
        if ([self.ContactsData.phoneNo isEqualToString:@""]) {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:nil message:@"Please update a phone number for this contact to send them a text." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }else{
        
    NSString *titleOfButton = [[[[self.ContactsData.phoneNo stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", titleOfButton]];
    
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not available!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
        calert = nil;
    }
    }
    }
    else{
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not available!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
        calert = nil;
    }

}

-(IBAction)backButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickEditAtPopup:(id)sender{
    
    if ([selectedIndGroups isEqualToString:@"indv"]) {
        self.viewNotifyPopUp.hidden=YES;
        BC_UpdateContactVC *contentScreen = [[BC_UpdateContactVC alloc]initWithNibName:@"BC_UpdateContactVC" bundle:nil];
         contentScreen.selectedContactsData=self.ContactsData;
        [self.navigationController pushViewController:contentScreen animated:YES];
      
    }else{
         self.viewNotifyPopUp.hidden=YES;
        if([self.btnContactGroup.titleLabel.text isEqualToString:@"Edit Contact"]){
            BC_UpdateContactVC *contentScreen = [[BC_UpdateContactVC alloc]initWithNibName:@"BC_UpdateContactVC" bundle:nil];
            contentScreen.selectedContactsData=self.ContactsData;
            [self.navigationController pushViewController:contentScreen animated:YES];
 
        }else{
        BC_GroupDetailVC *contentScreen = [[BC_GroupDetailVC alloc]initWithNibName:@"BC_GroupDetailVC" bundle:nil];
        contentScreen.selectedGroupData=self.groupObject;
        [self.navigationController pushViewController:contentScreen animated:YES];
        }
      
    }

    
}

-(IBAction)onClickPlusButton:(id)sender{
    //BC_AddContactVC
    if ([selectedIndGroups isEqualToString:@"indv"]) {
        
        BC_AddContactVC *contentScreen = [[BC_AddContactVC alloc]initWithNibName:@"BC_AddContactVC" bundle:nil];
        [self.navigationController pushViewController:contentScreen animated:YES];

    }else{
        
        BC_AddGroupVC *contentScreen = [[BC_AddGroupVC alloc]initWithNibName:@"BC_AddGroupVC" bundle:nil];
        [self.navigationController pushViewController:contentScreen animated:YES];

    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([selectedIndGroups isEqualToString:@"indv"]){
   
    if(buttonIndex==0)
    {
        
        BC_AddContactVC *contentScreen = [[BC_AddContactVC alloc]initWithNibName:@"BC_AddContactVC" bundle:nil];
        [self.navigationController pushViewController:contentScreen animated:YES];
    }
    else if(buttonIndex==1)
    {
        [actionSheet removeFromSuperview];

    }
    }
    else{
        if(buttonIndex==0)
        {
            
            BC_AddGroupVC *contentScreen = [[BC_AddGroupVC alloc]initWithNibName:@"BC_AddGroupVC" bundle:nil];
                    [self.navigationController pushViewController:contentScreen animated:YES];
        }
        else if(buttonIndex==1)
        {
            [actionSheet removeFromSuperview];
           
        }
    }
    
    
}

-(void)audioRecorderController:(IQAudioRecorderViewController *)controller didFinishWithAudioAtPath:(NSString *)filePath
{
    audioFilePath = filePath;
    buttonPlayAudio.enabled = YES;
    
    NSLog(@"audioFilePath %@",audioFilePath);
    // NSLog(@"data %@",data);
   
    
    [controller dismissViewControllerAnimated:YES completion:^{
        [self startServiceToVoiceBroadcast];
    }];
    
}

-(void)audioRecorderControllerDidCancel:(IQAudioRecorderViewController *)controller
{
    buttonPlayAudio.enabled = NO;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickToBroadcastMessage:(id)sender {
    
    
    
    self.iQAudioRecorderViewController = [[IQAudioRecorderViewController alloc] init];
    self.iQAudioRecorderViewController.delegate = self;
    self.iQAudioRecorderViewController.audioFormat = IQAudioFormat_wav;
    [self presentAudioRecorderViewControllerAnimated:self.iQAudioRecorderViewController];
    
    
    
}


-(void)startServiceToVoiceBroadcast
{
    
//    NSString * waveFilePath = [self exportAssetAsWaveFormat:audioFilePath];
//    
//    if(waveFilePath)
//    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });

        [self performSelectorInBackground:@selector(serviceGetVoiceBroadcast:) withObject:audioFilePath];
//    }
//    else NSLog(@"We are not able to convert the CAF in WAV");
    
    
}
-(void)serviceGetVoiceBroadcast:(NSString *)mp3FilePath
{
  
    
   
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSData *audioFileData = [fileManger contentsAtPath:mp3FilePath];
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:IMAGE];
    
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    
    
    NSString * fileName = [ECSDate getStringFromDate:[NSDate date] inFormat:@"HH:mm"];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/send-voice-broadcast",SERVERURLPATH]];
    [class addImageData:audioFileData withName:[NSString stringWithFormat:@"%@.wav",fileName] forKey:@"audio_file"];
    
    //NSInteger selectedSegment = self.segmentSwitch.selectedSegmentIndex;
    if ([selectedIndGroups isEqualToString:@"indv"]){
        [class addParam:self.ContactsData.contactId.stringValue forKey:@"contact_id"];
    }else{
        [class addParam:self.groupObject.groupObjectId.stringValue forKey:@"group_id"];
    }
    
    [class setCallback:@selector(callBackServiceToVoiceBroadcast:)];
    [class setController:self];
    [class runService];
}


-(void)callBackServiceToVoiceBroadcast:(ECSResponse *)response
{
    
   
    NSDictionary * rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    NSLog(@"rootDictionary %@",rootDictionary);
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(response.isValid)
    {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([rootDictionary objectForKey:@"errors"] ) {
    
              [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
        }else if ([rootDictionary objectForKey:@"statusDescription"]){
           
                [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];

        }else{
        
              [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];

        }
        
        
    }
    if(!rootDictionary){
         [ECSAlert showAlert:response.stringValue];
        // [ECSToast showToast:response.stringValue view:self.view];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)onClickConferenceCall:(id)sender{

    [self startServiceToConferenceCall];
}

-(void)startServiceToConferenceCall
{
    
   
 
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    [self performSelectorInBackground:@selector(serviceGetConferenceCall) withObject:nil];
    
}
-(void)serviceGetConferenceCall
{
   
  
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/make-conference-call",SERVERURLPATH]];
    
        [class addParam:self.groupObject.groupObjectId.stringValue forKey:@"group_id"];
  
    
    [class setCallback:@selector(callBackServiceToConferenceCall:)];
    [class setController:self];
    [class runService];
}


-(void)callBackServiceToConferenceCall:(ECSResponse *)response
{
    
    
    NSDictionary * rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    NSLog(@"rootDictionary %@",rootDictionary);
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(response.isValid)
    {
       
        if ([[rootDictionary objectForKey:@"errors"] isEqualToString:@"Invalid Phone number please check your phone number."]) {
            //Couldn't make this call! We found one or more invalid phone numbers
              [ECSAlert showAlert:@"Couldn't make this call! We found one or more invalid phone numbers."];
        }
       else if ([rootDictionary objectForKey:@"errors"]) {
            //Couldn't make this call! We found one or more invalid phone numbers
            [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
        }

        else if ([rootDictionary objectForKey:@"statusDescription"]){
            // [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
          //  [ECSToast showToast:[rootDictionary objectForKey:@"statusDescription"] view:self.view];
            
             [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
            
            //            [[[[iToast makeText:[rootDictionary objectForKey:@"statusDescription"]]
            //               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }else{
            //[ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
           // [ECSToast showToast:[rootDictionary objectForKey:@"message"] view:self.view];
               [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
            //            [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
            //               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
        
        
    }
    if(!rootDictionary){
        [ECSAlert showAlert:response.stringValue];
       // [ECSToast showToast:response.stringValue view:self.view];
    }
}

-(IBAction)recordVideo:(id)sender{
//    if ([selectedIndGroups isEqualToString:@"indv"]){
//    DVGCameraViewController *contentScreen = [[DVGCameraViewController alloc]initWithContactId:self.ContactsData.contactId.stringValue withgroupId:nil];
//    
//    [self.navigationController pushViewController:contentScreen animated:YES];
//    }else{
//      
//        DVGCameraViewController *contentScreen = [[DVGCameraViewController alloc]initWithContactId:nil withgroupId:self.groupObject.groupObjectId.stringValue];
//        
//        [self.navigationController pushViewController:contentScreen animated:YES];
//    }
    
     [ECSAlert showAlert:@" Coming soon!"];
}

/*
 NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/exist", KBASE_URL];
 NSString * theParamString = [NSString stringWithFormat:@"userId=%@",[userId urlEncodeUsingNSUTF8StringEncoding]];
 NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
 
 [ALResponseHandler processRequest:theRequest andTag:@"USER_EXIST" WithCompletionHandler:^(id theJson, NSError *theError) {
 if (theError)
 {
 return ;
 }
 else
 {
 NSLog(@"Response of USER_EXIST: %@", (NSString *)theJson);
 if([userId isEqualToString:@"User Not Found"]){
 NSLog(@"USER NOT EXIST::");
 }else{
 NSLog(@"USER Exist");
 }
 }
 }];
 
 */

- (IBAction)clickToGoBack:(id)sender {
    
    
   _viewHelp.hidden =YES;
}

- (IBAction)clickOnHelpBtn:(id)sender {
    
    
    
    _viewHelp.hidden =NO;
  
    
    
}

-(IBAction)onClickGotIt:(id)sender{
    
    self.viewChatTutorial.hidden=YES;
    self.viewChatTutorialForGp.hidden=NO;
     self.viewChatTutorialForGp.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView transitionFromView: self.viewChatTutorial
                        toView:self.viewChatTutorialForGp
                      duration:2
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished){
                        [ self.viewChatTutorial removeFromSuperview];
                    }];
    
    //[self.view addSubview:self.viewChatTutorialForGp];
}

-(IBAction)onClickGpGotIt:(id)sender{
     self.viewChatTutorial.hidden=YES;
     self.viewChatTutorialForGp.hidden=YES;
    
    _activityView.center=self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];
    
    self.viewConnectSegment.frame=CGRectMake(self.view.frame.size.width-100, 61, 91, 4);
    ALUser *user = [[ALUser alloc] init];
    [user setUserId:[ALUserDefaultsHandler getUserId]];
    [user setEmail:[ALUserDefaultsHandler getEmailId]];
    [user setPassword:@""];
    [user setDisplayName:[NSString stringWithFormat:@"%@ %@",self.appUserObject.first,self.appUserObject.lastName]];
    // [ALUserDefaultsHandler setDisplayName:user.displayName];
    [user setImageLink:self.appUserObject.profileImage];
    ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:APPLOZIC_KEY];
    [chatManager registerUserAndLaunchChat:user andFromController:self forUser:nil withGroupId:nil];

}

@end
