//
//  YDUpdateCusInfoS2Cell.m
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUpdateCusInfoS2Cell.h"
#import "YDTool.h"

@interface YDUpdateCusInfoS2Cell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonW;
@property (weak, nonatomic) IBOutlet UIView *blueMake;

@property (nonatomic, strong) UIToolbar *doneToolBar; //数字键盘上需要添加的

@end

@implementation YDUpdateCusInfoS2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _subTitle.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _title.text = titleString;
    
    //默认值
    self.textLongest = 1000;
    self.subTitle.keyboardType = UIKeyboardTypeDefault;
    self.isShowDoneTool = NO;
    
    //联系电话限制
    if ([_title.text isEqualToString:@"联系电话"]) {
        self.textLongest = 11;
        self.subTitle.keyboardType = UIKeyboardTypeNumberPad;
        self.isShowDoneTool = YES;
    }
    //身份证号限制
    if ([_title.text isEqualToString:@"身份证号"]) {
        self.textLongest = 18;
    }
    //报价金额限制
    if ([_title.text isEqualToString:@"报价金额"]) {
        self.subTitle.keyboardType = UIKeyboardTypeNumberPad;
        self.isShowDoneTool = YES;
    }
    
}
-(void)setSubTitleString:(NSString *)subTitleString{
    
    _subTitleString = subTitleString;
    
    if ([_titleString isEqualToString:@"跟进时间"] || [_titleString isEqualToString:@"下次跟进时间"] || [_titleString isEqualToString:@"提车时间"]) {
        //2016-12-08 18:46:32
        if (subTitleString.length < 11 && subTitleString.length > 0) {
            return;
        }
        
        if (subTitleString.length == 0) {
            _subTitle.text = _subTitleString;
            return;
        }
        NSString *weekString = [YDTool weekdayStringFromDateString:subTitleString];
        subTitleString = [subTitleString substringWithRange:NSMakeRange(5, 11)];
        subTitleString = [subTitleString stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
        NSArray *dateArray = [subTitleString componentsSeparatedByString:@" "];
        NSString *dateString = dateArray.firstObject;
        NSString *timeString = dateArray.lastObject;
        
        NSString *followYear = [_subTitleString substringToIndex:4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate new]];
        NSString *currentYear = [currentDate substringToIndex:4];
        
        if ([followYear isEqualToString:currentYear]) {
            _subTitleString = [NSString stringWithFormat:@"%@日 %@ %@", dateString, weekString, timeString];
        } else {
            _subTitleString = [NSString stringWithFormat:@"%@年%@日 %@ %@", followYear, dateString, weekString, timeString];
        }
        
    }
    
    if ([_titleString isEqualToString:@"申请时间"]) {
        //2016-12-08 18:46:32
        if (subTitleString.length < 11 && subTitleString.length > 0) {
            return;
        }
        
        if (subTitleString.length == 0) {
            _subTitle.text = _subTitleString;
            return;
        }
        NSString *weekString = [YDTool weekdayStringFromDateString:subTitleString];
        subTitleString = [subTitleString substringWithRange:NSMakeRange(5, 11)];
        subTitleString = [subTitleString stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
        NSArray *dateArray = [subTitleString componentsSeparatedByString:@" "];
        NSString *dateString = dateArray.firstObject;
        
        _subTitleString = [NSString stringWithFormat:@"%@日 %@", dateString, weekString];
    }
    
    
    _subTitle.text = _subTitleString;
    
}
-(void)setShowNextButton:(BOOL)showNextButton{
    _showNextButton = showNextButton;
    
    if (!showNextButton) {
        _nextButtonW.constant = 0;
    }else
        _nextButtonW.constant = 10;
}
-(void)setUd:(BOOL)ud{
    _ud = ud;
    
//    self.subTitle.userInteractionEnabled = ud;
}
-(void)setIsMust:(BOOL)isMust{
    _isMust = isMust;
    
    _blueMake.alpha = isMust?1:0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    if (self.ReturnBlack) {
        self.ReturnBlack();
    }
    
    return YES;
}

- (void)setIsShowDoneTool:(BOOL)isShowDoneTool
{
    _isShowDoneTool = isShowDoneTool;
    
    if (isShowDoneTool) {
        self.subTitle.inputAccessoryView = self.doneToolBar;
    } else {
        self.subTitle.inputAccessoryView = nil;
    }
}

- (UIToolbar *)doneToolBar
{
    if (_doneToolBar == nil) {
        _doneToolBar = [[UIToolbar alloc] init];
        _doneToolBar.frame = CGRectMake(0, 0, kScreenWidth, 25.0f);
        _doneToolBar.backgroundColor = [UIColor whiteColor];
        _doneToolBar.clipsToBounds = YES;
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        doneButton.frame = CGRectMake(kScreenWidth - 50.0f, 0, 50.0f, 25.0f);
        [doneButton addTarget:self action:@selector(cellToolbarDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_doneToolBar addSubview:doneButton];
    }
    return _doneToolBar;
}

- (void)cellToolbarDoneButtonClick
{
    
    if (self.ReturnBlack) {
        self.ReturnBlack();
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //当前文字
    NSMutableString *currentString = [NSMutableString stringWithString:textField.text];
    
    if (string.length > 0) {
        //输入文字
        [currentString insertString:string atIndex:range.location];
    } else {
        //删除文字
        [currentString deleteCharactersInRange:range];
    }
    
    NSString *backString = currentString;
    
    if (currentString.length > self.textLongest) {
        backString = [currentString substringToIndex:self.textLongest];
    }
    
    if (self.EndEditBlack) {
        self.EndEditBlack(self, backString);
    }
    
    if (textField == self.subTitle) {
        if (string.length == 0) return YES;
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
        if (currentString.length > self.textLongest) {
            return NO;
        }
    }
    
    return YES;
}

@end