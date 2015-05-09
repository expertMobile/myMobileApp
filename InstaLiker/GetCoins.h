//
//  DEMOHomeViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "BlurredButton.h"
#import "MBProgressHUD.h"
#import "TapJoy.h"
#import <AdColony/AdColony.h>
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"


@interface GetCoins : UIViewController <TJCViewDelegate, AdColonyDelegate, AdColonyAdDelegate, IMInterstitialDelegate> {

    
    
    MBProgressHUD *HUD;
    
    IBOutlet UIImageView *img;
    
    IBOutlet UISegmentedControl *segment;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet BlurredButton *skip;
    IBOutlet BlurredButton *like;
    
    IBOutlet BlurredButton *watchVideo;
    
    BlurredButton *skipCopia;
    BlurredButton *likeCopia;
    UIImageView *imgCopia;
    UIImageView *sfondo;
    UILabel *lblNome;
    
    
    IMInterstitial *interstitial;
    
    int countAd;

    NSMutableArray *queueFotoDownload;
    NSMutableArray *queueFotoLike;
    int lastFoto;
    int currentFoto;
    
    BOOL avanti;
    BOOL inDownload;

    
    NSMutableArray *queueFollowerDownload;
    NSMutableArray *queueFollowerLike;
    
    int lastFollower;
    int currentFollower;

    BOOL avantiFollower;
    BOOL inDownloadFollower;
}

- (IBAction)showMenu;


@end
