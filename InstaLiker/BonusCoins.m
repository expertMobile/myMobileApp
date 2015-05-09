//
//  BonusCoins.m
//  InstaLiker
//
//  Created by Gui on 01/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "BonusCoins.h"
#import "SIAlertView.h"
#import "Richiesta.h"
#import "Coins.h"
#import "Utente.h"
#import "REFrostedViewController.h"


@import Social;

@interface BonusCoins ()

@end

@implementation BonusCoins


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setCoins{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSDictionary *dic = [[Richiesta new]sendRequest:@"login.php" parameters:nil];
        

        dispatch_sync(dispatch_get_main_queue(), ^{
            [[Coins sharedCoins]update:[dic[@"coins"] intValue]];
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%d Coins", [[Coins sharedCoins]totCoin]] style:UIBarButtonItemStylePlain target:nil action:nil];
            
            [item setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:17]} forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = item;
            
        });
    });
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.backButton) {
        UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-44"] style:UIBarButtonItemStylePlain target:self action:@selector(openMenu)];
        [self.navigationItem setLeftBarButtonItem:bar];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
        
    [self setCoins];
    
}

- (void)openMenu{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}



- (IBAction)shareOnFacebook:(id)sender{

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [composeController addURL: [NSURL URLWithString: @"https://itunes.apple.com/app/id756649912"]];
        composeController.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                {

                    break;
                }
            }
        };
            
        [self presentViewController:composeController animated:YES completion:nil];
    
    } else {
    
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"Facebook not available"];
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
        [alert show];
    }
}


- (IBAction)shareOnTwitter:(id)sender{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController addURL: [NSURL URLWithString: @"https://itunes.apple.com/app/id756649912"]];
        
        composeController.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                    
                case SLComposeViewControllerResultCancelled:
                    break;
                    
                case SLComposeViewControllerResultDone:
                    break;
            }
        };
        
        [self presentViewController:composeController animated:YES completion:nil];
        
    } else {
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"Twitter not available"];
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
        [alert show];
    }
}



- (IBAction)moreGames:(id)sender{
    [Tapjoy setViewDelegate:self];
    [Tapjoy showOffersWithViewController:self.parentViewController];
}

- (void)viewWillDisappearWithType:(int)viewType{
    [self setCoins];
}


@end
