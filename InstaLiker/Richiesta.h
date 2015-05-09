//
//  Richiesta.h
//  InstaLiker
//
//  Created by Gui on 21/12/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Richiesta : NSMutableURLRequest


- (id)sendRequest:(NSString *)URL parameters:(id)dic;

- (id)initWithURL:(NSString *)URL andParameters:(id)dic;
@end
