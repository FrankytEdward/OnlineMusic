//
//  Helper.m
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/24.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(NSString *)timeStringWithlength:(int)totalLength{
    int minute = totalLength/60;
    int second = totalLength%60;
    NSString *timeString = [NSString stringWithFormat:@"%@%d:%@%d",minute<10?@"0":@"",minute,second<10?@"0":@"",second];
    return timeString;
}

@end
