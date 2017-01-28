//
//  BWWebOfferViewController.m
//  Buckworm
//
//  Created by Daksha Mac 3 on 17/03/16.
//  Copyright © 2016 Engtelegent. All rights reserved.
//

#import "BC_WebPageVC.h"
#import "ECSServiceClass.h"
#import "AppDelegate.h"
#import "UIExtensions.h"
#import "DSActivityView.h"

@interface BC_WebPageVC ()<UIWebViewDelegate, UITextFieldDelegate>{
    AppDelegate *appDelegate;
    BOOL keyboardIsShown;
}


@property (weak, nonatomic) IBOutlet UIWebView *webiew;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) NSString * urlString;

@property (nonatomic, retain) NSString * titleString;


@property (weak, nonatomic) IBOutlet UIImageView *imgChecK;
@property (weak, nonatomic) IBOutlet UIView *mainView;


- (IBAction)clickToBack:(id)sender;

@end

@implementation BC_WebPageVC

-(id)initWithURL:(NSString *)url andTitle:(NSString *)string
{
    self = [self init];
    self.urlString = url;
    self.titleString = string;
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    


    
    
     self.lblTitle.text = self.titleString;
    
    [DSBezelActivityView newActivityViewForView:self.view
                                      withLabel:@"Loading..."];

    NSURLRequest *requestObject = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    [_webiew loadRequest:requestObject];
    
    UIExtensions *extenions = [UIExtensions sharedInstance];
    extenions.parentController = self;

}

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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
[DSBezelActivityView removeViewAnimated:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [DSBezelActivityView removeViewAnimated:NO];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)  {
        [DSBezelActivityView newActivityViewForView:self.view
                                          withLabel:@"Loading..."];
    }
    
    return YES;
}



- (IBAction)clickToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //code to be executed with the dismissal is completed
        // for example, presenting a vc or performing a segue
    }];
}




@end
