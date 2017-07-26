//
//  YDFollowChooseCell.m
//  CRM
//
//  Created by ios on 16/7/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFollowChooseCell.h"


@interface YDFollowChooseCell ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@end
@implementation YDFollowChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftButton.backgroundColor = kNavigationBackgroundColor;
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = kViewControllerBackgroundColor;
    [self.rightButton setTitleColor:[UIColor colorWithRed:180 green:180 blue:180] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftButtonClick:(UIButton *)sender {
    
    self.leftButton.backgroundColor = kNavigationBackgroundColor;
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = kViewControllerBackgroundColor;
    [self.rightButton setTitleColor:[UIColor colorWithRed:180 green:180 blue:180] forState:UIControlStateNormal];
    
    if (self.ChangeBlack) {
        self.ChangeBlack(1);
    }
}
- (IBAction)rightButtonClick:(UIButton *)sender {
    
    self.rightButton.backgroundColor = kNavigationBackgroundColor;
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.backgroundColor = kViewControllerBackgroundColor;
    [self.leftButton setTitleColor:[UIColor colorWithRed:180 green:180 blue:180] forState:UIControlStateNormal];

    if (self.ChangeBlack) {
        self.ChangeBlack(2);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (selectIndex == 0) {
        self.leftButton.backgroundColor = kNavigationBackgroundColor;
        [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightButton.backgroundColor = kViewControllerBackgroundColor;
        [self.rightButton setTitleColor:[UIColor colorWithRed:180 green:180 blue:180] forState:UIControlStateNormal];
    } else {
        self.rightButton.backgroundColor = kNavigationBackgroundColor;
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.leftButton.backgroundColor = kViewControllerBackgroundColor;
        [self.leftButton setTitleColor:[UIColor colorWithRed:180 green:180 blue:180] forState:UIControlStateNormal];
    }
}

@end