//
//  ViewController.h
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKHTTPProtocol.h"

static NSString *const BrowserRedirectedRequest = @"BrowserRedirectedRequest";
@interface BrowserViewController : UIViewController

- (NSURLSession *) getSession;
- (void) registerSessionTask:(NSURLSessionTask *)task withProtocol:(NSURLProtocol *)protocol;
- (void) protocolStopLoading:(NSURLProtocol *)protocol;

@end
