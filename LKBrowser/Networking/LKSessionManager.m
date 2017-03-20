//
//  LKSessionManager.m
//  LKBrowser
//
//  Created by Lookis on 19/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKSessionManager.h"
#import "LKHTTPProtocol.h"

@interface LKSessionManager() <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSURLSessionTask *, NSURLProtocol *> *sessionDictionary;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation LKSessionManager

static LKSessionManager *sharedMyManager = nil;

+ (instancetype) singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.lock = [[NSLock alloc] init];
    });
    return sharedMyManager;
}

+ (void) registerSessionTask:(NSURLSessionTask *)task withProtocol:(LKHTTPProtocol *)protocol{
    LKSessionManager *manager = [self singleton];
    if (![manager sessionDictionary]){
        manager.sessionDictionary = [[NSMutableDictionary alloc] init];
    }
    [manager.lock lock];
    [manager.sessionDictionary setObject:protocol forKey:task];
    [manager.lock unlock];
}

+ (void) protocolStopLoading:(LKHTTPProtocol *)protocol{
    LKSessionManager *manager = [self singleton];
    [manager.lock lock];
    [manager.sessionDictionary removeObjectForKey:protocol.task];
    [manager.lock unlock];
}

+ (NSURLSession *) sharedSession {
    LKSessionManager *manager = [self singleton];
    if(!manager.session){
        NSDictionary *dict = @{
                               @"SOCKSEnable" : [NSNumber numberWithInt:1],
                               (NSString *)kCFStreamPropertySOCKSProxyHost : @"127.0.0.1",
                               (NSString *)kCFStreamPropertySOCKSProxyPort : @1081,
                               };
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setConnectionProxyDictionary:dict];
        manager.session = [NSURLSession sessionWithConfiguration:configuration delegate:manager delegateQueue:nil];
    }
    return manager.session;
}



#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    NSMutableURLRequest *redirectRequest = [newRequest mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:BrowserRedirectedRequest inRequest:redirectRequest];
    NSURLProtocol *protocol = [_sessionDictionary objectForKey:task];
    [protocol.client URLProtocol:protocol wasRedirectedToRequest:redirectRequest redirectResponse:response];
    [task cancel];
    [protocol.client URLProtocol:protocol didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSURLProtocol *protocol = [_sessionDictionary objectForKey:dataTask];
    [protocol.client URLProtocol:protocol didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSURLProtocol *protocol = [_sessionDictionary objectForKey:dataTask];
    [protocol.client URLProtocol:protocol didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    if(_session){
        [_session invalidateAndCancel];
        _session = nil;
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSURLProtocol *protocol = [_sessionDictionary objectForKey:task];
    if (error && error.code != NSURLErrorCancelled) {
        [protocol.client URLProtocol:protocol didFailWithError:error];
    } else {
        [protocol.client URLProtocolDidFinishLoading:protocol];
    }
}



@end
