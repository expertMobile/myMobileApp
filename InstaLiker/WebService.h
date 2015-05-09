//
//  WebService.h
//  InstaLiker
//
//  Created by Gui on 27/11/13.
//  Copyright (c) 2013 GuiDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSURLConnection
{
	BOOL finishedLoading;
	NSMutableData *receivedData;
	NSError *errore;
}


- (id)sendSynchronousRequest:(NSURLRequest *)request;


@end
