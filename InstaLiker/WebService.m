//
//  WebService.m
//  InstaLiker
//
//  Created by Gui on 27/11/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import "WebService.h"
#import "RNEncryptor.h"

@implementation WebService


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CFRunLoopStop(CFRunLoopGetCurrent());
}



- (id)sendSynchronousRequest:(NSURLRequest *)request{

    receivedData = [NSMutableData new];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:self];
    [con start];
    CFRunLoopRun();
    
	NSString *srr = [[[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![srr length]) {
        return nil;
    }
    
    
    NSArray *parti = [srr componentsSeparatedByString:@"."];    

    
    if ([parti count]!=3){

        NSLog(@"errori parti  %@", request.URL);
        return nil;
    }
    
    if (![[self hash:parti[2]]isEqualToString:parti[1]]) {
        return nil;
    }
    
    NSData *risultato;

    risultato = [[NSData alloc]initWithBase64EncodedString:parti[2] options:0];
    
    if (!risultato) {
        return nil;
    }

    
    
	NSDictionary *d = [NSJSONSerialization JSONObjectWithData:risultato options:0 error:nil];
    
	[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    
	if ([d[@"status"] isEqualToString:@"BAN"]) {
		exit(0);
	}
	return d;
}

- (NSString *)hash:(NSString *)stringa{
    
    NSString *salt = @"hash";
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [stringa dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    return [[[[hash description]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
    
}

@end
