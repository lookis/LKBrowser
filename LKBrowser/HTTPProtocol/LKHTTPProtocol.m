//
//  LKHTTPProtocol.m
//  URLProtocolExample
//
//  Created by Lookis on 06/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKHTTPProtocol.h"

@interface LKHTTPProtocol ()
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@end

@implementation LKHTTPProtocol

#pragma NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"LKHTTPProtocol Request URL = %@", request.URL.absoluteString);
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]){
        if (![NSURLProtocol propertyForKey:@"LKHTTPProtocolHandledKey" inRequest:request]) {
            NSLog(@"LKHTTPProtocol canInitWithRequest YES");
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
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    NSString *tab = [LKTabController instance].tab;
    NSURLSession *session = [[[LKTabController instance] tabSession] objectForKey:tab];
    [NSURLProtocol setProperty:@YES forKey:@"LKHTTPProtocolHandledKey" inRequest:newRequest];
    __weak __typeof__(self) weakSelf = self;
    self.sessionTask = [session dataTaskWithRequest:newRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        NSLog(@"LKHTTPProtocol sessionTask callback");
        if(data){
            [weakSelf.client URLProtocol:weakSelf didLoadData:data];
        }else if (response){
            [weakSelf.client URLProtocol:weakSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        }else if (!error) {
            [weakSelf.client URLProtocolDidFinishLoading:weakSelf];
        }else{
            [weakSelf.client URLProtocol:weakSelf didFailWithError:error];
        }
    }];
    [self.sessionTask resume];
}

- (void)stopLoading {
    [self.sessionTask cancel];
    self.sessionTask = nil;
}

@end
