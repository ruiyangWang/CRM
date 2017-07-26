//
//  YDTool.m
//  YDCalculateTool
//
//  Created by ios on 16/6/7.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "YDTool.h"
#import "YDCustCellModel.h"

@implementation YDTool


+ (NSString *)arrayToStringWithArray:(NSArray *)arr{
    
    if (arr == nil) {
        return @"";
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    return jsonString;
}

+ (NSString *)arrayToStringWithDic:(NSDictionary *)dic{
    
    if (dic == nil) {
        return @"";
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    return jsonString;
}


/**
 *  判断手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

+ (NSArray *)cellModelArrayWithCellName:(NSString *)cellName
{

    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"CustomerCell" ofType:@"plist"];
    NSDictionary *cellDict = [NSDictionary dictionaryWithContentsOfFile:pathString];
    
    //tebleview 每组
    NSArray *groupArray = [cellDict objectForKey:cellName];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSArray *cellArray in groupArray) {
        NSMutableArray *groupCellArray = [NSMutableArray array];
        for (NSDictionary *cellDic in cellArray) {
            YDCustCellModel *cellModel = [YDCustCellModel cellModelWithDict:cellDic];
            [groupCellArray addObject:cellModel];
        }
        [dataArray addObject:groupCellArray];
    }
    
    return dataArray;
}

+ (NSArray *)cellModelWithCellName:(NSString *)cellName
{
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"CustomerCell" ofType:@"plist"];
    NSDictionary *cellDict = [NSDictionary dictionaryWithContentsOfFile:pathString];
    //tebleview 每组
    NSArray *cellArray = [cellDict objectForKey:cellName];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *cellDic in cellArray) {
        YDCustCellModel *cellModel = [YDCustCellModel cellModelWithDict:cellDic];
        [dataArray addObject:cellModel];
    }
    
    return dataArray;
}

#pragma mark - 获取用户的通讯录权限
+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error)
                                                         {
                                                             NSLog(@"Error: %@", (__bridge NSError *)error);
                                                         }
                                                         else if (!granted)
                                                         {
                                                             
                                                             block(NO);
                                                         }
                                                         else
                                                         {
                                                             block(YES);
                                                         }
                                                     });
                                                 });
    }
    else
    {
        block(YES);
    }
    
}


#pragma mark 获取n天后的时间
+ (NSString *)getNDay:(NSInteger)n
{
    
    NSDate *nowDate = [NSDate date];

    NSDate *theDate;

    if(n!=0)
    {
        NSTimeInterval oneDay = 24 * 60 * 60 * 1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDay * n];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }
    else
    {
        
        theDate = nowDate;
    }

    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];

    return the_date_str;
}

//判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                    
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (NSString*)weekdayStringFromDateString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *inputDate = [formatter dateFromString:dateString];
    
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六",  nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end
