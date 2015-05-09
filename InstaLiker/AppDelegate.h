//
//  AppDelegate.h
//  InstaLiker
//
//  Created by Gui on 17/11/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdColony/AdColony.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDelegate, AdColonyDelegate>
{
	NSMutableData *dataRicevuti;
}

@property (strong, nonatomic) UIWindow *window;



@end
