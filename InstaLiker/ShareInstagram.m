//
//  ShareInstagram.m
//  InstaLiker
//
//  Created by Gui on 01/05/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "ShareInstagram.h"
#import "Coins.h"
#import "MBProgressHUD.h"
#import "Richiesta.h"
#import "Utente.h"
#import "Settings.h"
#import "SIAlertView.h"
#import "UIBezierPath+IOS7RoundedRect.h"


@interface ShareInstagram ()

@end

@implementation ShareInstagram



- (IBAction)share:(UIButton *)sender{
    

	MBProgressHUD *hud = [[MBProgressHUD alloc]init];
	hud.mode = MBProgressHUDModeIndeterminate;
	[self.view addSubview:hud];
    
	__block NSDictionary *dic;
    
	[hud showAnimated:YES whileExecutingBlock: ^{
	    dic = [[Richiesta new]sendRequest:@"s.php" parameters:nil];
	} completionBlock: ^{
	    if ([dic[@"status"] isEqualToString:@"OK"]) {
	        if (!_documentController) {
	            _documentController = [[UIDocumentInteractionController alloc]init];
			}
	        [_documentController setURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"DaCondividere" ofType:@"igo"]]];
	        _documentController.annotation = @{ @"InstagramCaption": [Settings sharedInstance][@"caption"] };
	        [_documentController setUTI:@"com.instagram.photo"];
	        _documentController.delegate = self;
	        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	            [_documentController presentOpenInMenuFromRect:sender.frame inView:self.view animated:YES];
			}
	        else {
	            [_documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
			}
		}
	    else {
	        SIAlertView *a = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"You can share this image only once a day!"];
	        a.transitionStyle = SIAlertViewTransitionStyleBounce;
            
	        [a addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler: ^(SIAlertView *alert) {
	            [self.navigationController popToRootViewControllerAnimated:YES];
			}];
	        [a show];
		}
	}];
}


- (void)imageView:(UIImageView *)image{



    UIImageView *icona = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iTunesArtwork"]];

    [image addSubview:icona];

    float cornerRadius = 40;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cornerRadius = 40*1.46;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithIOS7RoundedRect:icona.bounds cornerRadius:cornerRadius];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = icona.bounds;
    maskLayer.path = path.CGPath;
    icona.layer.mask = maskLayer;
    
    
    UIImage *newImage;
    
    UIGraphicsBeginImageContext(icona.frame.size);

    [icona drawViewHierarchyInRect:icona.frame afterScreenUpdates:YES];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
 
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    

    
    
}


- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
	[[UIApplication sharedApplication]cancelAllLocalNotifications];
    
	int day = 60 * 24 * 60;
    
	for (int k = 1; k <  30; k++) {
		UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        
		localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:day * k];
		localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        
		localNotif.alertBody = @"Share our photo for your daily free coins!";
		localNotif.alertAction = @"Open App";
		localNotif.soundName = UILocalNotificationDefaultSoundName;
		localNotif.applicationIconBadgeNumber = 1;
        
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
	}
    
    
	[[Coins sharedCoins]update:[[Coins sharedCoins]totCoin] + 75];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
