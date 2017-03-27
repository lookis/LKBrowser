//
//  LKProxy.h
//  LKBrowser
//
//  Created by Lookis on 25/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKProxy : NSObject
+ (instancetype) defaultProxy;
- (void) stopProxy;
- (void) startProxy;
- (void) serverHealthy;

@end
