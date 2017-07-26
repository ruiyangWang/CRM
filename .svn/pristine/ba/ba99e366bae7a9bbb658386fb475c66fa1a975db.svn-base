//
//  NIRequest.m
//  YDNetwork
//
//  Created by ios on 2017/1/17.
//  Copyright © 2017年 ios. All rights reserved.
//

#import "NIRequest.h"

@interface NIRequest () <NSURLConnectionDelegate>

@end

@implementation NIRequest 

- (void)startAsync
{
    _data = [NSMutableData data];
    
    //发送异步请求
    _connection = [NSURLConnection connectionWithRequest:self delegate:self];
}

- (void)cancel
{
    [_connection cancel];
}


#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.finishBlock(_data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *domain = [error localizedDescription];
    self.failBlock (domain);
    
}

@end
