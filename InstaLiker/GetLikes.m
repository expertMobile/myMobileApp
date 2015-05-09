//
//  Collection.m
//  InstaLiker
//
//  Created by Gui on 24/04/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "GetLikes.h"
#import "Richiesta.h"
#import "Utente.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CellaCollection.h"
#import "FooterCollection.h"
#import "BuyCoins.h"
#import "Coins.h"


@interface GetLikes ()

@end

@implementation GetLikes

- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}



- (void)startRefresh{
    
    
 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@", [[Utente sharedUtente]token]]]] options:0 error:nil];
    
    arr = [NSMutableArray arrayWithArray:dic[@"data"]];
    
    nextUrl = @"";
    if ([dic[@"pagination"]isKindOfClass:[NSDictionary class]]) {
        nextUrl = dic[@"pagination"][@"next_url"];
    }
    
    [self.collectionView reloadData];
    
    [refreshControl endRefreshing];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor whiteColor];
    
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
    if (![arr count]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@", [[Utente sharedUtente]token]]]] options:0 error:nil];
        
        arr = [NSMutableArray arrayWithArray:dic[@"data"]];
        
        nextUrl = @"";
        if ([dic[@"pagination"]isKindOfClass:[NSDictionary class]]) {
            nextUrl = dic[@"pagination"][@"next_url"];
        }
    }
    } completionBlock:^{
        [self.collectionView reloadData];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [arr count];
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellaCollection *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellaCollection" forIndexPath:indexPath];
   
    [cell.img sd_setImageWithURL:[NSURL URLWithString:arr[indexPath.row][@"images"][@"low_resolution"][@"url"]] placeholderImage:[UIImage imageNamed:@"Loading"] options:SDWebImageHighPriority];
    [cell.lbl setText:[NSString stringWithFormat:@"❤︎ %@", arr[indexPath.row][@"likes"][@"count"]]];
    return cell;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    BuyCoins *buy = (BuyCoins *)[segue destinationViewController];
    buy.skippable = YES;

    buy.photo = arr[[self.collectionView indexPathForCell:sender].row];
    buy.backButton = YES;
    
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

- (IBAction)loadMore:(id)sender{
    
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:nextUrl]];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:0 error:nil];
        
        [arr addObjectsFromArray:dic[@"data"]];
        nextUrl = dic[@"pagination"][@"next_url"];
    }completionBlock:^{
        [self.collectionView reloadData];
    }];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    FooterCollection *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    
    if ([nextUrl length]) {
        footerview.button.enabled = YES;
        footerview.button.hidden = NO;
    } else {

        footerview.button.enabled = NO;
        footerview.button.hidden = YES;
    }
    return footerview;
}


@end
