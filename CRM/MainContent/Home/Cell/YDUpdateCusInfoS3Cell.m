//
//  YDUpdateCusInfoS3Cell.m
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUpdateCusInfoS3Cell.h"

@interface YDUpdateCusInfoS3Cell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;

@end

@implementation YDUpdateCusInfoS3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    
    _titleLabel.text = titleName;
}

- (IBAction)clickButton:(UIButton *)sender {
    
    for (int i=10000; i<10005; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        
        if (button.tag == sender.tag) {
            switch (i) {
                case 10000:
                    [button setBackgroundColor:kHBackgroundColor];
                    break;
                case 10001:
                    [button setBackgroundColor:kABackgroundColor];
                    break;
                case 10002:
                    [button setBackgroundColor:kBBackgroundColor];
                    break;
                case 10003:
                    [button setBackgroundColor:kCBackgroundColor];
                    break;
                case 10004:
                    [button setBackgroundColor:kDefeatBackgroundColor];
                    break;
                default:
                    break;
            }
            
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }else{
            [button setBackgroundColor:[UIColor colorWithHexString:@"FAFAFA"]];
            [button setTitleColor:[UIColor colorWithHexString:@"444444"] forState:(UIControlStateNormal)];
        }
    }
    
    if (_ChangeBlack != nil) {
        NSString *t = [sender titleForState:(UIControlStateNormal)];
        NSDictionary *ts = @{@"H级":@"H",@"A级":@"A",@"B级":@"B",@"C级":@"C",@"战败":@"战败",};
        _ChangeBlack(ts[t]);
    }
}

- (void)setIsDisableLastButton:(BOOL)isDisableLastButton
{
    _isDisableLastButton = isDisableLastButton;
    
    if (_isDisableLastButton) {
        self.lastButton.alpha = 0.5f;
        self.lastButton.enabled = NO;
    } else {
        self.lastButton.alpha = 1.0f;
        self.lastButton.enabled = YES;
    }
}

@end
