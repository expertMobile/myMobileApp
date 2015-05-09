//
//  Settings.m
//  InstaLiker
//
//  Created by Gui on 15/01/14.
//  Copyright (c) 2014 GuiDev. All rights reserved.
//

#import "Settings.h"
#import "RNDecryptor.h"
#import "Richiesta.h"
#import "WebService.h"

@interface Settings ()
@end


@implementation Settings


+ (Settings *)sharedInstance {
	static dispatch_once_t pred;
	static Settings *shared;
	dispatch_once(&pred, ^{
	    shared = [[Settings alloc] init];
	});
    
	return shared;
}

- (id)init {

    Richiesta *r = [[Richiesta alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/daVendere/settings.php", @"http://192.241.188.172"]]];
    
    NSDictionary *d = [[WebService new]sendSynchronousRequest:r];
    self = (Settings *)d;
    
	return self;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}



@end
