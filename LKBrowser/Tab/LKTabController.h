//
//  TabController.h
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKTabController : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, strong, readwrite) NSString *tab;
@property (nonatomic, strong, readonly) NSMutableDictionary *tabSession;
@property (nonatomic, strong, readonly) NSMutableDictionary *tabEntrance;

+ (LKTabController *)instance;
@end
