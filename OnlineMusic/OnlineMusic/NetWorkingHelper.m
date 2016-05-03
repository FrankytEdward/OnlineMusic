//
//  NetWorkingHelper.m
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/28.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "NetWorkingHelper.h"

static NSString *const MusicBaseURLString = @"https://api.douban.com/v2/music/";

@implementation NetWorkingHelper

+(AFHTTPSessionManager *)sharedHttpManager{
    static AFHTTPSessionManager *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:MusicBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSLog(@"baseurl-----%@",MusicBaseURLString);
    });
    return _sharedClient;
}

@end
