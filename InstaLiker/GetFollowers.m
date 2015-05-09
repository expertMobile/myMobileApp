//
//  GetFollowers.m
//  InstaLiker
//
//  Created by Gui on 25/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "GetFollowers.h"
#import "CellaSpendi.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FXBlurView.h"
#import "MBProgressHUD.h"
#import "Utente.h"
#import "REFrostedViewController.h"
#import "SIAlertView.h"
#import "Coins.h"
#import "Utente.h"
#import "Richiesta.h"
#import "BuyCoins.h"


@interface GetFollowers ()

@end

@implementation GetFollowers



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-44"] style:UIBarButtonItemStylePlain target:self action:@selector(openMenu)];
    [self.navigationItem setLeftBarButtonItem:bar];
    
    [self setCoins];
}

- (void)setCoins{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        

        NSDictionary *dic = [[Richiesta new]sendRequest:@"login.php" parameters:nil];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[Coins sharedCoins]update:[dic[@"coins"] intValue]];
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%d Coins", [[Coins sharedCoins]totCoin]] style:UIBarButtonItemStylePlain target:self action:@selector(bonusCoins)];
            
            [item setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:17]} forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = item;
            
        });
    });
}

- (void)bonusCoins{
    [Tapjoy setViewDelegate:self];
    [Tapjoy showOffersWithViewController:self.parentViewController];
}

- (void)viewWillDisappearWithType:(int)viewType{
    [self setCoins];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellaSpendi *cell = [tableView dequeueReusableCellWithIdentifier:@"CellaSpendiFollo"];
    cell.backgroundColor = tableView.backgroundColor;
    if (indexPath.row == 0) {
        cell.likes.text = @"5 followers";
        cell.cost.text = @"50 coins";
    } else if (indexPath.row == 1) {
        cell.likes.text = @"10 followers";
        cell.cost.text = @"100 coins";
    } else if (indexPath.row == 2) {
        cell.likes.text = @"20 followers";
        cell.cost.text = @"200 coins";
    } else if (indexPath.row == 3) {
        cell.likes.text = @"50 followers";
        cell.cost.text = @"500 coins";
    } else if (indexPath.row == 4) {
        
        cell.likes.text = @"100 followers";
        cell.cost.text = @"1,000 coins";
    } else if (indexPath.row == 5) {
        cell.likes.text = @"200 followers";
        cell.cost.text = @"2,000 coins";
        
    } else if (indexPath.row == 6) {
        cell.likes.text = @"500 followers";
        cell.cost.text = @"5,000 coins";
        
    } else if (indexPath.row == 7) {
        cell.likes.text = @"1,000 followers";
        cell.cost.text = @"10,000 coins";
    }
    cell.button.tag = indexPath.row;
    
    return cell;
}


- (IBAction)scegli:(id)sender{
    
    
    int tag = (int)((UIButton *)sender).tag;
    int followers = 0;
    
    if (tag == 0) {
        
        followers = 5;
    } else if (tag == 1) {
        followers = 10;
    } else if (tag == 2) {
        followers = 20;
    } else if (tag == 3) {
        followers = 50;
    } else if (tag == 4) {
        followers = 100;
    } else if (tag == 5) {
        followers = 200;
    } else if (tag == 6) {
        followers = 500;
    } else if (tag == 7) {
        followers = 1000;
    }
    
    followers *= 10;
    
    
	NSDictionary *dict = [[Richiesta new] sendRequest:@"f.php" parameters:@{ @"a": [[Utente sharedUtente]getInfo][@"profile_picture"], @"d" : @(followers), @"e" : [[Utente sharedUtente]getInfo][@"username"]}];
    
	if ([dict[@"status"] isEqualToString:@"OK"]) {
		SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Success" andMessage:[NSString stringWithFormat:@"You'll receive %d more followers", followers/10]];
		alert.transitionStyle = SIAlertViewTransitionStyleBounce;
		[alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
		[alert show];
	} else {
		[[Coins sharedCoins]update:[dict[@"coins"] intValue]];
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"You don't have enough coins!"];
        [alert addButtonWithTitle:@"Buy coins" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alert){
            
            BuyCoins *buy = [self.storyboard instantiateViewControllerWithIdentifier:@"buyCoins"];
            buy.backButton = YES;
            
            [self.navigationController pushViewController:buy animated:YES];
        }];
		
        [alert addButtonWithTitle:@"Free coins" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *aleert){
            
            
            
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"bonusCoins"] animated:YES];
        }];
        
		[alert show];
	}
    
    
    [self setCoins];
    
}





- (void)openMenu{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    backgroud.contentMode = UIViewContentModeScaleAspectFill;
    
    profile.layer.cornerRadius = profile.bounds.size.width/2;
    profile.layer.masksToBounds = YES;
    
    
    //    [profile sd_setImageWithURL:[NSURL URLWithString:[[Utente sharedUtente]getInfo][@"profile_picture"]]];
    
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:[[Utente sharedUtente]getInfo][@"profile_picture"]] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                     [profile setImage:image];
                                                     [backgroud setImage:[[self imageDesaturated:image] blurredImageWithRadius:30 iterations:30 tintColor:[UIColor blackColor]]];
                                                 }];
    
    lblFollower.layer.cornerRadius = 4;
    
    [lblFollower setText:[NSString stringWithFormat:@"%@ followers", [[Utente sharedUtente]getInfo][@"counts"][@"followed_by"]]];
    
}


-(UIImage*) imageDesaturated:(UIImage *)img {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciimage = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:ciimage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:4] forKey:@"inputSaturation"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    
    UIImage *immagine = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return immagine;
}



@end
