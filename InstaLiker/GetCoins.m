//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "GetCoins.h"
#import "Richiesta.h"
#import "Utente.h"
#import "MenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FXBlurView.h"
#import "GetLikes.h"
#import "SIAlertView.h"
#import "BuyCoins.h"
#import "Settings.h"
#import "Coins.h"
#import <AdColony/AdColony.h>
#import <RevMobAds/RevMobAds.h>
#import "Ask4AppReviews.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SDWebImagePrefetcher.h"
#import "Login.h"
#import <sys/utsname.h>


@import Accounts;
@import Social;
@import Twitter;


@interface GetCoins ()

@end

@implementation GetCoins

- (NSString *)device{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *)systemVersion{
    return [[[UIDevice currentDevice]systemVersion]stringByReplacingOccurrencesOfString:@"." withString:@"_"];
}

- (IBAction)showMenu{
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setCoins];
    
    if (scroll.contentOffset.x == 0) {
        segment.selectedSegmentIndex = 0;
    } else {
        segment.selectedSegmentIndex = 1;
    }
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

- (IBAction)cambioSegmented:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        [scroll scrollRectToVisible:CGRectMake(0, 0, scroll.bounds.size.width, 10) animated:YES];
        
        for (int k = currentFoto; k < [queueFotoDownload count]; k++) {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:queueFotoDownload[k][@"URL"]]
                                                            options:SDWebImageLowPriority
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {}];
            
        }

    } else {
        [scroll scrollRectToVisible:CGRectMake(scroll.bounds.size.width, 0, scroll.bounds.size.width, 10) animated:YES];
    
        for (int k = currentFollower; k < [queueFollowerDownload count]; k++) {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:queueFollowerDownload[k][@"URL"]]
                                                            options:SDWebImageLowPriority
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {}];
            
        }
    }
}

- (BlurredButton *)copia:(BlurredButton *)button{
    BlurredButton *b = [[BlurredButton alloc]initWithFrame:button.frame];
    [b setBackgroundColor:button.backgroundColor];
    [b setTitle:button.titleLabel.text forState:UIControlStateNormal];
    [b setTitleColor:button.titleLabel.textColor forState:UIControlStateNormal];
    [b.titleLabel setFont:button.titleLabel.font];
    return b;
}

- (void)viewDidLayoutSubviews{
    [scroll setContentSize:CGSizeMake(scroll.bounds.size.width * 2, scroll.bounds.size.height)];
}



