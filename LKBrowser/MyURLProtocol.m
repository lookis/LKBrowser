//
//  MyURLProtocol.m
//  URLProtocolExample
//
//  Created by Lookis on 06/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "MyURLProtocol.h"

@interface MyURLProtocol () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@end

@implementation MyURLProtocol

#pragma NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    static NSUInteger requestCount = 0;
    NSLog(@"Request #%lu: URL = %@", (unsigned long)requestCount++, request.URL.absoluteString);
    if ([NSURLProtocol propertyForKey:@"MyURLProtocolHandledKey" inRequest:request]) {
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
    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
    
    
    NSDictionary *dict = @{
                           @"SOCKSEnable" : [NSNumber numberWithInt:1],
                           (NSString *)kCFStreamPropertySOCKSProxyHost : @"127.0.0.1",
                           (NSString *)kCFStreamPropertySOCKSProxyPort : @1081,
                           };
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setConnectionProxyDictionary:dict];
    self.sessionTask = [[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil] dataTaskWithRequest:newRequest];
    [self.sessionTask resume];
}

- (void)stopLoading {
    NSLog(@"stopLoading %@", self);
    [self.sessionTask cancel];
    self.sessionTask = nil;
}

#pragma NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    NSLog(@"willPerformHTTPRedirection");
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    completionHandler(request);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSLog(@"didReceiveResponse");
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData");
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    NSLog(@"didBecomeInvalidWithError");
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"didCompleteWithError %@", error);
    if (error && error.code != NSURLErrorCancelled) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}
@end
