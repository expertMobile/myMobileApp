//
//  DEMOMenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "GetCoins.h"
#import "GetLikes.h"
#import "GetFollowers.h"
@import MessageUI;


@interface MenuViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    UIImageView *profileImage;
    UILabel *lblUsername;
    UILabel *lblFollowers;
    UILabel *lblFollowing;
    UILabel *lblPost;
}

@property (nonatomic, strong) GetCoins *getcoins;
@property (nonatomic, strong) GetLikes *getLikes;
@property (nonatomic, strong) GetFollowers *getFollowers;
@end