- (NSString *)parametriCriptati:(NSString *)parametri{
    
    NSString *salt = [Settings sharedInstance][@"InstagramHash"];
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [parametri dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    return [[[[hash description]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
}

- (void)queueLikes{
    
    while (1) {
        
        if ([queueFotoLike count]>0) {
            
            NSString *foto = queueFotoLike[0][@"ID_Photo"];
            
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", foto, [[Utente sharedUtente]token]]]];
            
            [req setHTTPMethod:@"POST"];
            
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:0 error:nil];
            if ([d[@"meta"][@"code"]intValue]==200){
            
                [[Richiesta new]sendRequest:@"liked.php" parameters:@{@"Photo" : queueFotoLike[0][@"Link"]}];
                
                sleep(2);
            } else {
                
                [[Richiesta new]sendRequest:@"likeFailed.php" parameters:@{@"Photo" : queueFotoLike[0][@"Link"]}];
                sleep(20);
            }
            [queueFotoLike removeObjectAtIndex:0];
        }
        sleep(2);
    }
}




- (void)queueFollows{
    
    while (1) {
        
        if ([queueFollowerLike count]>0) {
            
            
            NSString *foll = queueFollowerLike[0][@"ID_Follower"];
            
            
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/users/%@/relationship?access_token=%@", foll, [[Utente sharedUtente]token]]]];
            
            [req setHTTPMethod:@"POST"];
            [req setHTTPBody:[@"action=follow" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:0 error:nil];
            
            
            if ([d[@"meta"][@"code"]intValue]==200){
                

                [[Richiesta new]sendRequest:@"followed.php" parameters:@{@"Followed" : foll}];
                
                sleep(2);
            } else {
                
                [[Richiesta new]sendRequest:@"followFailed.php" parameters:@{@"Followed" : foll}];
                sleep(20);
            }
            [queueFollowerLike removeObjectAtIndex:0];
        }
        sleep(2);
    }
}



- (void)viewDidLoad{
    
    lastFoto = 0;
    currentFoto = 0;
    queueFotoDownload = [NSMutableArray new];
    queueFotoLike = [NSMutableArray new];
    
    
    lastFollower = 0;
    currentFollower = 0;
    queueFollowerDownload = [NSMutableArray new];
    queueFollowerLike = [NSMutableArray new];
    
    
    
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(queueLikes) withObject:nil];
    [self performSelectorInBackground:@selector(queueFollows) withObject:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLogin) name:@"pronto" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoButtonDisponibile) name:@"videoButtonDisponibile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoButtonNonDisponibile) name:@"videoButtonNonDisponibile" object:nil];
    
    
    if (![[Settings sharedInstance][@"inReview"]intValue]) {
        watchVideo.hidden = NO;
    } else {
        watchVideo.hidden = YES;
    }
    
    likeCopia = [self copia:like];
    [likeCopia setFrame:CGRectMake(like.frame.origin.x + scroll.bounds.size.width, like.frame.origin.y, like.frame.size.width, like.frame.size.height)];
    [likeCopia setTitle:@"FOLLOW" forState:UIControlStateNormal];
    [likeCopia addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    
    [scroll addSubview:likeCopia];
    
    skipCopia = [self copia:skip];
    [skipCopia setFrame:CGRectMake(skip.frame.origin.x + scroll.bounds.size.width, skip.frame.origin.y, skip.frame.size.width, skip.frame.size.height)];
    [skipCopia addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    
    sfondo = [[UIImageView alloc]initWithFrame:CGRectMake(img.frame.origin.x + scroll.bounds.size.width, img.frame.origin.y, img.bounds.size.width, img.bounds.size.height)];
    
    imgCopia = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
    imgCopia.layer.cornerRadius = imgCopia.bounds.size.width/2;
    imgCopia.layer.borderColor = [[UIColor whiteColor]CGColor];
    imgCopia.layer.borderWidth = 4;
    imgCopia.layer.masksToBounds = YES;
    imgCopia.center = CGPointMake(sfondo.center.x - scroll.bounds.size.width - 10, sfondo.center.y - 30);
    
    
    lblNome = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    lblNome.center = CGPointMake(imgCopia.center.x, imgCopia.center.x + 85);
    lblNome.textAlignment = NSTextAlignmentCenter;
    lblNome.textColor = [UIColor whiteColor];
    lblNome.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
    
    [sfondo addSubview:lblNome];
    [sfondo addSubview:imgCopia];
    [scroll addSubview:sfondo];
    [scroll addSubview:skipCopia];
    
    
    MenuViewController *menu = (MenuViewController *)self.frostedViewController.menuViewController;
    menu.getcoins = self;
   
    if (![[Utente sharedUtente]isPro]) {
        interstitial = [[IMInterstitial alloc] initWithAppId:[Settings sharedInstance][@"inMobi"][@"id"]];
        interstitial.delegate = self;
    }
    
    
    MBProgressHUD *d = [[MBProgressHUD alloc]init];
    d.mode = MBProgressHUDModeIndeterminate;
    
    __block NSDictionary *k;
    [d showAnimated:YES whileExecutingBlock:^{
        
        k = [[Utente sharedUtente]getInfo];

    } completionBlock:^{
        if (!k) {
            SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"Your instagram profile is private, your profile must be public in order to use this app!"];
            [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alert){
                exit(0);
            }];
            [alert show];
        }
    }];
    
    [img sd_setImageWithURL:[self prossimaFoto] placeholderImage:[UIImage imageNamed:@"Loading"]];
    
    NSDictionary *prossimoFollower = [self prossimoFollower];
    
    [imgCopia sd_setImageWithURL:prossimoFollower[@"URL"] placeholderImage:[UIImage imageNamed:@"Loading"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [sfondo setImage:[image blurredImageWithRadius:20 iterations:20 tintColor:[UIColor blackColor]]];
    }];
    
    [self.view addSubview:d];
}


- (void)videoButtonDisponibile{
    [UIView animateWithDuration:0.3 animations:^{
        [watchVideo setTitle:@"Watch a video" forState:UIControlStateNormal];
    }];
}


- (void)videoButtonNonDisponibile{
    [UIView animateWithDuration:0.3 animations:^{
        [watchVideo setTitle:@"Bonus Coins" forState:UIControlStateNormal];
    }];
}


- (void)videoLogin{
    [AdColony playVideoAdForZone:[Settings sharedInstance][@"adColony"][@"login"] withDelegate:self];
}


- (void)onAdColonyV4VCReward:(BOOL)success currencyName:(NSString *)currencyName currencyAmount:(int)amount inZone:(NSString *)zoneID{
    [self setCoins];
}



- (void)interstitialDidReceiveAd:(IMInterstitial *)ad{
    
    if (![[Utente sharedUtente]isPro]) {
        if (ad.state == kIMInterstitialStateReady) {
            [ad presentInterstitialAnimated:YES];
        }
    }
}

- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error{
    if (![[Utente sharedUtente]isPro]) {
        [[RevMobAds session]showFullscreen];
    }
}




- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.interfaceOrientation;
}

- (void)mostraInterstitial{
 
    [interstitial loadInterstitial];
    
}






- (void)downloadImageInBackground{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        inDownload = YES;
        
        NSDictionary *dic = [[Richiesta new]sendRequest:@"photoList.php" parameters:@{@"lastID" : @(lastFoto)}];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            for (NSDictionary *d in dic[@"nextPhoto"]) {
                
                [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:d[@"URL"]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {}];
                
                if ([d[@"ID"]intValue]>0) {
                    lastFoto = [d[@"ID"]intValue];
                }
            }
            
            [queueFotoDownload addObjectsFromArray:dic[@"nextPhoto"]];
            
            inDownload = NO;
            
            if (avanti) {
                [img sd_setImageWithURL:[self prossimaFoto] placeholderImage:[UIImage imageNamed:@"Loading"]];
            }
        });
    });
}


