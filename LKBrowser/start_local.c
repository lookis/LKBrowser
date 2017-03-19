//
//  start_local.c
//  LKBrowser
//
//  Created by Lookis on 17/03/2017.
//  Copyright © 2017 Lookis. All rights reserved.
//

#include "start_local.h"
#include "shadowsocks.h"
#include "pthread.h"


void *start_ss_local(void *profile_ptr)
{
    
//    profile_t profile = {
//        .remote_host = "192.241.222.150",
//        .local_addr = "127.0.0.1",
//        .method = "aes-256-cfb",
//        .password = "12345679",
//        .remote_port = 8389,
//        .local_port = 1081,
//        .timeout = 300,
//        .acl = NULL,
//        .log = NULL,
//        .fast_open = 1,
//        .mode = 0,
//        .verbose = 1
//    };
    const profile_t profile = *(profile_t *)profile_ptr;
    start_ss_local_server(profile);
    return NULL;
}
