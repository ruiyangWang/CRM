//
//  YDRequest.h
//  YDCalculateTool
//
//  Created by YD_iOS on 16/6/13.
//  Copyright © 2016年 ios. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^FinishLoadBlock)(NSData *);
typedef void(^FailLoadBlock)(NSString *);

@interface YDRequest : NSMutableURLRequest<NSURLConnectionDataDelegate>

@property(nonatomic,strong)NSMutableData *data;
@property(nonatomic,strong)NSURLConnection *connection;
@property(nonatomic,copy)FinishLoadBlock finishblock;
@property (nonatomic, copy)FailLoadBlock failBlock;

//开始异步请求
- (void)startAsynrc;

//取消异步请求
- (void)cancel;

@end