- (void)downloadFollowerInBackground{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        inDownloadFollower = YES;
        
        NSDictionary *dic = [[Richiesta new]sendRequest:@"followerList.php" parameters:@{@"lastID" : @(lastFollower)}];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            for (NSDictionary *d in dic[@"nextFollower"]) {
                
                [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:d[@"URL"]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {}];
                
                if ([d[@"ID"]intValue]>0) {
                    lastFollower = [d[@"ID"]intValue];
                }
            }
            
            [queueFollowerDownload addObjectsFromArray:dic[@"nextFollower"]];
            
            inDownloadFollower = NO;
            
            if (avantiFollower) {
                NSDictionary *prossimoFollower = [self prossimoFollower];
                [imgCopia sd_setImageWithURL:prossimoFollower[@"URL"] placeholderImage:[UIImage imageNamed:@"Loading"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [sfondo setImage:[image blurredImageWithRadius:20 iterations:20 tintColor:[UIColor blackColor]]];
                }];
                
                CGPoint centro = lblNome.center;
                [lblNome setText:prossimoFollower[@"username"]];
                [lblNome sizeToFit];
                lblNome.center = centro;
            }
        });
    });
}


- (NSURL *)prossimaFoto{
    avanti = NO;
    
    if (currentFoto >= [queueFotoDownload count]) {
        // Non ne ho più: devo aspettare far aspettare il download
        avanti = YES;
        
        if (!inDownload) {
            [self downloadImageInBackground];
        }
        
        return [[NSBundle mainBundle]URLForResource:@"Loading@2x" withExtension:@"png"];
    }
    
    
    if ([queueFotoDownload count] - currentFoto <= 2) {
        if (!inDownload) {
            inDownload = YES;
            [self downloadImageInBackground];
        }
    }
    
    return queueFotoDownload[currentFoto++][@"URL"];
    
}

