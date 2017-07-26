//
//  YDCustCellModel.h
//  CRM
//
//  Created by ios on 16/7/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YDCustCellModel : NSObject

@property (nonatomic, copy) NSString *cellName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

/**
 *  提示语
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  是否可以编辑
 */
@property (nonatomic, assign) BOOL isEditing;


/**
 *  是否必填
 */
@property (nonatomic, assign) BOOL isMust;


/**
 *  男女和是否选项
 */
@property (nonatomic, assign) BOOL onORoff;

/**
 *  cell值的设置方式
 *  0不可编辑，没有编辑方式
 *  1代表push选择车型 -> YDSearchCarModelTVC
 *  2代表文字填写
 *  3日历选择
 *  4购车条件选择
 *  5地址选择
 *  6时间选择
 *  7备注跳转
 */
@property (nonatomic, assign) NSString *editMode;


/**
 *  选择按钮类型
 *  1代表性别选择
 *  2代表是否选择
 */
@property (nonatomic, copy) NSString *changeButtonType;


/**
 *  是否显示箭头
 */
@property (nonatomic, assign) BOOL isShowArrow;

/**
 *  是否显示这个cell（默认都显示）
 */
@property (nonatomic, assign) BOOL isShowCell;

/**
 *  客户创建时间，在添加跟进的时候使用，跟进时间要大于创建时间
 */
@property (nonatomic, copy) NSString *custmoerCreateTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellModelWithDict:(NSDictionary *)dict;

@end