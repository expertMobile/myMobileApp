//
//  ShareInstagram.h
//  InstaLiker
//
//  Created by Gui on 01/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareInstagram : UIViewController <UIDocumentInteractionControllerDelegate>



@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@end
