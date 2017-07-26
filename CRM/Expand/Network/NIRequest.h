//
//  NIRequest.h
//  YDNetwork
//
//  Created by ios on 2017/1/17.
//  Copyright © 2017年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinishLoadBlock)(NSData *data);
typedef void(^FailLoadBlock)(NSString *);

@interface NIRequest : NSMutableURLRequest

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, copy) FinishLoadBlock finishBlock;
@property (nonatomic, copy) FailLoadBlock failBlock;

//开始异步请求
- (void)startAsync;

//取消请求
- (void)cancel;


@end
