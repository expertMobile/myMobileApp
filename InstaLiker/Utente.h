//
//  Utente.h
//  InstaLiker
//
//  Created by Gui on 21/12/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utente : NSObject {
	NSString *ID;
    NSString *token;
    NSMutableDictionary *likes;
    NSDictionary *info;
	BOOL isPro;
}


+ (Utente *)sharedUtente;

- (void)setID:(NSString *)str;
- (void)setIsPro:(BOOL)pro;
- (BOOL)isPro;
- (void)setToken:(NSString *)str;


- (NSString *)token;
- (NSString *)ID;
- (NSDictionary *)getInfo;
- (NSDictionary *)forceGetInfo;

@end
