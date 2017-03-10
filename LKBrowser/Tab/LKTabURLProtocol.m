//
//  LKTabURLProtocol.m
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabURLProtocol.h"

@interface LKTabURLProtocol () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSString *tab;
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation LKTabURLProtocol


#pragma NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([request.URL.scheme isEqualToString:@"tab"]){
        return YES;
    }else{
        return NO;
    }
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

- (void)startLoading{
    self.tab = self.request.URL.absoluteString;
    NSURLSession *session = [[[LKTabController instance] tabSession] objectForKey:self.tab];
    if(!session){
        NSDictionary *dict = @{
                               @"SOCKSEnable" : [NSNumber numberWithInt:1],
                               (NSString *)kCFStreamPropertySOCKSProxyHost : @"127.0.0.1",
                               (NSString *)kCFStreamPropertySOCKSProxyPort : @1081,
                               };
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [configuration setConnectionProxyDictionary:dict];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        [[[LKTabController instance] tabSession] setObject:session forKey:self.tab];
        NSURL *url = [[[LKTabController instance] tabEntrance] objectForKey:self.tab];
        self.task  = [session dataTaskWithURL:url];
        [self.task resume];
    }else{
        if (self.task.state == NSURLSessionTaskStateCompleted){
            [self.client URLProtocol:self wasRedirectedToRequest:self.task.currentRequest redirectResponse:self.task.response];
            [self.client URLProtocolDidFinishLoading:self];
        } else {
            [self.task resume];
        }
    }
    
}

- (void)stopLoading{
    NSLog(@"stopLoading: %@", self.tab);
    [[[[LKTabController instance] tabSession] objectForKey:self.tab] invalidateAndCancel];
    [[[LKTabController instance] tabSession] removeObjectForKey:self.tab];
    [[[LKTabController instance] tabEntrance] removeObjectForKey:self.tab];
    self.tab = nil;
    self.task = nil;
}


#pragma NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self wasRedirectedToRequest:dataTask.currentRequest redirectResponse:response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error ) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

@end