- (NSDictionary *)prossimoFollower{
    avantiFollower = NO;
    
    if (currentFollower >= [queueFollowerDownload count]) {
        // Non ne ho più: devo aspettare far aspettare il download
        avantiFollower = YES;
        
        if (!inDownloadFollower) {
            [self downloadFollowerInBackground];
        }
        
        return @{@"URL" : [[NSBundle mainBundle]URLForResource:@"Loading@2x" withExtension:@"png"], @"username" : @""};
    }
    
    
    if ([queueFollowerDownload count] - currentFollower <= 2) {
        if (!inDownloadFollower) {
            inDownloadFollower = YES;
            [self downloadFollowerInBackground];
        }
    }
    return queueFollowerDownload[currentFollower++];
}



- (IBAction)like:(id)sender{
    [img sd_setImageWithURL:[self prossimaFoto] placeholderImage:[UIImage imageNamed:@"Loading"] options:SDWebImageHighPriority];

    
    if (currentFoto % ([[Settings sharedInstance][@"ads"]intValue] - arc4random_uniform(2)) == 0) {
        
        [self mostraInterstitial];
    }

    if (sender == like && currentFoto < [queueFotoDownload count]) {
        
        HUD = [[MBProgressHUD alloc]init];
        [self.view addSubview:HUD];
        __block NSDictionary *dic;
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            dic = [[Richiesta new]sendRequest:@"like.php" parameters:nil];
            
        } completionBlock:^{
            
            if ([dic[@"status"]isEqualToString:@"OK"]) {
                [[Coins sharedCoins]update:[dic[@"coins"] intValue]];
                self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d Coins", [[Coins sharedCoins]totCoin]];
                if ([queueFotoDownload[currentFoto - 2][@"ID"]intValue]) {
                    [queueFotoLike addObject:queueFotoDownload[currentFoto - 2]];
                }
                
            } else {
                if ([dic[@"limit"]intValue]) {

                [self alertPerCodiceErrore:[dic[@"errore"]intValue] andLimit:[dic[@"limit"]intValue]];
                }
            }
        }];
    }
    
}




- (void)follow:(id)sender{
    
    NSDictionary *prossimoFollower = [self prossimoFollower];
    
    [imgCopia sd_setImageWithURL:prossimoFollower[@"URL"] placeholderImage:[UIImage imageNamed:@"Loading"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [sfondo setImage:[image blurredImageWithRadius:20 iterations:20 tintColor:[UIColor blackColor]]];
    }];
    
    CGPoint centro = lblNome.center;
    [lblNome setText:prossimoFollower[@"username"]];
    [lblNome sizeToFit];
    lblNome.center = centro;
    
    if (currentFollower % ([[Settings sharedInstance][@"ads"]intValue] - arc4random_uniform(2)) == 0) {
        [self mostraInterstitial];
    }
    
    if (sender == likeCopia && currentFollower < [queueFollowerDownload count]) {
        
        HUD = [[MBProgressHUD alloc]init];
        [scroll addSubview:HUD];
        
        __block NSDictionary *dic;
        
        [HUD showAnimated:YES whileExecutingBlock:^{
          
            dic = [[Richiesta new]sendRequest:@"follow.php" parameters:nil];
            
        } completionBlock:^{
            
            if ([dic[@"status"]isEqualToString:@"OK"]) {
                [[Coins sharedCoins]update:[dic[@"coins"]intValue]];
                self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d Coins", [[Coins sharedCoins]totCoin]];

                if ([queueFollowerDownload[currentFollower-2][@"ID"]intValue]) {
                    [queueFollowerLike addObject:queueFollowerDownload[currentFollower-2]];
                }
                
            } else {
                if ([dic[@"limit"]intValue]) {
                    [self alertPerCodiceErrore:[dic[@"errore"]intValue] andLimit:[dic[@"limit"]intValue]];
    
                }
            }
            
        }];
    }
    
}



- (IBAction)watchVideo:(id)sender{
    
    BlurredButton *button = (BlurredButton *)sender;
    
    if ([button.titleLabel.text isEqualToString:@"Watch a video"]) {
        [self video];
    } else {
        [self bonusCoins];
    }
}


