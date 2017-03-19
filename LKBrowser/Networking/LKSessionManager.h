//
//  LKSessionManager.h
//  LKBrowser
//
//  Created by Lookis on 19/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const BrowserRedirectedRequest = @"BrowserRedirectedRequest";

@interface LKSessionManager : NSObject

+ (NSURLSession *) sharedSession;
+ (void) registerSessionTask:(NSURLSessionTask *)task withProtocol:(NSURLProtocol *)protocol;
+ (void) protocolStopLoading:(NSURLProtocol *)protocol;


@end
