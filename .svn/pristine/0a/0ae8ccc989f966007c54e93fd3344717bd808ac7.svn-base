//
//  YDManagerTool.m
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDManagerTool.h"

static YDManagerTool *sharedTool = nil;

@implementation YDManagerTool

#pragma mark - Class methods

+ (YDManagerTool *)sharedTool
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        sharedTool = [[YDManagerTool alloc] init];
    });
    return sharedTool;
}

#pragma mark - public

- (NSDate *)ConvertToZeroInMorning:(NSDate *)aDate
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@", [dateFormatter1 stringFromDate: aDate], @"00:00:00"];
    return [dateFormatter2 dateFromString:timeStr];
}

+ (UIImage *)imageFromView:(UIView *)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
