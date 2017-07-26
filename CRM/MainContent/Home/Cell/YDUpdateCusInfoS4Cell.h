//
//  YDUpdateCusInfoS4Cell.h
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YDUpdateCusInfoS4Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UILabel *noEventLabel;
@property (weak, nonatomic) IBOutlet UITextField *noEventTextField;

@property (nonatomic, copy) NSString *eventType;//存放cell选中状态 111 表示全选
@property (nonatomic, copy) NSString *t;//cell左边的title，根据此title判断cell类型

@property (nonatomic, copy) void (^ClickButtonBlock) (NSString *eType, BOOL setH, NSString *bS);

/**
 是否禁用三个按钮中最后一个按钮
 */
@property (nonatomic, assign) BOOL isDisableLastButton;

@end
