//
//  YDDataService.h
//  YDCalculateTool
//
//  Created by YD_iOS on 16/6/13.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(id result);
typedef void(^FailBlock)(id error);
@class YDRequest;

/*
 * 网络请求类
 */
@interface YDDataService : NSObject

//Post Request 
+ (YDRequest *)startRequest:(NSDictionary *)params
                 url:(NSString *)urlstring
               block:(Completion)block
           failBlock:(FailBlock)failBlock;

+(id)dataToDictionary:(NSData *)data;
+(id)stringToData:(NSString *)str;

//Post sync Request
+ (YDRequest *)startSyncRequest:(NSDictionary *)params
                        url:(NSString *)urlstring
                      block:(Completion)block
                  failBlock:(FailBlock)failBlock;

@end
