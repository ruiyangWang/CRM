//
//  YDUpdateCusInfoS2Cell.h
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDUpdateCusInfoS2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *subTitle;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *subTitleString;
@property (nonatomic, assign) BOOL isMust;
@property (nonatomic, assign) BOOL ud;//cell.subTitle.userInteractionEnabled

@property (nonatomic, assign) BOOL showNextButton;

/**
 是否在键盘上显示带完成的工具条(默认是不显示的，使用数字键盘的时候没有完成按钮，需要显示)
 */
@property (nonatomic, assign) BOOL isShowDoneTool;


/**
 限制输入文字的长度，默认无限制
 */
@property (nonatomic, assign) NSInteger textLongest;

@property (nonatomic, strong) void (^EndEditBlack) (YDUpdateCusInfoS2Cell *cell , NSString *str);


/**
 点击键盘的return按钮调用的方法，原来和返回输入内容的block共用，现在点击return只退出键盘，重制tableView的contentOffset
 */
@property (nonatomic, copy) void (^ReturnBlack) (void);

@end
