//
//  Login.h
//  InstaLiker
//
//  Created by Gui on 22/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tapjoy.h"
#import <AdColony/AdColony.h>

#import "MBProgressHUD.h"


@interface Login : UIViewController <UIWebViewDelegate, AdColonyAdDelegate> {

    IBOutlet UIWebView *web;
    MBProgressHUD *HUD;
    
}




@end
