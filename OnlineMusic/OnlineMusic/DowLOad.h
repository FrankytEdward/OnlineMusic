//
//  DowLOad.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadBlock) (NSData *resultData);
@interface DowLOad : NSObject

//获取类的对象
+(instancetype)sharedInstance;

//下载方法
-(void)downloadWithURL:(NSURL *)url complete:(DownloadBlock)block;
@end
