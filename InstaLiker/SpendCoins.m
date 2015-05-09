//
//  SpendCoins.m
//  InstaLiker
//
//  Created by Gui on 25/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "SpendCoins.h"
#import "CellaSpendi.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Coins.h"
#import "Richiesta.h"
#import "SIAlertView.h"
#import "Utente.h"
#import "NavigationController.h"
#import "FXBlurView.h"

@interface SpendCoins ()

@end

@implementation SpendCoins


- (void)viewDidLoad{
    
    [super viewDidLoad];
    tbl.delegate = self;
    tbl.dataSource = self;
    
    [img sd_setImageWithURL:[NSURL URLWithString:self.photo[@"images"][@"standard_resolution"][@"url"]]placeholderImage:[UIImage imageNamed:@"Loading"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cachetype, NSURL *imageURL){
        [blurred setImage:[image blurredImageWithRadius:20 iterations:20 tintColor:nil]];
    }];

    
    [lbl setText:[NSString stringWithFormat:@"❤︎ %@", self.photo[@"likes"][@"count"]]];
    lbl.layer.cornerRadius = 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CellaSpendi *cell = [tableView dequeueReusableCellWithIdentifier:@"CellaSpendi"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cell.backgroundColor = tableView.backgroundColor;
    }
    
    if (indexPath.row == 0) {
        cell.likes.text = @"10 likes";
        cell.cost.text =  @"20 coins";
    } else if (indexPath.row == 1) {
        cell.likes.text = @"20 likes";
        cell.cost.text =  @"40 coins";
    } else if (indexPath.row == 2) {
        cell.likes.text = @"50 likes";
        cell.cost.text =  @"100 coins";
    } else if (indexPath.row == 3) {
        cell.likes.text = @"100 likes";
        cell.cost.text =  @"200 coins";
    } else if (indexPath.row == 4) {
        cell.likes.text = @"500 likes";
        cell.cost.text =  @"1,000 coins";
    } else if (indexPath.row == 5) {
        cell.likes.text = @"1,000 likes";
        cell.cost.text =  @"2,000 coins";
    } else if (indexPath.row == 6) {
        cell.likes.text = @"5,000 likes";
        cell.cost.text =  @"10,000 coins";
    } else if (indexPath.row == 7) {
        cell.likes.text = @"10,000 likes";
        cell.cost.text =  @"20,000 coins";
    }
    cell.button.tag = indexPath.row;
    
    return cell;
}

- (IBAction)compra:(id)sender{
    
    
    int k = (int)((UIButton *)sender).tag;
    
    int Likes = 0;
    
    if (k == 0) {
        Likes = 10;
    } else if (k == 1) {
        Likes = 20;
    } else if (k == 2) {
        Likes = 50;
    } else if (k == 3) {
        Likes = 100;
    } else if (k == 4) {
        Likes = 500;
    } else if (k == 5) {
        Likes = 1000;
    } else if (k == 6) {
        Likes = 5000;
    } else if (k == 7) {
        Likes = 10000;
    }
    
    
    Likes *= 2;
    
	NSDictionary *dict = [[Richiesta new] sendRequest:@"a.php" parameters:@{ @"a": self.photo[@"images"][@"standard_resolution"][@"url"], @"d" : @(Likes), @"e" : self.photo[@"id"], @"f" : self.photo[@"link"]}];
    
	if ([dict[@"status"] isEqualToString:@"OK"]) {
		SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Success" andMessage:[NSString stringWithFormat:@"You'll receive %d more likes on this photo", Likes/2]];
		alert.transitionStyle = SIAlertViewTransitionStyleBounce;
		[alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
		[alert show];
	} else {
		[[Coins sharedCoins]update:[dict[@"coins"] intValue]];
        
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Ops!" andMessage:@"You don't have enough coins!"];
        [alert addButtonWithTitle:@"Buy coins" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alert){
            

            [self.navigationController popViewControllerAnimated:YES];
        }];
		
        [alert addButtonWithTitle:@"Free coins" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *aleert){

            
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"bonusCoins"] animated:YES];
            
            }];
		[alert show];
	}
    
    [self setCoins];
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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




@end
