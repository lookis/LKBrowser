//
//  AppDelegate.m
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "AppDelegate.h"
#import "MyURLProtocol.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [NSURLProtocol registerClass:[MyURLProtocol class]];
    [NSURLProtocol registerClass:[LKHTTPProtocol class]];
    
    
    // Log File
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *logFile = [tmpDirectory stringByAppendingPathComponent:@"shadowsocks.log"];
    
    const profile_t EXAMPLE_PROFILE = {
        .remote_host = "192.241.222.150",
        .local_addr = "127.0.0.1",
        .method = "aes-256-cfb",
        .password = "12345679",
        .remote_port = 8389,
        .local_port = 1081,
        .timeout = 600,
        .acl = NULL,
        .log = [logFile UTF8String],
        .fast_open = 1,
        .mode = 0,
        .verbose = 0
    };
    
    // Queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        int ret = start_ss_local_server(EXAMPLE_PROFILE);
        NSLog(@"%@ return: %i", @"start_ss_local_server", ret);
        NSLog(@"logfile: %@", logFile);
    }];
    [queue addOperation:operation];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
