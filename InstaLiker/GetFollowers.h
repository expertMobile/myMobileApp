//
//  GetFollowers.h
//  InstaLiker
//
//  Created by Gui on 25/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapJoy.h"


@interface GetFollowers : UIViewController <UITableViewDelegate, UITableViewDataSource, TJCViewDelegate>
{
    IBOutlet UITableView *tbl;
    IBOutlet UIImageView *profile;
    IBOutlet UIImageView *backgroud;
    IBOutlet UILabel *lblFollower;
}

@end
