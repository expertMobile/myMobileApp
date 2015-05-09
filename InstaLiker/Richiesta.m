//
//  Richiesta.m
//  InstaLiker
//
//  Created by Gui on 21/12/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import "Richiesta.h"
#import "RNEncryptor.h"
#import "WebService.h"
#import "Settings.h"
#import "Utente.h"



@implementation Richiesta


- (id)sendRequest:(NSString *)URL parameters:(id)dic {
	Richiesta *r = [[Richiesta alloc]initWithURL:URL andParameters:dic];
	return [[WebService new]sendSynchronousRequest:r];
}

- (NSString *)hash:(NSString *)stringa{
    
    NSString *salt = @"hash";
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [stringa dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    return [[[[hash description]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    
}


- (id)initWithURL:(NSString *)URL andParameters:(id)dic{
	[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (dic) {
        param = [dic mutableCopy];
    }


    
    if ([[Utente sharedUtente]ID]) {
        param[@"user"] = [[Utente sharedUtente]ID];
    }
    

    
	NSString *stringaUrl = [[Settings sharedInstance][@"ELB"] stringByAppendingFormat:@"/api/daVendere/%@", URL];
    
    
	self = [self initWithURL:[NSURL URLWithString:stringaUrl]];
	if (self) {
        
        

        
            NSMutableDictionary *mut = [param mutableCopy];
            
            
            NSString *str = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:mut options:0 error:nil] encoding:NSUTF8StringEncoding];
            
            NSString *base64 = [[str dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];

         NSString *query = [NSString stringWithFormat:@"B.%@.%@", [self hash:base64], base64];
        
        self.HTTPMethod = @"POST";
        self.HTTPBody = [[NSString stringWithFormat:@"-=%@", query]dataUsingEncoding:NSUTF8StringEncoding];
	}
	return self;
}


@end
