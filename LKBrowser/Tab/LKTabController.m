//
//  TabController.m
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKTabController.h"

@interface LKTabController () <NSURLSessionDataDelegate>

@end

@implementation LKTabController

+ (LKTabController *)instance{
    static LKTabController *_instance = nil;
    if(_instance == nil){
        _instance = [[LKTabController alloc] init];
    }
    return _instance;
}


@end
