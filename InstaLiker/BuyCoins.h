//
//  PurchaseCoins.h
//  InstaLiker
//
//  Created by Gui on 25/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurredButton.h"
#import "MBProgressHUD.h"
#import "Tapjoy.h"

@interface BuyCoins : UIViewController <TJCViewDelegate>
{

    IBOutlet BlurredButton *cento;
    
    IBOutlet BlurredButton *cinquecento;
    
    IBOutlet BlurredButton *duemilacinquecento;
    
    IBOutlet BlurredButton *diecimila;
    
    IBOutlet BlurredButton *ventimila;
    
    IBOutlet BlurredButton *skip;
    
    IBOutlet NSLayoutConstraint *top;
    IBOutlet NSLayoutConstraint *bottom;
    
    
    MBProgressHUD *h;
    NSArray *prodotti;
}

@property (nonatomic, assign) BOOL skippable;

@property (nonatomic, strong) NSDictionary *photo;

@property (nonatomic, assign) BOOL backButton;

@end
