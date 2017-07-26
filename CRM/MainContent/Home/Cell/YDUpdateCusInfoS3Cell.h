//
//  YDUpdateCusInfoS3Cell.h
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDUpdateCusInfoS3Cell : UITableViewCell

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) void (^ChangeBlack) (NSString *str);


/**
 是否禁用最后一个战败按钮
 */
@property (nonatomic, assign) BOOL isDisableLastButton;
@end