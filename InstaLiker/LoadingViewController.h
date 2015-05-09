//
//  Login2ViewController.h
//  InstaLiker
//
//  Created by Gui on 22/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"
#import <AdColony/AdColony.h>



@interface LoadingViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIImageView *img;
    
    IBOutlet UIButton *login;
    NSTimer *timer;
}

@end
