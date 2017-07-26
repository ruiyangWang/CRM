//
//  YDFollowArchivesModel.m
//  CRM
//
//  Created by ios on 16/10/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFollowArchivesModel.h"

@implementation YDFollowArchivesModel


- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        _content = [self dictionaryWithJsonString:value];
    } else {
        [super setValue:value forKey:key];
    }
}

/**
 *  json字符串转字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
