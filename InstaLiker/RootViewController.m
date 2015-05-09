//
//  RootViewController.m
//  
//
//  Created by Gui on 23/04/14.
//
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib {
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    self.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.menuViewSize = CGSizeMake(380, self.view.bounds.size.height);
        self.backgroundFadeAmount = 0.7;
    }
    

}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

@end
