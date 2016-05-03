//
//  NetWorkingHelper.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/28.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkingHelper : NSObject

+(AFHTTPSessionManager *)sharedHttpManager;

@end
