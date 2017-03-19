//
//  AppDelegate.m
//  LKBrowser
//
//  Created by Lookis on 09/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "AppDelegate.h"
#import "MyURLProtocol.h"
#import "pthread.h"
#import "start_local.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer *killerTimer;
@property UIBackgroundTaskIdentifier backgroundIdentifier;

@end

pthread_t serverThread;
profile_t profile;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSURLProtocol registerClass:[LKHTTPProtocol class]];
    NSLog(@"didFinishLaunchingWithOptions");
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"background Task end.");
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundIdentifier];
        _backgroundIdentifier = UIBackgroundTaskInvalid;
    }];
    NSLog(@"enter background task");
    _killerTimer = [NSTimer scheduledTimerWithTimeInterval:120 repeats:NO block:^(NSTimer *timer){
        if(serverThread){
            pthread_kill(serverThread, SIGUSR1);
            pthread_join(serverThread, nil);
            serverThread = nil;
            _killerTimer = nil;
            [[UIApplication sharedApplication] endBackgroundTask:_backgroundIdentifier];
            _backgroundIdentifier = UIBackgroundTaskInvalid;
        }
    }];

    NSLog(@"applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_killerTimer){
        [_killerTimer invalidate];
        _killerTimer = nil;
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundIdentifier];
        _backgroundIdentifier = UIBackgroundTaskInvalid;
    }
    if(!serverThread){
        profile.remote_host = "192.241.222.150";
        profile.local_addr = "127.0.0.1";
        profile.method = "aes-256-cfb";
        profile.password = "12345679";
        profile.remote_port = 8389;
        profile.local_port = 1081;
        profile.timeout = 300;
        profile.acl = NULL;
        profile.log = NULL;
        profile.fast_open = 1;
        profile.mode = 0;
        profile.verbose = 0;
        pthread_create(&(serverThread), nil, start_ss_local, &profile);
        
    }
    NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
