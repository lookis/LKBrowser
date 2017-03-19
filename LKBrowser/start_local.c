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
    const profile_t profile = *(profile_t *)profile_ptr;
    start_ss_local_server(profile);
    return NULL;
}
