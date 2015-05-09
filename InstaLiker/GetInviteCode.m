//
//  GetInviteCode.m
//  InstaLiker
//
//  Created by Gui on 02/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "GetInviteCode.h"
#import "Richiesta.h"
#import "Utente.h"
#import "SIAlertView.h"
#import "Settings.h"


@interface GetInviteCode ()

@end

@implementation GetInviteCode



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSDictionary *d = [[Richiesta new]sendRequest:@"codeInvite.php" parameters:nil];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [code setText:d[@"code"]];
        });
    });
}



- (IBAction)copia:(id)sender{
    [[UIPasteboard generalPasteboard]setString:code.text];
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Success" andMessage:@"Copied!"];
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
    [alert show];
}


- (IBAction)share:(id)sender{
    NSString *meesage =  [NSString stringWithFormat:[Settings sharedInstance][@"invite"], code.text];

    UIActivityViewController *act = [[UIActivityViewController alloc]initWithActivityItems:@[meesage] applicationActivities:nil];
    [self presentViewController:act animated:YES completion:nil];
}


@end
