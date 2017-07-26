//
//  YDRequest.m
//  YDCalculateTool
//
//  Created by YD_iOS on 16/6/13.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "YDRequest.h"

@implementation YDRequest

- (void)startAsynrc {
    
    _data = [NSMutableData data];
    
    //发送异步请求
    _connection = [NSURLConnection connectionWithRequest:self delegate:self];
}

- (void)cancel {
    [_connection cancel];
}


#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.finishblock(_data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *domain = [error localizedDescription];
    self.failBlock (domain);
    
}


@end
