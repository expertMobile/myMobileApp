//
//  BonusCoins.h
//  InstaLiker
//
//  Created by Gui on 01/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tapjoy.h"
#import "MBProgressHUD.h"

@interface BonusCoins : UIViewController <TJCViewDelegate>
{
    
    MBProgressHUD *HUD;

}

@property (nonatomic, assign) BOOL backButton;


@end
