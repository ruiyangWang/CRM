//
//  YDChineseString.m
//  CRM
//
//  Created by YD_iOS on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDChineseString.h"

@implementation YDChineseString

#pragma mark - 返回tableview右方 indexArray
+(NSMutableArray*)indexArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *A_Result = [NSMutableArray array];
    NSString *tempString ;
    
    for (NSString* object in tempArray)
    {
        NSString *pinyin = [((YDChineseString*)object).pinYin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            [A_Result addObject:pinyin];
            tempString = pinyin;
        }
    }
    return A_Result;
}

#pragma mark - 返回联系人
+(NSMutableArray*)letterSortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *LetterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString;
    //拼音分组
    for (NSString* object in tempArray) {
        
        NSString *pinyin = [((YDChineseString*)object).pinYin substringToIndex:1];
        NSString *string = ((YDChineseString*)object).string;
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            [item  addObject:string];
            [LetterResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            [item  addObject:string];
        }
    }
    return LetterResult;
}

#pragma mark - 返回排序好的字符拼音
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++)
    {
        YDChineseString *chineseString = [[YDChineseString alloc]init];
        chineseString.string = [NSString stringWithString:[stringArr objectAtIndex:i]];
        if(chineseString.string == nil){
            chineseString.string = @"";
        }
        //去除两端空格和回车
        chineseString.string  = [chineseString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        chineseString.string = [YDChineseString RemoveSpecialCharacter:chineseString.string];
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [chineseString.string length]?[chineseString.string substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            NSLog(@"chineseString.string== %@",chineseString.string);
            //首字母大写
            chineseString.pinYin = [chineseString.string capitalizedString] ;
        }else{
            if(![chineseString.string isEqualToString:@""]){
                NSString *pinYinResult = [NSString string];
                for(int j=0;j<chineseString.string.length;j++){
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin = pinYinResult;
            }else{
                chineseString.pinYin = @"";
            }
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
}

#pragma mark - 返回一组字母排序数组
+(NSMutableArray*)sortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result = [NSMutableArray array];
    for(int i=0;i<[stringArr count];i++){
        [result addObject:((YDChineseString*)[tempArray objectAtIndex:i]).string];
    }
    return result;
}

//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
+(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

@end
