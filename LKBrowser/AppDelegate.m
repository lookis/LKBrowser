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
    [NSURLProtocol registerClass:[LKHTTPProtocol class]];
    
    
    // Log File
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"shadowsocks-%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];

    const profile_t PROFILE = {
        .remote_host = "192.241.222.150",
        .local_addr = "127.0.0.1",
        .method = "aes-256-cfb",
        .password = "12345679",
        .remote_port = 8389,
        .local_port = 1081,
        .timeout = 300,
        .acl = NULL,
        .log = [logFilePath UTF8String],
        .fast_open = 1,
        .mode = 0,
        .verbose = 1
    };
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        int ret = start_ss_local_server(PROFILE);
        NSLog(@"%@ return: %i", @"start_ss_local_server", ret);
    }];
    [queue addOperation:operation];
    
    NSLog(@"didFinishLaunchingWithOptions");
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    _resignActiveDate = [NSDate date];
    NSLog(@"applicationWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if (_resignActiveDate){
//        NSDate *becomeActiveDate = [NSDate date];
//        NSDate *restartServerDate = [_resignActiveDate dateByAddingTimeInterval:1*10];
//        if([becomeActiveDate compare:restartServerDate] == NSOrderedDescending){
//            pthread_kill(_serverThread, SIGTERM);
//            NSLog(@"restarting ss_local");
//            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//                [NSThread sleepForTimeInterval:1];
//                NSLog(@"restarted ss_local");
//                _serverThread = pthread_self();
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//                NSString *documentsDirectory = [paths objectAtIndex:0];
//                NSString *fileName =[NSString stringWithFormat:@"shadowsocks1-%@.log",[NSDate date]];
//                NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//                profile_t PROFILE = {
//                    .remote_host = "192.241.222.150",
//                    .local_addr = "127.0.0.1",
//                    .method = "aes-256-cfb",
//                    .password = "12345679",
//                    .remote_port = 8389,
//                    .local_port = 1081,
//                    .timeout = 300,
//                    .acl = NULL,
//                    .log = [logFilePath UTF8String],
//                    .fast_open = 1,
//                    .mode = 0,
//                    .verbose = 0
//                };
//                
//                int ret = start_ss_local_server(PROFILE);
//                NSLog(@"%@ return: %i", @"start_ss_local_server", ret);
//            }];
//            [_queue addOperation:operation];
//        }else{
//            NSLog(@"time is too short, no need restart server");
//        }
//    }else{
//    NSLog(@"start new ss_local");
//    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//        _serverThread = pthread_self();
//        int ret = start_ss_local_server(_serverProfile);
//        NSLog(@"%@ return: %i on", @"start_ss_local_server", ret);
//    }];
//    [_queue addOperation:operation];
//    }
    NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}


@end
