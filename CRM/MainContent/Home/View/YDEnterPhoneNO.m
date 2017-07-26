//
//  YDEnterPhoneNO.m
//  CRM
//
//  Created by YD_iOS on 16/7/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDEnterPhoneNO.h"
#import "YDUserInfoCell.h"
#import "NSDate+YDConvenience.h"
#import "YDTool.h"

@interface YDEnterPhoneNO()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation YDEnterPhoneNO

#pragma mark ----- vc lift cycle 生命周期

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.frame = CGRectMake (0, 0, kScreenWidth, kScreenHeight);
    [_myTableView registerNib:[UINib nibWithNibName:@"YDUserInfoCell" bundle:nil] forCellReuseIdentifier:@"YDUserInfoCell"];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
}
#pragma mark ----- get and setter 属性的set和get方法
-(void)setPModel:(YDPassengerModel *)pModel{
    _pModel = pModel;
    NSString *dateStr = [NSDate stringWithDate:pModel.createDate format:@"MM月dd日"];
    
    NSString *am_pm_Str;
    
    //把字符串转成时间再判断
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:pModel.createTime];
    
    if (date.hours > 12) {
        am_pm_Str = @"下午";
    }else
        am_pm_Str = @"上午";
    
    NSString *timeStr = [NSDate stringWithDate:pModel.createDate format:@"HH:mm"];
    _dateTimeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",dateStr, am_pm_Str, timeStr];
    
    _countLabel.text = [NSString stringWithFormat:@"%ld 人",(long)pModel.count];
}
-(void)setCModel:(YDCustListModel *)cModel{
    _cModel = cModel;
    _myTableView.hidden = NO;
    [_myTableView reloadData];
}

#pragma mark 点击其他地方收起键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self.view endEditing:NO];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark ----- event Response 事件响应(手势 通知)
- (IBAction)nextButton:(id)sender {
    
    [self endEditing:YES];
    
    if (self.ClickNextButton) {
        self.ClickNextButton(_phoneTF.text);
    }
}

#pragma mark ----- custom action for UI 界面处理有关
- (void)showView{
    
    //添加提示语
    UILabel *headerView = [[UILabel alloc] init];
    headerView.frame = CGRectMake(0, 0, 300.0f, 30.0f);
    headerView.textColor = [UIColor whiteColor];
    headerView.backgroundColor = kNavigationBackgroundColor;
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.text = @"该手机号码已有对应的客户";
    headerView.font = [UIFont systemFontOfSize:12.0f];
    _myTableView.tableHeaderView = headerView;
    _myTableView.backgroundColor = kNavigationBackgroundColor;
    
    _phoneTF.text = @"";
    
    _nextButton.hidden = YES;
    _myTableView.hidden = YES;
    
    [UIView animateWithDuration:.35 animations:^{
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    } completion:^(BOOL finished) {
        [_phoneTF becomeFirstResponder];
    }];
}
- (void)hiddenView{
    [_phoneTF endEditing:YES];
    [UIView animateWithDuration:.35 animations:^{
        self.center = CGPointMake(kScreenWidth/2, kScreenHeight*1.5);
    }];
}
#pragma mark ----- custom action for DATA 数据处理有关
#pragma mark ----- xxxxxx delegate 各种delegate回调
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserInfoCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YDUserInfoCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.custListModel = _cModel;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self endEditing:YES];
    
    if (_ClickUserInfo != nil) {
        _ClickUserInfo(_cModel);
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制文字个数输入
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 11) {
        return NO;
    }
    
    
    NSString *allString;
    
    if (string.length == 0) {
        allString = [textField.text substringToIndex:textField.text.length-1];
        
    }else{
        allString = [NSString stringWithFormat:@"%@%@",textField.text, string];
    }
    
    if([YDTool valiMobile:allString]){
        if (self.InputPhoneBlock) {
            
            self.InputPhoneBlock(allString);
        }
        //_nextButton.hidden = NO;
    } else {
        _nextButton.hidden = YES;
        _myTableView.hidden = YES;
    }
    
    return YES;
}

@end
