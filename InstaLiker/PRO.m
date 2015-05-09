//
//  PRO.m
//  InstaLiker
//
//  Created by Gui on 01/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "PRO.h"
#import "RMStore.h"
#import "Richiesta.h"
#import "Utente.h"
#import "REFrostedViewController.h"


@interface PRO ()

@end

@implementation PRO


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[RMStore defaultStore]requestProducts:[NSSet setWithObject:@"FULL_InstaLiker"] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
    } failure:^(NSError *errore){
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-44"] style:UIBarButtonItemStylePlain target:self action:@selector(openMenu)];
    [self.navigationItem setLeftBarButtonItem:bar];
    
}

- (void)openMenu{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}


- (IBAction)upgrade:(id)sender{
 	h = [[MBProgressHUD alloc]init];
    h.mode = MBProgressHUDModeIndeterminate;
    h.labelText = @"";
    
	[self.view addSubview:h];
	[h show:YES];
    
    
    
	[[RMStore defaultStore] addPayment:@"FULL_InstaLiker" success: ^(SKPaymentTransaction *transaction) {

        NSString *Identifier = transaction.originalTransaction.transactionIdentifier ? transaction.originalTransaction.transactionIdentifier : transaction.transactionIdentifier;
	        [self performSelectorOnMainThread:@selector(NotificaServer:) withObject:Identifier waitUntilDone:NO];
		
	} failure: ^(SKPaymentTransaction *transaction, NSError *error) {
	    [self updateHud:h withImage:@"error" text:@"An error occurred!" detailText:transaction.error.localizedDescription];
	}];
    
}

- (IBAction)restore:(id)sender{
    h = [[MBProgressHUD alloc]init];
    [self.view addSubview:h];
    [h show:YES];
    [[RMStore defaultStore]restoreTransactionsOnSuccess: ^{
        [[Richiesta new] sendRequest:@"pro.php" parameters:nil];
        [[Utente sharedUtente]setIsPro:YES];
        [self updateHud:h withImage:@"37x-Checkmark.png" text:@"Restored!" detailText:nil];
    } failure: ^(NSError *error) {
        [self updateHud:h withImage:@"error" text:@"An error occurred!" detailText:error.localizedDescription];
    }];
}


- (void)updateHud:(MBProgressHUD *)hud withImage:(NSString *)imageName text:(NSString *)text detailText:(NSString *)detailText {
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = NSLocalizedString(text, @"");
	hud.detailsLabelText = NSLocalizedString(detailText, @"");
	if ([imageName isEqualToString:@"error"]) {
		[hud hide:YES afterDelay:3];
	} else {
		[hud hide:YES afterDelay:1.5];
	}
}


- (void)NotificaServer:(NSString *)ID {
	NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]appStoreReceiptURL]];
	NSString *p = [data base64EncodedStringWithOptions:0];
    
	NSDictionary *dic = [[Richiesta new]sendRequest:@"pro.php" parameters:@{@"b": p }];
    
	if (!dic) {
		dic = [[Richiesta new]sendRequest:@"pro.php" parameters:@{@"b": p}];
	}
    
    

    if ([dic[@"transaction"] isEqualToString:ID]) {
        [[Utente sharedUtente]setIsPro:YES];
        [self updateHud:h withImage:@"37x-Checkmark.png" text:@"Purchased!" detailText:nil];
    }
}


@end
