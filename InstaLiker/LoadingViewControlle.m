//
//  Login2ViewController.m
//  InstaLiker
//
//  Created by Gui on 22/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "LoadingViewController.h"
#import "Settings.h"
#import "Coins.h"
#import "Richiesta.h"
#import "Utente.h"
#import "Login.h"
#import "Tapjoy.h"
#import <AdColony/AdColony.h>
#import "UIBezierPath+IOS7RoundedRect.h"


@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}




- (void)viewDidLoad{
    [super viewDidLoad];
    
    float cornerRadius = 40;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cornerRadius = 40*1.46;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithIOS7RoundedRect:img.bounds cornerRadius:cornerRadius];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = img.bounds;
    maskLayer.path = path.CGPath;
    img.layer.mask = maskLayer;

    if ([[[Utente sharedUtente]ID]length]) {
    
        NSDictionary *dic = [[Richiesta new]sendRequest:@"login.php" parameters:nil];
        [[Coins sharedCoins]update:[dic[@"coins"] intValue]];
        [[Utente sharedUtente]setIsPro:[dic[@"pro"] boolValue]];
        [Tapjoy setUserID:[[Utente sharedUtente]ID]];
        [AdColony setCustomID:[[Utente sharedUtente]ID]];
        [[NSUserDefaults standardUserDefaults]setValue:@"OO" forKey:@"OO"];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rootController"] animated:YES];
    }
}



@end
