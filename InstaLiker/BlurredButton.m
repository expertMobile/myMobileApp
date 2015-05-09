//
//  BlurredButton.m
//  InstaLiker
//
//  Created by Gui on 24/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "BlurredButton.h"


@implementation BlurredButton


- (void)setBackgroundColor:(UIColor *)backgroundColor{
    //self.layer.cornerRadius = 4;
    self.tintColor = [UIColor whiteColor];

    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0.95]];
}

@end
