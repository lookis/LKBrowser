//
//  LKHTTPProtocol.m
//  URLProtocolExample
//
//  Created by Lookis on 06/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKHTTPProtocol.h"
#import "AppDelegate.h"
#import "LKSessionManager.h"

static NSString *const URLProtocolProcessedKey = @"LKHTTPProtocolProcessed";

@interface LKHTTPProtocol ()
@property (nonatomic, strong) NSURLSessionTask* task;
@end

@implementation LKHTTPProtocol

#pragma mark NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([[[request URL] scheme] isEqualToString:@"http"] || [[[request URL] scheme] isEqualToString:@"https"]){
        if(![NSURLProtocol propertyForKey:URLProtocolProcessedKey inRequest:request] || [NSURLProtocol propertyForKey:BrowserRedirectedRequest inRequest:request]){
            NSLog(@"canInitWithRequest: %@", request.URL.absoluteString);
            return YES;
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    NSLog(@"startLoading request: %@, task: %@", self.request, self.task);
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:URLProtocolProcessedKey inRequest:newRequest];
    NSURLSession *session = [LKSessionManager sharedSession];
    self.task = [session dataTaskWithRequest:newRequest];
    [LKSessionManager registerSessionTask:self.task withProtocol:self];
    [self.task resume];
}

- (void)stopLoading {
    NSLog(@"endLoading");
    [self.task cancel];
    [LKSessionManager protocolStopLoading:self];
    self.task = nil;
}


@end
