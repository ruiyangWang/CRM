//
//  YDUpdateCusInfoS1Cell.m
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUpdateCusInfoS1Cell.h"
#import "YDSwith.h"

@interface YDUpdateCusInfoS1Cell()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *blueMake;

@end

@implementation YDUpdateCusInfoS1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _subT.delegate = self;
    
    _swithView.ClickButtonBlack = ^(NSString *str ){
        if (_ChangeBlack != nil) {
            _ChangeBlack(str);
        }
    };
}

-(void)setCellType:(CellType)cellType{
    _cellType = cellType;
    
    _swithView.colorStyle = (NSInteger)_cellType;

    if (cellType == CellTypeMan) {
        _subT.hidden = NO;
    } else {
        _subT.hidden = YES;
    }
}
-(void)setName:(NSString *)name{
    _name = name;
    _t.text = name;
}
-(void)setSubString:(NSString *)subString{
    _subString = subString;
    _subT.text = subString;    
}
-(void)setOnORoff:(BOOL)onORoff{
    _onORoff = onORoff;
    
    _swithView.onORoff = onORoff;
    
}
-(void)setIsMust:(BOOL)isMust{
    _isMust = isMust;
    
    _blueMake.alpha = _isMust?1:0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_EndEditBlack != nil) {
        _EndEditBlack(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (self.EndEditBlack) {
        self.EndEditBlack(_subT.text);
    }
    
//    if (textField == self.subTitle) {
//        if (string.length == 0) return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > self.textLongest) {
//            return NO;
//        }
//    }
    
    return YES;
}


@end
