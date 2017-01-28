//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "BC_ChooseMemberVC.h"
#import "ConnectionObject.h"
#import "ChooseMemberCell.h"
#import "ECSServiceClass.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "ContactObject.h"
//#import "BC_ContactScreenVC.h"
#import "CH_ChatScreen.h"
//#import "iToast.h"
#import "BC_AddContactVC.h"
//#import "THContactPickerViewController.h"
@interface BC_ChooseMemberVC ()<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic,retain) NSNumber *groupID;
@property (nonatomic, retain) NSMutableArray * arrayContacts;
@property (nonatomic, retain) NSMutableArray * arraySelected;
@property (weak, nonatomic) IBOutlet UITableView  *tblContacts;

@property (strong, nonatomic) IBOutlet UIView *viewTop;

- (IBAction)ClickToDone:(id)sender;

@end

@implementation BC_ChooseMemberVC

-(id)initWithGroupDetail:(NSNumber *)GroupID
{
    self = [self initWithNibName:@"BC_ChooseMemberVC" bundle:nil];
    self.groupID = GroupID;
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self settingTopView:self.viewTop onController:self andTitle:@"Add new contact"];
    NSLog(@"self.arrayGroupMembers %@",self.arrayGroupMembers);
    _arraySelected=[[NSMutableArray alloc]init];
    
//    for (int i=0; i<self.arrayGroupMembers.count; i++) {
//        ContactObject * connection = [self.arrayGroupMembers objectAtIndex:i];
//        if (connection.contactId) {
//            NSString *strContact=  [NSString stringWithFormat:@"%li",(long)i];
//            [_arraySelected addObject:strContact];
//          
//        }
//    }

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     [self startServiceToAllContact];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

     return self.arrayContacts.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        
    static NSString *CellIdentifier = @"ConnectionObject";
    ContactObject * connectionObject = [self.arrayContacts objectAtIndex:indexPath.row];
    ChooseMemberCell *cell = (ChooseMemberCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        UINib *nib = [UINib nibWithNibName:@"ChooseMemberCell" bundle:nil];
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
    [cell.lblText setText:[NSString stringWithFormat:@"%@ %@",connectionObject.firstName,connectionObject.lastName]];
    
    [cell.btnCheck addTarget:self action:@selector(clickToChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL flag=   [_arraySelected containsObject:
                  [NSString stringWithFormat:@"%li",indexPath.row]];
    

    
    
    
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
    
    
    return cell;

   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES ];
}

- (IBAction)clickToChoose:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=  [NSString stringWithFormat:@"%li",btn.tag];
    BOOL flag=   [_arraySelected containsObject:strContact];
    
    
    
    if(flag == NO )
    {
        [_arraySelected addObject:strContact];
    }
    else {
        ContactObject * connectionObject = [self.arrayContacts objectAtIndex:btn.tag];
       
        [self serviceToDeleteMember:connectionObject.contactId.stringValue];
        [_arraySelected removeObject:strContact];

      
        
    }
    NSLog(@"_arraySelected %@",_arraySelected);
       
    [self.tblContacts reloadData];
}


//-(void)startServiceDeleteMember :
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self performSelectorInBackground:@selector(serviceToDeleteMember) withObject:nil];
//    //[self startServiceDeleteMember:contactId];
//    
//}

-(void)serviceToDeleteMember :(NSString *)contactId
{
    //NSString *contactid=[NSString stringWithFormat:@"%@",contactId];
    //http://www.buckworm.com/laravel/index.php/api/v1/removecontactFromGroupMember
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/removecontactFromGroupMember",SERVERURLPATH]];
    [class addParam:contactId forKey:@"contact_id"];
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceToDeleteMember:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteMember:(ECSResponse *)response
{
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        [ECSAlert showAlert:@"Deleted successfully!"];
       // [self startServiceToGroupDetail];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    else {
        
        // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
}











- (IBAction)clickToChoose1:(id)sender {
    UIButton *btn=(UIButton *)sender;
    NSString *strContact=[NSString stringWithFormat:@"%li",btn.tag];
   ContactObject * connectionObject = [self.arrayContacts objectAtIndex:btn.tag];;
    BOOL flag=   [_arraySelected containsObject:strContact];
    NSString *contactId=connectionObject.contactId.stringValue;
    if(flag == NO )
    {
        
        [btn setImage:[UIImage imageNamed:@"checked-icon.png"] forState:UIControlStateNormal];
        [_arraySelected addObject:contactId];
        
    }
    else {
        
        [btn setImage:[UIImage imageNamed:@"check-box-icon.png"] forState:UIControlStateNormal];
        [_arraySelected removeObject:contactId];
    }
    [self.tblContacts reloadData];
}

-(void)startServiceToAllContact
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToAllContact) withObject:nil];
    
    
}

-(void)serviceToAllContact
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
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
        
        
        if(self.arrayContacts == nil)
            self.arrayContacts = [[NSMutableArray alloc]init];
        else [self.arrayContacts removeAllObjects];
        
        NSArray * notification=[rootDictionary objectForKey:@"contacts"];
        for (NSDictionary * dictionary in notification)
        {
            ContactObject  *object=[ContactObject instanceFromDictionary:dictionary];
            [self.arrayContacts addObject:object];
        }
        
        
        for (int i=0; i<self.arrayGroupMembers.count; i++) {
            ContactObject * connectionGp = [self.arrayGroupMembers objectAtIndex:i];
            
            for (int i=0; i<self.arrayContacts.count; i++) {
                ContactObject * connection = [self.arrayContacts objectAtIndex:i];
                
                if ([connectionGp.contactId isEqual:connection.contactId]) {
                    NSString *strContact=  [NSString stringWithFormat:@"%li",(long)i];
                    [_arraySelected addObject:strContact];
                    
                }

                  }

            
        }

        
          NSLog(@"_arraySelected %@",_arraySelected);
        
        [self.tblContacts reloadData];
        
    }
   
    
}
-(void)startServiceToAddContact
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToAddContact1) withObject:nil];
    
    
}

-(void)serviceToAddContact1
{
    //https://www.buckworm.com/laravel/index.php/api/v1/addGroupMember
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/addGroupMember",SERVERURLPATH]];
    [class addParam:self.groupID.stringValue forKey:@"group_id"];
    NSString *joinedString;
    NSMutableArray *arrayData=[[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.arraySelected.count; i++)
    {
        NSLog(@"self.arraySelected.count %@",[self.arraySelected objectAtIndex:i]);
        
        NSNumber *anumber = [self.arraySelected objectAtIndex:i];
        int yourInteger = [anumber intValue];
        ContactObject * varObject = [self.arrayContacts objectAtIndex:yourInteger];
       
        [arrayData addObject:varObject.contactId.stringValue];

    }
   
    NSArray *myArray = [NSArray arrayWithArray:arrayData];
     joinedString = [myArray componentsJoinedByString:@","];
    NSLog(@"joinedString %@",joinedString);
    [class addParam:joinedString forKey:@"contact_id"];
    [class setCallback:@selector(callBackServiceToGetAddContact:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetAddContact:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
      
        
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Members added successfully"]) {
              [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
              [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
       
      [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        }

    }
    else {
         [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        

    }
    
}


-(IBAction)onClickAddContact:(id)sender{
    
    BC_AddContactVC *vc=[[BC_AddContactVC alloc]initWithNibName:@"BC_AddContactVC" bundle:nil];
  vc.openWithGroup=@"GROUP";
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (IBAction)ClickToDone:(id)sender {
    
    [self startServiceToAddContact];
}
@end
