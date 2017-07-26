//
//  NSDate+YDString.h
//  CRM
//
//  Created by YD_iOS on 16/7/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YDString)

+ (NSString *)dayWithDateOffset:(NSInteger)count;
+ (NSString *)monthWithDateOffset:(NSInteger)count;

+ (NSDate *)dateWithString:(NSString *)str format:(NSString*)format;
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString*)format;

///判断date是今天还是昨天
+(NSString *)compareDate:(NSDate *)date;

///返回今天和今天之后的4天 字符串 yyyy-MM-dd
+ (NSArray *)nowAndAfter;

///对时间排序
+ (NSArray *)returnNewArray:(NSArray *)arr;

@end
