//
//  YDUpdateCusInfoS5Cell.h
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDUpdateCusInfoS5Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textInfo;

@property (nonatomic, strong) void (^EndEditBlack) (YDUpdateCusInfoS5Cell *cell, NSString *str);

@end
