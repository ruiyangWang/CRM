//
//  YDSwith.h
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ColorStyle) {
    ColorStyle1,
    ColorStyle2
};

@interface YDSwith : UIView

@property (nonatomic, assign) ColorStyle colorStyle;
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, assign) BOOL onORoff;
@property (nonatomic, strong) void (^ClickButtonBlack) (NSString *str);
@end
