//
//  Termini.m
//  InstaLiker
//
//  Created by Gui on 02/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "Termini.h"
#import "Settings.h"
#import "REFrostedViewController.h"

@interface Termini ()

@end

@implementation Termini

- (void)viewDidLoad {
    [super viewDidLoad];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Settings sharedInstance][@"terms"]]]];
}

- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}



@end
