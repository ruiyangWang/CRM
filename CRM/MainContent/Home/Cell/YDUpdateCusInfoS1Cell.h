//
//  YDUpdateCusInfoS1Cell.h
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellType ){
    CellTypeMan,
    CellTypeBool
};
@class YDSwith;
@interface YDUpdateCusInfoS1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *t;
@property (weak, nonatomic) IBOutlet UITextField *subT;
@property (weak, nonatomic) IBOutlet YDSwith *swithView;

@property (nonatomic, assign) CellType cellType;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subString;
@property (nonatomic, assign) BOOL onORoff;
@property (nonatomic, assign) BOOL isMust;

@property (nonatomic, strong) void (^ChangeBlack) (NSString *str);
@property (nonatomic, strong) void (^EndEditBlack) (NSString *str);

@end
