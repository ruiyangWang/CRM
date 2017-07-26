//
//  YDColor.h
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#ifndef YDColor_h
#define YDColor_h


#endif /* YDColor_h */

//导航栏背景颜色 大部分蓝色都是用这个
#define kNavigationBackgroundColor         [UIColor colorWithHexString:@"528ECD"]

//bar 线条颜色
#define kBarLineColor         [UIColor colorWithRed:168 / 255.0f green:168 / 255.0f blue:168 / 255.0f alpha:1.0f]

//所有viewController背景色
#define kViewControllerBackgroundColor         [UIColor colorWithRed:241 / 255.0f green:241 / 255.0f blue:241 / 255.0f alpha:1.0f]


/**
 蓝色按钮的高亮颜色
 */
#define kBlueHeighBackgroundColor         [UIColor colorWithHexString:@"4677AA"]

/**
 绿色按钮的高亮颜色
 */
#define kGreenHeighBackgroundColor         [UIColor colorWithHexString:@"44A592"]

/**
 红色按钮的高亮颜色
 */
#define kRedHeighBackgroundColor         [UIColor colorWithHexString:@"B74C4C"]

//绿色按钮背景色
#define kGreenButtonBackgroundColor         [UIColor colorWithRed:82 / 255.0f green:205 / 255.0f blue:181 / 255.0f      alpha:1.0f]

//红色按钮背景色
#define kRedButtonBackgroundColor         [UIColor colorWithRed:242 / 255.0f green:110 / 255.0f blue:110 / 255.0f       alpha:1.0f]

//按钮未选择时灰色背景
#define kGrayButtonBackgroundColor         [UIColor colorWithRed:235 / 255.0f green:235 / 255.0f blue:235 / 255.0f      alpha:1.0f]

//事件选中
#define kEventButtonBackgroundColor         [UIColor colorWithRed:152 / 255.0f green:188 / 255.0f blue:123 / 255.0f     alpha:1.0f]

//客户性别选择
//女
#define kWomanBackgroundColor         [UIColor colorWithRed:211 / 255.0f green:124 / 255.0f blue:170 / 255.0f           alpha:1.0f]

//男
#define kManBackgroundColor         [UIColor colorWithRed:82 / 255.0f green:142 / 255.0f blue:205 / 255.0f              alpha:1.0f]

//意向客户cell
//添加跟进
#define kAddFollowUpBackgroundColor         [UIColor colorWithRed:84 / 255.0f green:142 / 255.0f blue:205 / 255.0f      alpha:1.0f]
//拨打电话 同 绿色按钮背景色
#define kCallUserBackgroundColor                                                                                        kGreenButtonBackgroundColor

//家庭情况三种颜色
//单身
#define kSingleBackgroundColor         [UIColor colorWithRed:216 / 255.0f green:182 / 255.0f blue:40 / 255.0f           alpha:1.0f]
//已婚
#define kMarriedBackgroundColor         [UIColor colorWithRed:229 / 255.0f green:95 / 255.0f blue:95 / 255.0f           alpha:1.0f]
//已育
#define kMarriedAndParentBackgroundColor         [UIColor colorWithRed:174 / 255.0f green:90 / 255.0f blue:162 / 255.0f alpha:1.0f]

//意向级别
//A
#define kABackgroundColor         [UIColor colorWithRed:225 / 255.0f green:79 / 255.0f blue:27 / 255.0f                alpha:1.0f]
//B
#define kBBackgroundColor         [UIColor colorWithRed:239 / 255.0f green:166 / 255.0f blue:16 / 255.0f                alpha:1.0f]
//C
#define kCBackgroundColor         [UIColor colorWithRed:57 / 255.0f green:175 / 255.0f blue:210 / 255.0f                alpha:1.0f]
//H
#define kHBackgroundColor         [UIColor colorWithRed:201 / 255.0f green:7 / 255.0f blue:69 / 255.0f alpha:1.0f]
//战败
#define kDefeatBackgroundColor         [UIColor colorWithRed:56 / 255.0f green:131 / 255.0f blue:231 / 255.0f alpha:1.0f]
//订
#define kOrderBackgroundColor         [UIColor colorWithRed:82 / 255.0f green:141 / 255.0f blue:204 / 255.0f alpha:1.0f]
//交 同 绿色按钮背景色
#define kDeliveryBackgroundColor         kGreenButtonBackgroundColor
//取 同 红色按钮背景色
#define kGetBackgroundColor         kRedButtonBackgroundColor

//一级文字颜色
#define kOneTextColor  [UIColor colorWithRed:75 / 255.0f green:75 / 255.0f blue:75 / 255.0f alpha:1.0f]
//二级文字颜色
#define kTwoTextColor  [UIColor colorWithRed:104 / 255.0f green:104 / 255.0f blue:104 / 255.0f alpha:1.0f]
//三级文字颜色
#define kThreeTextColor  [UIColor colorWithRed:190 / 255.0f green:190 / 255.0f blue:190 / 255.0f alpha:1.0f]

//所有表格的分割线
#define kTableViewLineColor [UIColor colorWithRed:227 / 255.0f green:227 / 255.0f blue:227 / 255.0f alpha:1.0f]

//圆环上面的红色 同 红色按钮背景色

//圆环上面的蓝色 同 导航栏背景颜色



//通知名称
//刷新客户列表
#define kUpdateCustListNotification  @"updateCustListNotification"

//客户添加跟进成功
#define kAddFollowSuccessNotification @"addFollowSuccessNotification"

//客户添加跟进成功 并且点击了下订事件，使意向客户成为了订单客户
#define kAddOrderFollowSuccessNotification @"addOrderFollowSuccessNotification"

//日历选择取消
#define kDateChooseCancleNotification  @"kDateChooseCancleNotification"

//刷新订单客户详情通知
#define kUpdateOrderCustDetailNotification @"updateOrderCustDetailNotification"