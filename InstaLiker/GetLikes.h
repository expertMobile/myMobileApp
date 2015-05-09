//
//  Collection.h
//  InstaLiker
//
//  Created by Gui on 24/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "TapJoy.h"

@interface GetLikes : UICollectionViewController <TJCViewDelegate>


{

    NSMutableArray *arr;
    UIRefreshControl *refreshControl;

    NSString *nextUrl;
}


@end
