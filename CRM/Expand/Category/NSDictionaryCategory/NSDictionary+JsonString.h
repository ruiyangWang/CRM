//
//  NSDictionary+JsonString.h
//  CRM
//
//  Created by ios on 2017/3/9.
//  Copyright © 2017年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonString)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
