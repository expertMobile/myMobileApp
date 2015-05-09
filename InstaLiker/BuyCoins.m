//
//  PurchaseCoins.m
//  InstaLiker
//
//  Created by Gui on 25/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "BuyCoins.h"
#import "SpendCoins.h"
#import "RMStore.h"
#import "MBProgressHUD.h"
#import "REFrostedViewController.h"
#import "Richiesta.h"
#import "Utente.h"
#import "Coins.h"
#import "Settings.h"

@interface BuyCoins ()

@end

@implementation BuyCoins


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (self.skippable) {
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
            top.constant = 100;
            bottom.constant = 100;
        } else {
            top.constant = 50;
            bottom.constant = 50;
        }
    }
}


- (void)updateViewConstraints{
    [super updateViewConstraints];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && self.skippable) {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            top.constant = 100;
            bottom.constant = 100;
        } else {
            top.constant = 50;
            bottom.constant = 50;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    if (!self.backButton) {
        UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-44"] style:UIBarButtonItemStylePlain target:self action:@selector(openMenu)];
        [self.navigationItem setLeftBarButtonItem:bar];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    [self setCoins];
}

- (void)setCoins{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        

        
        NSDictionary *dic = [[Richiesta new]sendRequest:@"login.php" parameters:nil];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[Coins sharedCoins]update:[dic[@"coins"] intValue]];
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%d Coins", [[Coins sharedCoins]totCoin]] style:UIBarButtonItemStylePlain target:self action:@selector(bonusCoins)];
            
            [item setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:17]} forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = item;
            
        });
    });
}

- (void)bonusCoins{
    [Tapjoy setViewDelegate:self];
    [Tapjoy showOffersWithViewController:self.parentViewController];
}
- (void)viewWillDisappearWithType:(int)viewType{
    [self setCoins];
}


- (void)openMenu{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.skippable) {
        skip.hidden = YES;
    }
    
    
    h = [[MBProgressHUD alloc]init];
    
    h.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:h];
    
    [h show:YES];
    
    prodotti = [Settings sharedInstance][@"inApp"];
    
    [cento setTitle:[prodotti[0] stringByReplacingOccurrencesOfString:@"coins." withString:@""] forState:UIControlStateNormal];
    [cinquecento setTitle:[prodotti[1] stringByReplacingOccurrencesOfString:@"coins." withString:@""] forState:UIControlStateNormal];
    [duemilacinquecento setTitle:[prodotti[2] stringByReplacingOccurrencesOfString:@"coins." withString:@""] forState:UIControlStateNormal];
    [diecimila setTitle:[prodotti[3] stringByReplacingOccurrencesOfString:@"coins." withString:@""] forState:UIControlStateNormal];
    [ventimila setTitle:[prodotti[4] stringByReplacingOccurrencesOfString:@"coins." withString:@""] forState:UIControlStateNormal];
    
    NSLog(@"%@", prodotti);
    
    
    [[RMStore defaultStore]requestProducts:[NSSet setWithArray:prodotti] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
	    NSArray *prod = [products sortedArrayUsingComparator: ^(id a, id b) {
	        NSDecimalNumber *first = [(SKProduct *)a price];
	        NSDecimalNumber *second = [(SKProduct *)b price];
	        return [first compare:second];
		}];
        
	    [cento setTitle:[NSString stringWithFormat:@"%@ COINS FOR %@", [prodotti[0]stringByReplacingOccurrencesOfString:@"coins." withString:@""], [RMStore localizedPriceOfProduct:prod[0]]] forState:UIControlStateNormal];
	    [cinquecento setTitle:[NSString stringWithFormat:@"%@ COINS FOR %@",[prodotti[1]stringByReplacingOccurrencesOfString:@"coins." withString:@""], [RMStore localizedPriceOfProduct:prod[1]]] forState:UIControlStateNormal];
	    [duemilacinquecento setTitle:[NSString stringWithFormat:@"%@ COINS FOR %@", [prodotti[2]stringByReplacingOccurrencesOfString:@"coins." withString:@""],[RMStore localizedPriceOfProduct:prod[2]]] forState:UIControlStateNormal];
	    [diecimila setTitle:[NSString stringWithFormat:@"%@ COINS FOR %@",[prodotti[3]stringByReplacingOccurrencesOfString:@"coins." withString:@""], [RMStore localizedPriceOfProduct:prod[3]]] forState:UIControlStateNormal];
        [ventimila setTitle:[NSString stringWithFormat:@"%@ COINS FOR %@",[prodotti[4]stringByReplacingOccurrencesOfString:@"coins." withString:@""], [RMStore localizedPriceOfProduct:prod[4]]] forState:UIControlStateNormal];
        [h hide:YES];
	} failure:^(NSError *error){
        
        NSLog(@"%@", error);
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)Compra:(BlurredButton *)sender {
	
    NSString *prodotto;
    
    if (sender == cento) {
        
        prodotto = prodotti[0];
    } else if (sender == cinquecento) {
        prodotto = prodotti[1];
    } else if (sender == duemilacinquecento) {
        prodotto = prodotti[2];
    } else if (sender == diecimila) {
        prodotto = prodotti[3];
    } else if (sender == ventimila) {
        prodotto = prodotti[4];
    }
    
    h = [[MBProgressHUD alloc]init];

	h.mode = MBProgressHUDModeIndeterminate;
	[h show:YES];
    [self.view addSubview:h];
    
    
	[[RMStore defaultStore] addPayment:prodotto success: ^(SKPaymentTransaction *transaction) {

        NSString *Identifier = transaction.originalTransaction.transactionIdentifier ? transaction.originalTransaction.transactionIdentifier : transaction.transactionIdentifier;
	        [self performSelectorOnMainThread:@selector(NotificaServer:) withObject:@[Identifier, prodotto] waitUntilDone:NO];
		
	} failure: ^(SKPaymentTransaction *transaction, NSError *error) {
	    [self updateHud:h withImage:@"error" text:@"An error occurred!" detailText:transaction.error.localizedDescription];
	}];
}

- (void)NotificaServer:(NSArray *)ID {
	NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]appStoreReceiptURL]];
	NSString *p = [data base64EncodedStringWithOptions:0];
    
	NSDictionary *dic = [[Richiesta new]sendRequest:@"compraCoin.php" parameters:@{@"b" : p, @"c" : ID[0], @"d" : ID[1] }];
    
	if (!dic) {
		dic = [[Richiesta new]sendRequest:@"compraCoin.php" parameters:@{@"b" : p, @"c" : ID[0], @"d" : ID[1] }];
	}
    
    
    if ([dic[@"transaction"] isEqualToString:ID[0]]) {
        [self setCoins];
        [self updateHud:h withImage:@"37x-Checkmark.png" text:@"Purchased!" detailText:nil];
    }
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpendCoins *spend = (SpendCoins *)[segue destinationViewController];
    spend.photo = self.photo;
    
}


@end
