//
//  NIDataService.h
//  YDNetwork
//
//  Created by ios on 2017/1/16.
//  Copyright © 2017年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIRequest;
@interface NIDataService : NSObject


/**
 POST请求
 @param params 请求参数
 @param urlString 请求地址
 @param success 请求成功block
 @param failure 请求失败block
 */
+ (NIRequest *)POST:(NSDictionary *)params
         url:(NSString *)urlString
     success:(void(^)(id response))success
     failure:(void(^)(id error))failure;


@end