- (void)video{
    [AdColony playVideoAdForZone:[Settings sharedInstance][@"adColony"][@"button"] withDelegate:self withV4VCPrePopup:NO andV4VCPostPopup:YES];
}


- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID {
    
    if (!shown && [zoneID isEqualToString:[Settings sharedInstance][@"adColony"][@"button"] ]) {
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"There are no more videos available, please retry later"];
        [alert addButtonWithTitle:@"Bonus Coins" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alert){
            [self bonusCoins];
        }];
        [watchVideo setTitle:@"Bonus Coins" forState:UIControlStateNormal];
        [alert addButtonWithTitle:@"Dismiss" type:SIAlertViewButtonTypeCancel handler:nil];
        [alert show];
    } else {
        [Ask4AppReviews appLaunched:YES];
    }
}


- (void)alertPerCodiceErrore:(int)codiceErrore andLimit:(int)limit{
    
    SIAlertView *alert = [[SIAlertView alloc]init];
    
    NSString *title = @"Like request limit reached";
    
    if (codiceErrore > 3) {
        title = @"Follow request limit reached";
    }

    [alert setTitle:title];
    
    if (codiceErrore == 1 || codiceErrore == 4) {
        
        if (codiceErrore == 1) {
            [alert setMessage:[NSString stringWithFormat:@"You have reached the limit for the number of photos you can like in a day (%d)!", limit]];
        } else {
            [alert setMessage:[NSString stringWithFormat:@"You have reached the limit for the number of users you can follow in a day (%d)!", limit]];
        }
        
        [alert addButtonWithTitle:@"Go PRO (No more limits)" type:SIAlertViewButtonTypeDestructive handler: ^(SIAlertView *al) {
            BuyCoins *contr = [self.storyboard instantiateViewControllerWithIdentifier:@"buyCoins"];
            contr.skippable = NO;
            [self.navigationController pushViewController:contr animated:YES];
        }];
        [alert addButtonWithTitle:@"More coins" type:SIAlertViewButtonTypeDefault handler: ^(SIAlertView *lo) {
            [self bonusCoins];
        }];
        
    } else if (codiceErrore == 2 || codiceErrore == 5) {
        if (codiceErrore == 2) {
            [alert setMessage:[NSString stringWithFormat:@"You have reached the limit for the number of photos you can like in an hour (%d)!", limit]];
        } else {
            [alert setMessage:[NSString stringWithFormat:@"You have reached the limit for the number of users you can follow in an hour (%d)!", limit]];
        }
        
        [alert addButtonWithTitle:@"Go PRO (No more limits)" type:SIAlertViewButtonTypeDestructive handler: ^(SIAlertView *al) {
            BuyCoins *contr = [self.storyboard instantiateViewControllerWithIdentifier:@"buyCoins"];
            contr.skippable = NO;
            [self.navigationController pushViewController:contr animated:YES];
        }];
        [alert addButtonWithTitle:@"More coins" type:SIAlertViewButtonTypeDefault handler: ^(SIAlertView *lo) {
            [self bonusCoins];
        }];
        
    } else if (codiceErrore == 3 || codiceErrore == 6) {
        if (codiceErrore == 3) {
            [alert setMessage:[NSString stringWithFormat:@"We're sorry, but Instagram doesn't allow to like more than %d photos in an hour! Please retry later!", limit]];
        } else {
            [alert setMessage:[NSString stringWithFormat:@"We're sorry, but Instagram doesn't allow to follow more than %d users in an hour! Please retry later!", limit]];
        }
            [alert addButtonWithTitle:@"Bonus coins" type:SIAlertViewButtonTypeDestructive handler: ^(SIAlertView *lo) {
            [self bonusCoins];
        }];
        [alert addButtonWithTitle:@"Buy coins!" type:SIAlertViewButtonTypeDefault handler: ^(SIAlertView *alert) {
            BuyCoins *contr = [self.storyboard instantiateViewControllerWithIdentifier:@"buyCoins"];
            contr.skippable = NO;
            [self.navigationController pushViewController:contr animated:YES];
            
        }];
    }
    
    [alert addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeCancel handler:nil];
    [alert show];
}






@end
