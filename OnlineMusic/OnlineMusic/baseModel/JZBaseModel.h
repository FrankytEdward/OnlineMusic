//
//  JZGetValueInDictionary.h
//  Text01
//
//  Created by 杨珺舟 on 15-1-25.
//  Copyright (c) 2015年 Allen. All rights reserved.
//






/***
 *                  工具
 **   1.用于将model类转换成Dictionary 或者 JsonString
 *    2.用dictionary初始化Model
 */



#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface JZBaseModel : NSObject
// Model -> Dictionary
-(NSDictionary*)toDictionary;
//Model ->Json
-(NSString*)TOjsonString;
//dictionary -> Model
-(id)initWithDic:(NSDictionary *)dic;

@end
