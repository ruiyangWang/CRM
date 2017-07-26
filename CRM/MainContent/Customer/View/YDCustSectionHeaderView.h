//
//  YDCustSectionHeaderView.h
//  CRM
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^OpenCellBlock)(BOOL isOpen);

@interface YDCustSectionHeaderView : UIView

@property (nonatomic, copy) OpenCellBlock openCellBlock;

+ (instancetype)custSectionHeaderViewWithTitle:(NSString *)title;

@end
