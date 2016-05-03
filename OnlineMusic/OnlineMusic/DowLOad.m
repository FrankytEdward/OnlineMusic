//
//  DowLOad.m
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "DowLOad.h"

@interface DowLOad()
@property (nonatomic,copy)DownloadBlock block;

@end


static DowLOad *instance = nil;
@implementation DowLOad

+(instancetype)sharedInstance{
    if (instance == nil) {
        instance = [[[self class]alloc]init];
    }
    return instance;
}

//下载的方法
-(void)downloadWithURL:(NSURL *)url complete:(DownloadBlock)block{
    //保存block
    self.block = block;
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //执行下载任务
        //创建一个request
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        //获取数据
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //将数据返回给调用者
        dispatch_async(dispatch_get_main_queue(), ^{
            self.block(data);
        });
    });
}


@end
