//
//  Coins.h
//  InstaLiker
//
//  Created by Gui on 17/11/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Coins : NSObject

@property (nonatomic, assign) int Coins;

+ (Coins *)sharedCoins;
- (int)totCoin;
- (void)update:(int)coin;

@end
