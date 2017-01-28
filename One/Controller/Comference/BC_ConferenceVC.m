//
//  BC_ConferenceVC.m
//  BergerCounty
//
//  Created by Daksha on 11/8/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "BC_ConferenceVC.h"
#import "ECSServiceClass.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
@interface BC_ConferenceVC ()
{
    
    
}
@property (nonatomic, retain) NSString * confUserId;
@property (nonatomic, retain) NSString * roomNum;
@property (nonatomic, retain) NSString * confInitiatorName;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblname;
//@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@end

@implementation BC_ConferenceVC


-(id)initWithUsername:(NSString *)userId withRoomNumber:(NSString *)RoomNumber
{
    
    self = [self initWithNibName:@"BC_ConferenceVC" bundle:nil];
       self.confUserId = userId;
        self.roomNum=RoomNumber;
    
    return self;
    
}
- (void)viewDidLoad {
    self.btnJoin.layer.cornerRadius = 20; // this value vary as per your desire
    self.btnJoin.clipsToBounds = YES;
     self.btnJoin.layer.borderColor = [UIColor greenColor].CGColor;
    self.btnJoin.clipsToBounds = YES;
    NSString *confSenderName=[NSString stringWithFormat:@"You've been invited to join a conference!"];
    self.lblname.text=confSenderName;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickCancel:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickJoin:(id)sender{
    
   // [self.navigationController popViewControllerAnimated:YES];
    [self startServiceToJoinVoiceConference];
}
-(void)startServiceToJoinVoiceConference
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceGetVoiceJoinVoiceConference) withObject:nil];
    
    
}
-(void)serviceGetVoiceJoinVoiceConference
{
    /*
     URL: https://www.buckworm.com/laravel/index.php/api/v1/join-conference-call
     PARAMS: userId, roomNumber
     Login:required
     Method:post
     */
//    https://www.buckworm.com/join_conference_link.php?user_id=530&roomNo=2867conference081116061317&conference_initiator=bc25%20test&redirect_url=bergenJoinConference://
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/join-conference-call",SERVERURLPATH]];
  
     [class addParam:self.confUserId forKey:@"userId"];
   
        [class addParam:self.roomNum forKey:@"roomNumber"];
//    [class addParam:@"530" forKey:@"userId"];
//    
//    [class addParam:@"2867conference081116061317" forKey:@"roomNumber"];
//    
    
    [class setCallback:@selector(callBackServiceToJoinVoiceConference:)];
    [class setController:self];
    [class runService];
}


-(void)callBackServiceToJoinVoiceConference:(ECSResponse *)response
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
    if (!rootDictionary) {
        [ECSAlert showAlert:response.stringValue];
    }
    
}


/*
 URL: https://www.buckworm.com/laravel/index.php/api/v1/join-conference-call
 PARAMS: userId, roomNumber
 Login:required
 Method:post
 
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
