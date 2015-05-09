//
//  Coins.m
//  InstaLiker
//
//  Created by Gui on 17/11/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import "Coins.h"
#import "RNDecryptor.h"
#import "RNEncryptor.h"


@interface Coins ()

@end

@implementation Coins


+ (Coins *)sharedCoins {
	static dispatch_once_t pred;
	static Coins *shared;
    
	dispatch_once(&pred, ^{
	    shared = [[Coins alloc] init];
	});
	return shared;
}

- (id)init {
	if (self = [super init]) {
		NSData *d = [[NSUserDefaults standardUserDefaults]valueForKey:@"co"];
		d = [RNDecryptor decryptData:d withPassword:@"password" error:nil];
		if (d) {
			NSDictionary *da = [NSKeyedUnarchiver unarchiveObjectWithData:d];
			self.Coins = [da[@"Coin"] intValue];
		}
		else {
			self.Coins = 0;
		}
	}
	return self;
}

- (void)update:(int)coin {
	self.Coins = coin;
	[self salva];
}

- (int)totCoin {
	return self.Coins;
}

- (void)salva {
	NSDictionary *d = @{ @"Coin": @(self.Coins) };
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:d];
	data = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:@"password" error:nil];
	[[NSUserDefaults standardUserDefaults]setValue:data forKey:@"a"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}

@end
