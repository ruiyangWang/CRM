//
//  YDSearchCell.m
//  CRM
//
//  Created by ios on 16/8/31.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDSearchCell.h"
#import "YDCustListModel.h"

@interface YDSearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@end
@implementation YDSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.noLabel.hidden = YES;
    self.noLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCustModel:(YDCustListModel *)custModel
{
    _custModel = custModel;
    
    self.titleLabel.text = custModel.customerName;
    
    self.subTitleLabel.text = custModel.carTypeName;
    
    if ([custModel.customerName isEqualToString:@"无"]) {
        self.noLabel.hidden = NO;
        self.titleLabel.hidden = YES;
    } else {
        self.noLabel.hidden = YES;
        self.titleLabel.hidden = NO;
    }
}

@end
