//
//  JZGetValueInDictionary.m
//  Text01
//
//  Created by 杨珺舟 on 15-1-25.
//  Copyright (c) 2015年 Allen. All rights reserved.
//

#import "JZBaseModel.h"
#import "RMMapper.h"

@implementation JZBaseModel
-(NSDictionary*)toDictionary{
    NSMutableDictionary* mydictionary = [NSMutableDictionary dictionary];
    Class  own = [self class];
    unsigned int ivarsCnt = 0;
    Ivar* ivars = class_copyIvarList(own, &ivarsCnt);
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        // 也可以截取字符串 去掉_
        
     
        //　获取变量值
        id value = [self valueForKey:key];
        //
      //　取得变量类型
      // 通过 type[0]可以判断其具体的内置类型
//       
//        const char *type = ivar_getTypeEncoding(ivar);
//        NSLog(@"char :%s", type);
//        if (type[0]==) {
//
//        }
        
        if (value)
        {
            key = [key substringFromIndex:1];//从指定的索引开始（包含该索引位置）截取到字符串末尾
            [mydictionary setObject:value forKey:key];
        }
    }
    return mydictionary;
}


-(NSString*)TOjsonString
{
   
    NSDictionary* dic = [self toDictionary];

    [self checkDictionary:dic];
    
       NSString * sStr;
    NSArray *array = [ NSArray arrayWithObjects:dic, nil];
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSData* data=[NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
        sStr = [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
    }else {
      
        return @"error:have Undefined type in dictionary";
    }
    if (!sStr) {
      
        return @"dictionary is empty";
    }

    return  sStr;
    
    
}

-(NSString*)TOjsonStringFromDic:(NSDictionary*) dic
{
    
    [self checkDictionary:dic];
    
    NSString * sStr;
    NSArray *array = [ NSArray arrayWithObjects:dic, nil];
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSData* data=[NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
        sStr = [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
    }else {
       
        return @"error:have Undefined type in dictionary";
    }
    if (!sStr) {
       
        return @"dictionary is empty";
    }
    
    return  sStr;
    
    
}



- (void)checkDictionary:(NSDictionary*)dict
{
    NSArray *keys;
    int i;
    NSInteger count;
    id key, value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        //确保 Model中有自定义的类时  也需要转换
        if( [[value class] instancesRespondToSelector: @selector(TOjsonString)] == YES ) {
           
           NSString* str = [value TOjsonString];
           
           [dict setValue:str forKey:key];
       }
        if([value  isKindOfClass:[NSDictionary class]]==YES){
            
           NSString * str = [self TOjsonStringFromDic:value];
            [dict setValue: str forKey:key];
        
            }
        if ([value isKindOfClass:[NSArray class]]==YES) {
            
        }
    }

}
-(id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        [RMMapper populateObject:self fromDictionary:dic];
        
    }
    return self;
}

-(NSString *)description
{
    NSMutableDictionary * props = [NSMutableDictionary dictionary];
    unsigned int outCount;
    
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i<outCount; i++) {
        objc_property_t  property = properties[i];
        const char * chat_f = property_getName(property);
        NSString * propertyName = [NSString stringWithUTF8String:chat_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) {
            [props setObject:propertyValue forKey:propertyName];
        }
        
        //        free(properties);
    }
    
    NSString * showStr = @"";
    for (NSString * key in props.allKeys) {
        NSString * valueStr = props[key];
        showStr = [showStr stringByAppendingFormat:@"%@:%@  ",key,valueStr];
    }
    return showStr;
}

//
//   class_copyPropertyList返回的仅仅是对象类的属性(@property申明的属性)，而class_copyIvarList返回类的所有属性和变量(包括在@interface大括号中声明的变量)，下面做个简单的测试。首先，定义一个WFrequencyManager类


@end
