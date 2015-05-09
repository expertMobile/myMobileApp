//
//  Invite.m
//  InstaLiker
//
//  Created by Gui on 02/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "Invite.h"
#import "Richiesta.h"
#import "Utente.h"
#import "SIAlertView.h"
#import "Coins.h"
#import "REFrostedViewController.h"


@interface Invite ()

@end

@implementation Invite

- (void)viewDidLoad
{
    [super viewDidLoad];

    txt.delegate = self;
}


- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSDictionary *dic = [[Richiesta new]sendRequest:@"invite.php" parameters:@{@"code" : textField.text}];
    
    if (dic[@"coins"]) {
        [[Coins sharedCoins]update:[dic[@"coins"]intValue]];
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Success!" andMessage:@"You received 50 coins!"];
        
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
        [alert show];
        
    } else if (dic[@"gia"]) {
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"You can only enter an invite code once!"];
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
        [alert show];
    } else if (dic[@"err"]) {
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"Wrong invite code!"];
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
        [alert show];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
