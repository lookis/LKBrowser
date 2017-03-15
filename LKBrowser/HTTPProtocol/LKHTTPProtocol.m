//
//  LKHTTPProtocol.m
//  URLProtocolExample
//
//  Created by Lookis on 06/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKHTTPProtocol.h"

static NSString *const URLProtocolProcessedKey = @"LKHTTPProtocolProcessed";

@interface LKHTTPProtocol () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation LKHTTPProtocol

#pragma NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:URLProtocolProcessedKey inRequest:request]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    NSLog(@"startLoading %@", self);
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:URLProtocolProcessedKey inRequest:newRequest];
    
    
    NSDictionary *dict = @{
                           @"SOCKSEnable" : [NSNumber numberWithInt:1],
                           (NSString *)kCFStreamPropertySOCKSProxyHost : @"127.0.0.1",
                           (NSString *)kCFStreamPropertySOCKSProxyPort : @1081,
                           };
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setConnectionProxyDictionary:dict];
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    self.sessionTask = [_session dataTaskWithRequest:newRequest];
    [self.sessionTask resume];
}

- (void)stopLoading {
    [self.sessionTask cancel];
    self.sessionTask = nil;
    [_session finishTasksAndInvalidate];
    _session = nil;
}

#pragma NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    NSMutableURLRequest *redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:URLProtocolProcessedKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    [self.sessionTask cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error && error.code != NSURLErrorCancelled) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

@end
