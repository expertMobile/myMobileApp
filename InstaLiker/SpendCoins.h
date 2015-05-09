//
//  SpendCoins.h
//  InstaLiker
//
//  Created by Gui on 25/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapJoy.h"


@interface SpendCoins : UIViewController <UITableViewDataSource, UITableViewDelegate, TJCViewDelegate> {
    IBOutlet UIImageView *img;
    IBOutlet UITableView *tbl;
    IBOutlet UILabel *lbl;
    IBOutlet UIImageView *blurred;
}

@property (nonatomic, strong) NSDictionary *photo;

@end
