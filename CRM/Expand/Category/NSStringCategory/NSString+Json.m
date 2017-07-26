//
//  NSString+Json.m
//  YDCalculateTool
//
//  Created by YD_iOS on 16/6/13.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)
/** 处理json格式的字符串中的换行符、回车符 */
-(NSString *)deleteSpecialCode {
    
    NSArray *deleteStrArray = @[@"\r",@"\n",@"\t",@"~"];
    
    __block NSString *str = self;
    
    [deleteStrArray enumerateObjectsUsingBlock:^(NSString *deleteStr, NSUInteger idx, BOOL *stop) {
        
        str = [str stringByReplacingOccurrencesOfString:deleteStr withString:@""];
    }];
    
    return str;
}


+ (NSString*)jsonStringWithDictionart:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
