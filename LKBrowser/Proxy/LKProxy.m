//
//  LKProxy.m
//  LKBrowser
//
//  Created by Lookis on 25/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#import "LKProxy.h"
#import <pthread.h>
#import "shadowsocks.h"
#import "start_local.h"

@interface LKProxy(){
    @private
    pthread_t proxyThread;
    profile_t profile;
    NSDictionary *settings;
}
@end

static const LKProxy *defaultProxy = nil;


@implementation LKProxy

+ (instancetype) defaultProxy{
    if (!defaultProxy){
        defaultProxy = [[LKProxy alloc] init];
    }
    return defaultProxy;
}

- (void) stopProxy{
    if(proxyThread){
        pthread_kill(proxyThread, SIGUSR1);
        pthread_join(proxyThread, nil);
        proxyThread = nil;
    }
}

- (void) startProxy{
    if(!proxyThread){
        NSFileManager* sharedFM = [NSFileManager defaultManager];
        NSArray<NSString *>* possibleDirs = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        if([possibleDirs count] >= 1) {
            NSLog(@"configuration dir: %@", [possibleDirs objectAtIndex:0]);
            //profile file
            NSString *profileDir = [[possibleDirs objectAtIndex:0] stringByAppendingString:@"/me.lookis.profile"];
            NSString *profileFile = [profileDir stringByAppendingString:@"/default.plist"];
            if ([sharedFM fileExistsAtPath:profileFile]){
                settings = [[NSDictionary alloc] initWithContentsOfFile:profileFile];
            }else{
                NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
                settings = [[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"proxy"] objectForKey:@"default"];
            }
            //acl file
            NSString *aclDir = [[possibleDirs objectAtIndex:0] stringByAppendingString:@"/me.lookis.acl"];
            NSString *aclFile = [aclDir stringByAppendingString:@"/default.acl"];
            if ([sharedFM fileExistsAtPath:aclFile]){
                profile.acl = [aclFile UTF8String];
            }else{
                profile.acl = NULL;
            }
        }else{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist" inDirectory:@"LKBrowser/"];
            settings = [[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"proxy"] objectForKey:@"default"];
            profile.acl = NULL;
        }

//        profile.remote_host = "192.241.222.150";
//        profile.local_addr = "127.0.0.1";
//        profile.method = "aes-256-cfb";
//        profile.password = "12345679";
//        profile.remote_port = 8389;
//        profile.local_port = 1081;
//        profile.timeout = 300;
//        profile.fast_open = 1;
//        profile.mode = 0;
//        profile.mptcp = 0;
//        profile.verbose = 1;
        
        profile.remote_host = [(NSString *)[settings valueForKey:@"remote_host"] UTF8String];
        profile.local_addr = [(NSString *)[settings valueForKey:@"local_addr"] UTF8String];
        profile.method = [(NSString *)[settings valueForKey:@"method"] UTF8String];
        profile.password = [(NSString *)[settings valueForKey:@"password"] UTF8String];
        profile.remote_port = [(NSNumber *)[settings valueForKey:@"remote_port"] intValue];
        profile.local_port = [(NSNumber *)[settings valueForKey:@"local_port"] intValue];
        profile.timeout = [(NSNumber *)[settings valueForKey:@"timeout"] intValue];
        profile.fast_open = [(NSNumber *)[settings valueForKey:@"fast_open"] intValue];
        profile.mode = [(NSNumber *)[settings valueForKey:@"mode"] intValue];
        profile.verbose = [(NSNumber *)[settings valueForKey:@"verbose"] intValue];
        profile.mptcp = [(NSNumber *)[settings valueForKey:@"mptcp"] intValue];
        profile.log = [[[possibleDirs objectAtIndex:0] stringByAppendingString:@"/shadowsocks.log"] UTF8String];
        
        pthread_create(&(proxyThread), nil, start_ss_local, &profile);
    }
}

- (void) serverHealthy{
    
    
}


@end
