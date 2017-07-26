//
//  Singleton.h
//
//  Created by joshua on 14-5-8.
//  Copyright (c) 2014年 joshua. All rights reserved.
//

// .h
#define SINGLE_INTERFACE(class) + (class *)shared##class;

// .m
// \ 代表下一下也属于宏
// ## 是分隔符
#define SINGLE_IMPLEMENTATION(class) \
static class *_instance; \
 \
+ (class *)shared##class \
{ \
   @synchronized(self){ \
      if(_instance == nil)\
      {\
         _instance = [[self alloc] init]; \
       } \
    return _instance; \
   }\
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
}