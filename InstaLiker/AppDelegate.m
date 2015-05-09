//  AppDelegate.m
//  InstaLiker
//
//  Created by Gui on 17/11/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import "AppDelegate.h"
#import "Coins.h"
#import <Crashlytics/Crashlytics.h>
#import <RevMobAds/RevMobAds.h>
#import "SIAlertView.h"
#import "Richiesta.h"
#import "Utente.h"
#import "RMStore.h"
#import <RNDecryptor.h>
#import "Settings.h"
#import "Ask4AppReviews.h"
#import "TapJoy.h"
#import <RevMobAds/RevMobAds.h>
#import "InMobi.h"
#import <sys/utsname.h>



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[NSUserDefaults standardUserDefaults]setValue:@"OI" forKey:@"IO"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    

    
    [[SIAlertView appearance]setTransitionStyle:SIAlertViewTransitionStyleBounce];
    
    if ([[Settings sharedInstance][@"adColony"][@"active"]boolValue]) {
        [AdColony configureWithAppID:[Settings sharedInstance][@"adColony"][@"app"] zoneIDs:@[[Settings sharedInstance][@"adColony"][@"login"], [Settings sharedInstance][@"adColony"][@"button"]] delegate:self logging:YES];
        [AdColony setCustomID:[[Utente sharedUtente]ID]];
    }
    
    
    [InMobi initialize:[Settings sharedInstance][@"inMobi"][@"id"]];
    
    if ([[Settings sharedInstance][@"revMob"][@"active"]boolValue] && ![[Utente sharedUtente]isPro]) {
        [RevMobAds startSessionWithAppID:[Settings sharedInstance][@"revMob"][@"client"]];
        [[RevMobAds session]setParallaxMode:RevMobParallaxModeWithBackground];
    }
    

    
    [Tapjoy requestTapjoyConnect:[Settings sharedInstance][@"tapJoy"][@"connect"] secretKey:[Settings sharedInstance][@"tapJoy"][@"secret"]];
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_6 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B651 Safari/9537.53", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    
	if (![[[UIApplication sharedApplication]scheduledLocalNotifications]count]) {
		NSDateComponents *comp = [[NSDateComponents alloc]init];
		[comp setHour:17];
        
		int day = 60 * 60 * 24;
        
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
	}
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    NSDictionary *lcl = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
	if (lcl) {
		NSDictionary *Info = lcl[@"dati"];
		if ([[Info allKeys]count]) {
			NSString *URL = [Info valueForKey:@"URL"];
            
			SIAlertView *alert = [[SIAlertView alloc]initWithTitle:[Info valueForKey:@"1"] andMessage:[Info valueForKey:@"2"]];
            
			[alert addButtonWithTitle:[Info valueForKey:@"3"] type:SIAlertViewButtonTypeCancel handler:nil];
			[alert addButtonWithTitle:[Info valueForKey:@"4"] type:SIAlertViewButtonTypeDestructive handler: ^(SIAlertView *al) {
			    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL]];
			}];
			[alert show];
		}
	}
    
	[[NSUserDefaults standardUserDefaults]synchronize];
    
    UIViewController *initialViewController = [[self storyboard] instantiateInitialViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController  = initialViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (UIStoryboard *)storyboard{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIStoryboard storyboardWithName:@"Storyboard-iPad" bundle:nil];
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        return [UIStoryboard storyboardWithName:@"Storyboard-iPhone4S" bundle:nil];
    }
    
    return [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
}

- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString*) zoneID {
    
    if ([zoneID isEqualToString:[Settings sharedInstance][@"adColony"][@"login"]]) {
        if (available && [[[Utente sharedUtente]ID]length] && [[[NSUserDefaults standardUserDefaults]valueForKey:@"IO"]isEqualToString:@"OI"] && ![[Settings sharedInstance][@"inReview"]intValue]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"AA" forKey:@"IO"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pronto" object:nil];
        }
    } else {
        if (available) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoButtonDisponibile" object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoButtonNonDisponibile" object:nil];
        }
    }
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSDictionary *Info = userInfo[@"dati"];
	if ([[Info allKeys]count]) {
		NSString *URL = [Info valueForKey:@"URL"];
		SIAlertView *alert = [[SIAlertView alloc]initWithTitle:[Info valueForKey:@"1"] andMessage:[Info valueForKey:@"2"]];
		[alert addButtonWithTitle:[Info valueForKey:@"3"] type:SIAlertViewButtonTypeCancel handler:nil];
		[alert addButtonWithTitle:[Info valueForKey:@"4"] type:SIAlertViewButtonTypeDestructive handler: ^(SIAlertView *al) {
		    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL]];
		}];
		[alert show];
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSString *Token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	if ([[Utente sharedUtente]ID]) {
        
		NSDictionary *dic = [[Richiesta new]sendRequest:@"login.php" parameters:@{@"b" : Token }];
        
		if ([dic[@"status"] isEqualToString:@"OK"]) {
			[[Coins sharedCoins]update:[dic[@"coins"] intValue]];
			[[Utente sharedUtente]setIsPro:[dic[@"pro"] boolValue]];
		}
	}
	[[NSUserDefaults standardUserDefaults]setValue:Token forKey:@"TokenPush"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}



- (void)applicationWillEnterForeground:(UIApplication *)application{
    [Ask4AppReviews appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}




@end
