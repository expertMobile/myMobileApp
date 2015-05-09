//
//  Utente.m
//  InstaLiker
//
//  Created by Gui on 21/12/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//


#import "Utente.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "Richiesta.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SIAlertView.h"

@interface Utente ()

@end

@implementation Utente



+ (Utente *)sharedUtente {
	static dispatch_once_t pred;
	static Utente *shared;
    
	dispatch_once(&pred, ^{
	    shared = [[Utente alloc] init];
	});
    
	return shared;
}

- (id)init {
	if (self = [super init]) {
		NSData *d = [[NSUserDefaults standardUserDefaults]valueForKey:[[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
		d = [RNDecryptor decryptData:d withPassword:@"password" error:nil];
        
		NSMutableDictionary *da;
        
		if (d) {
			da = [NSKeyedUnarchiver unarchiveObjectWithData:d];
		}
		else {
			da = [NSMutableDictionary new];
		}

		ID = da[@"ID"];
        token = da[@"TOKEN"];
		isPro = [da[@"isPro"] boolValue];
        
        info = [NSDictionary dictionary];
        
        if ([[da[@"likes"] allKeys]count]) {
            likes = [NSMutableDictionary dictionaryWithDictionary:da[@"likes"]];
        } else {
            likes = [NSMutableDictionary new];
        }
    }
	return self;
}


- (void)setToken:(NSString *)str{
    token = str;
    [self salva];
}

- (void)setID:(NSString *)str {
	ID = str;
	[self salva];
}

- (void)setIsPro:(BOOL)pro {
	isPro = pro;
	[self salva];
}

- (BOOL)isPro {
	return isPro;
}


- (NSString *)token{
    return token;
}

- (NSString *)ID {
	return ID;
}

- (NSDictionary *)getInfo{
    
    if (![[info allKeys]count]) {
        return [self forceGetInfo];
    }
    
    return info;
}

- (NSDictionary *)forceGetInfo{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", [[Utente sharedUtente]token]]]];
    
    if (!data) {
        return nil;
    }
    
    info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    if ([info[@"meta"][@"code"]intValue] != 200) {
        return nil;
    }
    info = info[@"data"];
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:info[@"profile_picture"]]
                                                    options:SDWebImageHighPriority
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {}];
    
    return info;
}



- (void)salva {
	NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
    
	ID = ID ? ID : @"";
	token = token ? token : @"";
    
    d[@"TOKEN"] = token;
	d[@"ID"] = ID;
	d[@"isPro"] = @(isPro);
	d[@"likes"] = likes;
    
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:d];
	data = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:@"password" error:nil];
	[[NSUserDefaults standardUserDefaults]setValue:data forKey:[[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
	[[NSUserDefaults standardUserDefaults]synchronize];
}


@end
