//
//  YDTool.h
//  YDCalculateTool
//
//  Created by ios on 16/6/7.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface YDTool : NSObject

///
+ (NSString *)arrayToStringWithArray:(NSArray *)arr;
+ (NSString *)arrayToStringWithDic:(NSDictionary *)dic;

/**
 *  判断手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile;


/**
 *  group类型tableview使用的数组（数组包含数组，下级数组包含cell模型）
 */
+ (NSArray *)cellModelArrayWithCellName:(NSString *)cellName;

/**
 *  pline类型tableview使用的数组（数组包含cell模型）
 */
+ (NSArray *)cellModelWithCellName:(NSString *)cellName;

+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;

/**
 *  获取n天后的时间
 *
 *  @param n 如果n为负数，为n天前的时间
 *
 *  @return 
 */
+ (NSString *)getNDay:(NSInteger)n;

/**
 *  判断是否输入了emoji 表情
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


/**
 判断某个时间是星期几

 @param dateString 时间字符串
 @return 星期几
 */
+ (NSString*)weekdayStringFromDateString:(NSString *)dateString;

@end
