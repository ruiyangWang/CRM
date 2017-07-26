//
//  NIDataService.m
//  YDNetwork
//
//  Created by ios on 2017/1/16.
//  Copyright © 2017年 ios. All rights reserved.
//

#import "NIDataService.h"
#import "NIRequest.h"

@implementation NIDataService


+ (NIRequest *)POST:(NSDictionary *)params url:(NSString *)urlString success:(void (^)(id))success failure:(void (^)(id))failure
{
    
    //使用SID
    
    NSString *URL;
    
    if([urlString containsString:@"?"]){
        URL = [NSString stringWithFormat:@"%@&sid=%@",urlString,getNSUser(kUserInfoKey)[@"sid"]];
    }else{
        URL = [NSString stringWithFormat:@"%@?sid=%@",urlString,getNSUser(kUserInfoKey)[@"sid"]];
    }
    
    NIRequest *request = [NIRequest requestWithURL:[NSURL URLWithString:URL]];
    NSMutableData *data = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 20;
    request.HTTPBody = data;
    
    request.finishBlock = ^(NSData *data){
    
        NSDictionary *dic = [NIDataService dataToDictionary:data];
        NSLog(@"请求URL : %@    \n请求参数 ： %@ \n返回数据：%@",URL, params, dic);
        if ([dic[@"msg"] isEqualToString:@"nouserinthissid"] || [dic[@"msg"] isEqualToString:@"sessiontimeout"]) {
            //发送通知跳登录界面
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_Quit object:nil];
        }else{
            success(dic);
        }
    };
    
    request.failBlock = ^(NSString *error){
        NSLog(@"error: %@",error);
        if (failure) {
            failure(error);
        }
    };
    
    [request startAsync];
    
    return request;
}


#pragma mark 把请求下来的数据解转成字典
+ (id)dataToDictionary:(NSData *)data
{
    NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    datastring = [NIDataService deleteSpecialCodeWithString:datastring];//过滤特殊字符
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"id\":" withString:@"\"modelId\":"];
    
    NSData *dataString = [datastring dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:dataString options:NSJSONReadingMutableContainers error:nil];
    
    if (![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"");
    }
    
    return result;
}

+ (id)stringToData:(NSString *)str{
    NSString *datastring = [str stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"id\":" withString:@"\"modelId\":"];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"tagName\":" withString:@"\"insurName\":"];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"&amp;quot;" withString:@"\""];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@" "];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"[{" withString:@"[{"];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"}]\"" withString:@"}]"];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"billingWay\":\"#{carsModel}#{insurCode}#{insurLimit}," withString:@""];

    
    NSData *dataString = [datastring dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:dataString options:NSJSONReadingMutableContainers error:nil];
    return result;
}

//过滤特殊字符
+ (NSString *)deleteSpecialCodeWithString:(NSString *)string
{
    
    NSArray *deleteStrArray = @[@"\r",@"\n",@"\t",@"~"];
    
    __block NSString *str = string;
    
    [deleteStrArray enumerateObjectsUsingBlock:^(NSString *deleteStr, NSUInteger idx, BOOL *stop) {
        
        str = [str stringByReplacingOccurrencesOfString:deleteStr withString:@""];
    }];
    
    return str;
}

//将json字符串 转换为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if (err)
    {
        NSLog(@"json解析失败:%@", err);
        return nil;
    }
    
    return dic;
}

@end
