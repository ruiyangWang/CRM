//
//  YDUpdateCusInfoS4Cell.m
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUpdateCusInfoS4Cell.h"

@interface YDUpdateCusInfoS4Cell()

@property (weak, nonatomic) IBOutlet UILabel *tLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (copy, nonatomic) NSArray *hColors;   //点击之后，通过改变hColors的颜色值来改变状态
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSMutableArray *colorType;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@end

@implementation YDUpdateCusInfoS4Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setT:(NSString *)t{
    _t = t;
    if ([t isEqualToString:@"事件"]) {
        _tLabel.text = t;
        _subLabel.text = @"（多选）";
        _hColors = @[[UIColor colorWithHexString:@"98BC7B"],
                     [UIColor colorWithHexString:@"D8B628"],
                     [UIColor colorWithHexString:@"E55F5F"]];
        _titles = @[@"报价",@"试驾",@"下订"];
    }else{
        _tLabel.text = t;
        _subLabel.text = @"";
        _hColors = @[[UIColor colorWithHexString:@"D8B628"],
                     [UIColor colorWithHexString:@"E55F5F"],
                     [UIColor colorWithHexString:@"AE5AA2"]];
        _titles = @[@"单身",@"已婚",@"已育"];

    }
    
    for (int i=10000; i<10003; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        [button setTitle:_titles[i-10000] forState:(UIControlStateNormal)];
    }
}

-(void)setEventType:(NSString *)eventType{
    
    if ([eventType isKindOfClass:[NSString class]]) {
        _eventType = eventType;
        
        NSInteger et = [eventType integerValue];
        _colorType = [NSMutableArray arrayWithArray:@[@(et/100),@((et%100)/10),@(et%10)]];
        
        for (int i=0; i<3; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:10000+i];
            [self changeColor:button];
        }
    }else{
        _colorType = [NSMutableArray arrayWithArray:@[@0, @0, @0]];
        if ([eventType integerValue] > 0 && [eventType integerValue] < 4) {
            _colorType[[eventType integerValue]-1] = @1;
        }
        UIButton *button = (UIButton *)[self viewWithTag:10000+[eventType integerValue]-1];
        [self changeColor:button];
    }
   
}

- (IBAction)clickButton:(UIButton *)sender {
    
    //多选，不需要清空之前的数据；单选，清空之前的数据，
    if ([_t isEqualToString:@"事件"]) {
        BOOL b = [_colorType[sender.tag-10000] boolValue];
        _colorType[sender.tag - 10000] = [NSNumber numberWithBool:!b];
 
        [self changeColor:sender];
        
    }else{
        
        _colorType = [NSMutableArray arrayWithArray:@[@0,@0,@0]];
        _colorType[sender.tag-10000] = @1;
        
        for (int i=10000; i<10003; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:i];
            [self changeColor:button];
        }
    }
    
    if(_ClickButtonBlock != nil){
        NSString *s = [NSString stringWithFormat:@"%@%@%@",_colorType[0],_colorType[1],_colorType[2]];
        _ClickButtonBlock(s, [_colorType[sender.tag-10000] boolValue], _titles[sender.tag-10000]);
    }
}

- (void)changeColor:(UIButton *)sender{

    BOOL buttonIsH = [_colorType[sender.tag-10000] boolValue];
    
    if (_hColors != nil) {
        if (buttonIsH) {
            sender.backgroundColor = _hColors[sender.tag-10000];
            [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }else{
            sender.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
            [sender setTitleColor:[UIColor colorWithHexString:@"444444"] forState:(UIControlStateNormal)];
        }
    }
}

- (void)setIsDisableLastButton:(BOOL)isDisableLastButton
{
    _isDisableLastButton = isDisableLastButton;
    
    if (_isDisableLastButton) {
        self.threeButton.alpha = 0.5f;
        self.threeButton.enabled = NO;
    } else {
        self.threeButton.alpha = 1.0f;
        self.threeButton.enabled = YES;
    }
}

@end
