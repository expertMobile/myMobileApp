//
//  Login.m
//  InstaLiker
//
//  Created by Gui on 22/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "Login.h"
#import "LoadingViewController.h"
#import "Settings.h"
#import "Richiesta.h"
#import "Coins.h"
#import "Utente.h"
#import <CommonCrypto/CommonHMAC.h>
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import <sys/utsname.h>


@interface Login ()

@end

@implementation Login

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad{
    HUD = [[MBProgressHUD alloc]init];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD show:YES];
    [self.view addSubview:HUD];
    web.delegate = self;
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id={INSTAGRAM CLIENT ID)&redirect_uri=http://mysite.com&response_type=token&scope=likes+relationships"]]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if ([request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        NSString *token = [request.URL.absoluteString substringFromIndex:[request.URL.absoluteString rangeOfString:@"access_token"].location + [@"access_token" length] + 1];
        [[Utente sharedUtente]setToken:token];
        [HUD show:YES];
        webView.alpha = 0;
        [AdColony playVideoAdForZone:[Settings sharedInstance][@"adColony"][@"login"] withDelegate:self];
        [self performSelector:@selector(avanti) withObject:nil afterDelay:0.1];
        return NO;
    }
    
    return YES;
}


- (void)avanti{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", [[Utente sharedUtente]token]]]];
        
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:0 error:nil];
        
        [[Utente sharedUtente]setID:d[@"data"][@"id"]];
        
        
        NSDictionary *dic = [[Richiesta new]sendRequest:@"login.php" parameters:@{@"b": ([[NSUserDefaults standardUserDefaults]valueForKey:@"TokenPush"] ? [[NSUserDefaults standardUserDefaults]valueForKey:@"TokenPush"] : @"")}];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [[Coins sharedCoins]update:[dic[@"coins"] intValue]];
            [[Utente sharedUtente]setID:[[Utente sharedUtente]ID]];
            [Tapjoy setUserID:[[Utente sharedUtente]ID]];
            [AdColony setCustomID:[[Utente sharedUtente]ID]];
            [[NSUserDefaults standardUserDefaults]setValue:@"AA" forKey:@"OO"];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rootController"] animated:YES];
        });
        
    });
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if ([webView.request.URL.absoluteString rangeOfString:@"authorize/?client_id="].location != NSNotFound) {
        [HUD hide:YES];
    }
}




@end
