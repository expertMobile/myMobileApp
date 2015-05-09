//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MenuViewController.h"
#import "GetCoins.h"
#import "UIViewController+REFrostedViewController.h"
#import "NavigationController.h"
#import "Utente.h"
#import "Richiesta.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Cella.h"
#import "GetLikes.h"
#import "BuyCoins.h"
#import "SIAlertView.h"
#import "Settings.h"
#import "SIAlertView.h"
#import "Ask4AppReviews.h"
#import "Coins.h"


@interface MenuViewController ()

@end

@implementation MenuViewController
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.bounds.size.height)];
}


- (void)viewWillAppear:(BOOL)animated{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[Utente sharedUtente]forceGetInfo];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [profileImage sd_setImageWithURL:[NSURL URLWithString:[[Utente sharedUtente]getInfo][@"profile_picture"]]];
            [lblFollowers setText:[[[Utente sharedUtente]getInfo][@"counts"][@"followed_by"]stringValue]];
            [lblFollowing setText:[[[Utente sharedUtente]getInfo][@"counts"][@"follows"]stringValue]];
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.bounds.size.height)];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 260)];
        profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 80, 80)];
        profileImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [profileImage sd_setImageWithURL:[NSURL URLWithString:[[Utente sharedUtente]getInfo][@"profile_picture"]]];
        profileImage.layer.masksToBounds = YES;
        profileImage.layer.cornerRadius = 40;
        profileImage.clipsToBounds = YES;
        
        lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 0, 25)];
        lblUsername.text = [[Utente sharedUtente]getInfo][@"username"];
        lblUsername.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
        lblUsername.backgroundColor = [UIColor clearColor];
        lblUsername.textColor = [UIColor whiteColor];
        [lblUsername sizeToFit];
        lblUsername.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        UIView *dati = [[UIView alloc]initWithFrame:CGRectMake(0, 180, 240, 80)];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, dati.bounds.size.width/3, 20)];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(dati.bounds.size.width/3, 30, dati.bounds.size.width/3, 20)];
        
        UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(dati.bounds.size.width*2/3, 30,dati.bounds.size.width/3, 20)];
        
        
        lblFollowers = [[UILabel alloc]initWithFrame:CGRectMake(lbl.frame.origin.x, 0, lbl.frame.size.width, 30)];
        lblFollowing = [[UILabel alloc]initWithFrame:CGRectMake(lbl3.frame.origin.x, 0, lbl3.frame.size.width, 30)];
        lblPost = [[UILabel alloc]initWithFrame:CGRectMake(lbl2.frame.origin.x, 0, lbl2.frame.size.width, 30)];
        
        
        [lblFollowers setText:[[[Utente sharedUtente]getInfo][@"counts"][@"followed_by"]stringValue]];
        [lblFollowing setText:[[[Utente sharedUtente]getInfo][@"counts"][@"follows"]stringValue]];
        [lblPost setText:[[[Utente sharedUtente]getInfo][@"counts"][@"media"]stringValue]];
        
        
        lblFollowing.textAlignment = NSTextAlignmentCenter;
        lblFollowers.textAlignment = NSTextAlignmentCenter;
        lblPost.textAlignment = NSTextAlignmentCenter;
        
        [lblFollowers setTextColor:[UIColor whiteColor]];
        [lblFollowing setTextColor:[UIColor whiteColor]];
        [lblPost setTextColor:[UIColor whiteColor]];
        
        [lblFollowing setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]];
        [lblFollowers setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]];
        [lblPost setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]];
        
        
        [lbl setText:@"Followers"];
        [lbl2 setText:@"Posts"];
        [lbl3 setText:@"Following"];
        
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl3.textAlignment = NSTextAlignmentCenter;
        
        [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]];
        [lbl2 setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]];
        [lbl3 setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]];
        
        
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl2 setTextColor:[UIColor whiteColor]];
        [lbl3 setTextColor:[UIColor whiteColor]];
        
        
        [dati addSubview:lblFollowers];
        [dati addSubview:lblFollowing];
        [dati addSubview:lblPost];
        [dati addSubview:lbl];
        [dati addSubview:lbl2];
        [dati addSubview:lbl3];
        
        dati.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:profileImage];
        [view addSubview:lblUsername];
        [view addSubview:dati];
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(Cella *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.lbl.textColor = [UIColor whiteColor];
    
    cell.lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    BOOL apriController = YES;
    
    NSInteger indice = indexPath.row;
    
    if (indexPath.section == 0) {
        
        if (indice > 3 && [[Settings sharedInstance][@"inReview"]intValue] ) {
            indice++;
        }
        
        if (indice > 5 && [[Settings sharedInstance][@"inReview"]intValue]) {
            indice++;
        }
        
        
        if (indice == 0) {
            if (!self.getcoins) {
                self.getcoins = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
            }
            navigationController.viewControllers = @[self.getcoins];
            
        } else if (indice == 1) {
            if (!self.getLikes) {
                self.getLikes = [self.storyboard instantiateViewControllerWithIdentifier:@"getLikes"];
            }
            navigationController.viewControllers = @[self.getLikes];
        } else if (indice == 2) {
            
            if (!self.getFollowers) {
                self.getFollowers = [self.storyboard instantiateViewControllerWithIdentifier:@"getFollowers"];
            }
            navigationController.viewControllers = @[self.getFollowers];
            
        } else if (indice == 3) {
            
            BuyCoins *buy = [self.storyboard instantiateViewControllerWithIdentifier:@"buyCoins"];
            buy.skippable = NO;
            
            navigationController.viewControllers = @[buy];
        } else if (indice == 4) {
            
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"bonusCoins"]];
            
        } else if (indice == 5) {
            
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"buyPro"]];
        } else if (indice == 6) {
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"referral"]];
        }
    } else if (indexPath.section == 1) {
        if ([[Settings sharedInstance][@"inReview"]intValue]) {
            if (indice > 0){
            indice++;
            }
        }
        
        if (indice == 0) {
            apriController = NO;
            [Ask4AppReviews rateApp];
        } else if (indice == 1) {
            apriController = NO;
        
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter your pormo code! " message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
            [alert show];

            
            
        } else if (indice == 2) {
            MFMailComposeViewController *co = [[MFMailComposeViewController alloc]init];
            [co setSubject:[NSString stringWithFormat:@"Help [%@ %@] - %@ %@", [[NSBundle mainBundle]infoDictionary][(NSString *)kCFBundleNameKey], [[NSBundle mainBundle]infoDictionary][(NSString *)kCFBundleVersionKey], [[UIDevice currentDevice]model], [[UIDevice currentDevice]systemVersion]]];
            
            [co setToRecipients:@[@"support@guidev.it"]];
            co.mailComposeDelegate = self;
            [self presentViewController:co animated:YES completion:nil];
            
            apriController = NO;
        } else if (indice == 3) {
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"terms"]];

        }
    } else if (indexPath.section == 2) {
        for (NSHTTPCookie * cookie in[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
	        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
		}
	    [[NSUserDefaults standardUserDefaults]removeObjectForKey:[[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
	    [[NSUserDefaults standardUserDefaults]synchronize];

        (void)[[Utente sharedUtente]init];
        (void)[[Settings sharedInstance]init];
        
        [[[UIApplication sharedApplication]delegate]window].rootViewController = [self.storyboard instantiateInitialViewController];
        
    }
    if (apriController) {
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		MBProgressHUD *h = [[MBProgressHUD alloc]init];
        h.mode = MBProgressHUDModeIndeterminate;
		__block NSDictionary *d;
		[h showAnimated:YES whileExecutingBlock: ^{
		    NSString *s = [[[alertView textFieldAtIndex:0]text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
		    d = [[Richiesta new]sendRequest:@"promo.php" parameters:@{ @"b": s }];
		} completionBlock: ^{
		    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:d[@"title"] andMessage:d[@"message"]];
		    [alert addButtonWithTitle:@"Dismiss" type:SIAlertViewButtonTypeCancel handler:nil];
		    [alert show];
            
		    [[Coins sharedCoins]update:[d[@"coins"] intValue]];
		    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d Coins", [[Coins sharedCoins]totCoin]];
		}];
        [self.view.window addSubview:h];
	}
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
 
        if ([[Settings sharedInstance][@"inReview"]intValue]) {
            return 5;
        }
        return 7;
    }
    
    if (sectionIndex == 1) {
        
        if ([[Settings sharedInstance][@"inReview"]intValue]) {
            return 3;
        }
        return 4;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cella";
    
    Cella *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger indice = indexPath.row;
    

    if (indexPath.section == 0) {

        if (indice > 3 && [[Settings sharedInstance][@"inReview"]intValue]) {
            indice++;
        }
        
        if (indice > 5 && [[Settings sharedInstance][@"inReview"]intValue]) {
            indice++;
        }
        
        if (indice == 0) {
            cell.lbl.text = @"Get Coins";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Coins"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 1) {
            cell.lbl.text = @"Get Likes";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Cuore"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 2) {
            cell.lbl.text = @"Get Followers";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Followers"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 3) {
            cell.lbl.text = @"Buy More Coins";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Buy"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 4) {
            cell.lbl.text = @"Bonus Coins";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Bonus"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 5) {
            cell.lbl.text = @"PRO Version";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"PRO"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 6) {
            cell.lbl.text = @"Invite Code";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"money_bag-75"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    } else if (indexPath.section == 1) {
        if ([[Settings sharedInstance][@"inReview"]intValue]) {
            if (indice > 0) {
            indice++;
            }
        }
        if (indice == 0) {
            cell.lbl.text = @"Rate";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Rate"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 1) {
            cell.lbl.text = @"Promo Code";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Coupon"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 2) {
            cell.lbl.text = @"Help & Support";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Support"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if (indice == 3) {
            cell.lbl.text = @"Terms & Conditions";
            [cell.img setTintColor:[UIColor whiteColor]];
            [cell.img setImage:[[UIImage imageNamed:@"Terms"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    } else {
        cell.lbl.text = @"Logout";
        [cell.img setTintColor:[UIColor whiteColor]];
        [cell.img setImage:[[UIImage imageNamed:@"Logout"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    return cell;
}


@end
