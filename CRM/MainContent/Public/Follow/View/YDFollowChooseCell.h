//
//  YDFollowChooseCell.h
//  CRM
//
//  Created by ios on 16/7/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDFollowChooseCell : UITableViewCell

@property (nonatomic, copy) void (^ChangeBlack) (NSInteger index);


@property (nonatomic, assign) NSInteger selectIndex;

@end