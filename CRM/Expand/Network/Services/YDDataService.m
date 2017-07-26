//
//  YDDataService.m
//  YDCalculateTool
//
//  Created by YD_iOS on 16/6/13.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "YDDataService.h"
#import "YDRequest.h"
#import "NSString+Json.h"
#import "NSString+URLEncoding.h"

@implementation YDDataService
+ (YDRequest *)startRequest:(NSDictionary *)params
                 url:(NSString *)urlstring
               block:(Completion)block
           failBlock:(FailBlock)failBlock
{
    

    NSMutableData *data = [[NSMutableData alloc] init];
    
    YDRequest *request = [YDRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    if (![urlstring hasSuffix:@"admin-webapp/loginapi/token"]) {
        data = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    }else{
        NSMutableString *bodyMString = [NSMutableString string];
        for (NSString *key in params.allKeys) {
            [bodyMString appendString:[NSString stringWithFormat:@"%@=%@&",key,params[key]]];
        }
        
        if (bodyMString.length > 0) {
            bodyMString = [NSMutableString stringWithString:[bodyMString substringToIndex:bodyMString.length-1]];
        }
        
        [data appendData:[bodyMString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }

    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setHTTPBody:data];
    
    request.finishblock = ^(NSData *data) {
        NSDictionary *dic = [YDDataService dataToDictionary:data];
        
        NSLog(@"请求URL : %@    \n请求参数 ： %@ \n返回数据：%@",urlstring, params, dic);

        block(dic);
    };
    request.failBlock = ^(NSString *failInfo){
        NSLog(@"error: %@",failInfo);
        if (failBlock) {
            failBlock(failInfo);
        }
    };
    [request startAsynrc];
    return request;

}

+ (YDRequest *)startSyncRequest:(NSDictionary *)params
                            url:(NSString *)urlstring
                          block:(Completion)block
                      failBlock:(FailBlock)failBlock
{

    NSMutableData *data = [[NSMutableData alloc] init];
    
    YDRequest *request = [YDRequest requestWithURL:[NSURL URLWithString:urlstring]];
    data = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setHTTPBody:data];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (returnData && block) {
        NSDictionary *dic = [YDDataService dataToDictionary:returnData];
        
        NSLog(@"请求URL : %@    \n请求参数 ： %@ \n返回数据：%@",urlstring, params, dic);

        block(dic);
    }
    
    if (error && failBlock) {
        failBlock(error.description);
    }
    
    return request;
}

+ (YDRequest *)startRequest:(NSDictionary *)params
                        url:(NSString *)urlstring
                      isGet:(BOOL)get
                      block:(Completion)block
                  failBlock:(FailBlock)failBlock
{
    //url编码
    urlstring = [urlstring URLDecodedString];
    YDRequest  *request = [YDRequest requestWithURL:[NSURL URLWithString:urlstring]];
    if (get) {
        [request setHTTPMethod:@"GET"];
    } else {
        
    }

    [request setTimeoutInterval:20];
    request.finishblock = ^(NSData *data) {
        NSDictionary *dic = [YDDataService dataToDictionary:data];
        
        NSLog(@"请求URL : %@    \n请求参数 ： %@ \n返回数据：%@",urlstring, params, dic);

        block(dic);
    };
    request.failBlock = ^(NSString *failInfo){
        NSLog(@"ks error: %@",failInfo);
        if (failBlock) {
            failBlock(failInfo);
        }
    };
    [request startAsynrc];
    return request;
}
#pragma mark 把请求下来的数据解转成字典
+(id)dataToDictionary:(NSData *)data
{
    NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    datastring = [datastring deleteSpecialCode];//过滤特殊字符
    datastring = [datastring stringByReplacingOccurrencesOfString:@"\"id\":" withString:@"\"modelId\":"];
 
    NSData *dataString = [datastring dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:dataString options:NSJSONReadingMutableContainers error:nil];
    
    if (![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"");
    }

    return result;
}

+(id)stringToData:(NSString *)str{
    NSString *datastring = [str stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    NSData *dataString = [datastring dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:dataString options:NSJSONReadingMutableContainers error:nil];
    return result;
}

@end
