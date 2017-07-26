//
//  YDPickView.h
//  CRM
//
//  Created by YD_iOS on 16/8/3.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YDPickType) {
    YDPickViewNone,
    YDPickViewDate,
    YDPickViewDateAndTime,
};

@interface YDPickView : UIView

- (instancetype )initWithView:(UITextField *)tView type:(YDPickType)t;

@property (nonatomic, strong) void (^ClickFinishButtonBlock) (NSString *str, NSDate *date );

@end
