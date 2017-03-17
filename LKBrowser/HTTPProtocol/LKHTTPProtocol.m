//
//  LKHTTPProtocol.m
//  URLProtocolExample
//
//  Created by Lookis on 06/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKHTTPProtocol.h"
#import "BrowserViewController.h"
#import "AppDelegate.h"

static NSString *const URLProtocolProcessedKey = @"LKHTTPProtocolProcessed";

@interface LKHTTPProtocol ()
@property (nonatomic, strong) NSURLSessionTask* task;
@end

@implementation LKHTTPProtocol

#pragma mark NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![NSURLProtocol propertyForKey:BrowserRedirectedRequest inRequest:request] && [NSURLProtocol propertyForKey:URLProtocolProcessedKey inRequest:request]) {
        return NO;
    }
    NSLog(@"canInitWithRequest: %@", request.URL.absoluteString);
    return YES;
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
    NSURLSession *session = [[self getController] getSession];
    self.task = [session dataTaskWithRequest:newRequest];
    [[self getController] registerSessionTask:self.task withProtocol:self];
    [self.task resume];
}

- (void)stopLoading {
    [self.task cancel];
    [[self getController] protocolStopLoading:self];
    self.task = nil;
}


- (BrowserViewController *) getController{
    BrowserViewController *rootController =(BrowserViewController*)[[(AppDelegate*)
                                                               [[UIApplication sharedApplication]delegate] window] rootViewController];
    return rootController;
}

@end
