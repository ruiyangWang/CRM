//
//  ViewController.m
//  CRM
//
//  Created by YD_iOS on 16/7/14.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "ViewController.h"
#import "YDMainTabBarController.h"
#import "YDDataService.h"
#import "UITextField+XZAdjust.h"
#import "UITextField+XZRestrict.h"
#import "UIButton+XZ.h"
#import "YDTool.h"
#import "YDUserInfoFMDB.h"
#import "JPUSHService.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *code1;
@property (weak, nonatomic) IBOutlet UITextField *code2;
@property (weak, nonatomic) IBOutlet UITextField *code3;
@property (weak, nonatomic) IBOutlet UITextField *code4;
@property (weak, nonatomic) IBOutlet UITextField *code5;
@property (weak, nonatomic) IBOutlet UITextField *code6;
@property (weak, nonatomic) IBOutlet UITextField *testTF;
@property (weak, nonatomic) IBOutlet UIView *codeBGView;

@property (strong, nonatomic) NSArray *codes;

@end

@implementation ViewController

#pragma mark ----- vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithHexString:@"528ECD"];
    
    [_phoneTF setMaxTextLength:11];
    [_phoneTF setRestrictType:XZRestrictTypeOnlyNumber];
    [_testTF setAutoAdjust:YES];

    _codes = @[_code1, _code2, _code3, _code4, _code5, _code6];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCodeBGView:)];
    [_codeBGView addGestureRecognizer:tapGesture];
   
    [YDTool CheckAddressBookAuthorization:^(bool isAuthorized) {
        
    }];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
#pragma mark ----- event Response 事件响应(手势 通知)

#pragma mark 点击其他地方收起键盘
- (IBAction)getCode :(UIButton *)sender {
    
    //    [self checkVersion];
    
    //    YDMainTabBarController *tvc = [[YDMainTabBarController alloc]init];
    //    [self presentViewController:tvc animated:YES completion:^{
    //        self.view.window.rootViewController = tvc;
    //    }];
    
    if (![YDTool valiMobile:_phoneTF.text]) {
        [MBProgressHUD showTips:@"请输入正确的手机号码！" toView:self.view];
    }else{
        NSString *device = [JPUSHService registrationID];
        [self startRequest:@{@"phone":_phoneTF.text, @"idCode":@"", @"type":@"get", @"source" : @"crm", @"device" : device}];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self.view endEditing:NO];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)clickCodeBGView:(UITapGestureRecognizer *)t{
    [_testTF becomeFirstResponder];
}
- (IBAction)closeCodeView:(id)sender {
    [UIView animateWithDuration:.25 animations:^{
        _codeBGView.alpha = 0;
        _codeBGView.center = CGPointMake(_codeBGView.centerX, _codeBGView.centerY + _codeBGView.height + 10);
        _testTF.text = @"";
        _code1.text = @"";
        _code2.text = @"";
        _code3.text = @"";
        _code4.text = @"";
        _code5.text = @"";
        _code6.text = @"";
        [self.view endEditing:YES];
    }];
}



#pragma mark ----- custom action for UI 界面处理有关



#pragma mark ----- custom action for DATA 数据处理有关
//版本判断
- (void)checkVersion{
    
    [self showHudInView:self.view hint:@""];
    [YDDataService startRequest:@{} url:@"http://192.168.8.111/~yd_ios/index.xml" block:^(id result) {
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            [self showHint:@"成功"];
            
            NSString *newVersion = [result objectForKey:@"version"];
            newVersion = [newVersion stringByReplacingOccurrencesOfString:@"."withString:@"0"];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
            version = [version stringByReplacingOccurrencesOfString:@"."withString:@"0"];
            if ([newVersion integerValue] > [version integerValue]) {
                
                [self showHint:@"有更新"];;
                
//                NSString *pURL = @"https://www.dropbox.com/s/0a6hiyps6xs2dl2/crmapp.plist";
                NSString *pURL = @"https://local.server.com/crmapp.plist";
                NSString *dURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",pURL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dURL]];
                exit(0);
                
            }else
                [self showHint:@"没有更新"];
            
        }else{
            [self showHint:@"失败"];
        }
        
    } failBlock:^(id error) {
        [self hideHud];
        [self showHint:@"失败"];
    }];
}

//网络请求
- (void)startRequest:(NSDictionary *)dic{
    
    //[self showHudInView:kWindow hint:@""];
    [YDDataService startRequest:dic url:kGetCodeAndLogin block:^(id result) {
        
        [self hideHud];
        
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            
            NSDictionary *sidDic = result[@"var"];
            
            if ([sidDic isKindOfClass:[NSDictionary class]]) {
                NSString *sid = sidDic[@"sid"];
                setNSUser(sid, @"youdao.CRM_SID");
                
                //存储需要的个人信息3
                NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
                NSDictionary *memberInfo = sidDic[@"member"];
                setNSUser(memberInfo[@"id"], kUserInfoKey);
                NSArray *brandInfo = sidDic[@"brands"];
                //个人信息
                [userInfoDic setValue:memberInfo[@"memberName"] forKey:@"memberName"]; //姓名
                [userInfoDic setValue:memberInfo[@"mobilePhone"] forKey:@"mobilePhone"]; //手机号
                [userInfoDic setValue:memberInfo[@"headPic"] forKey:@"headPic"]; //头像
                [userInfoDic setValue:memberInfo[@"jobTitle"] forKey:@"jobTitle"]; //职位
                [userInfoDic setValue:memberInfo[@"orgName"] forKey:@"orgName"]; //4s店全称
                [userInfoDic setValue:memberInfo[@"id"] forKey:@"modelId"]; //id
                
                //品牌信息
                NSMutableString *brandName = [NSMutableString string];
                for (NSDictionary *dic in brandInfo) {
                    NSString *brandsNameStr = [dic valueForKey:@"brandsName"];
                    if ([brandsNameStr isKindOfClass:[NSString class]]) {
                        [brandName appendFormat:@"%@", brandsNameStr.length > 0 ? brandsNameStr : @""];
                    }
                }
                [userInfoDic setValue:brandName forKey:@"brandsName"];
                //存储用户信息
                NSString *h = NSHomeDirectory();
                NSLog(@"%@", h);
                [[YDUserInfoFMDB sharedYDUserInfoFMDB] insertOrUpdateUserInfo:userInfoDic];
                
                
                YDMainTabBarController *tvc = [[YDMainTabBarController alloc]init];
                [self presentViewController:tvc animated:YES completion:^{
                    self.view.window.rootViewController = tvc;
                }];
            }else{
                [self.view endEditing:YES];
                //[self showHint:@"验证码发送成功"];
                
                [_getCodeButton startCountdown];
                
                [self.view sendSubviewToBack:_codeBGView];
                [UIView animateWithDuration:.45 animations:^{
                    _codeBGView.alpha = 1;
                    _codeBGView.center = CGPointMake(_codeBGView.centerX, _codeBGView.centerY-_codeBGView.height-10);
                }];
            }
            
        }
        else if([result[@"code"] isEqualToString:@"VERIFYCODE_V_FAL_0X001"]){
            if ([result[@"msg"] isEqualToString:@"verifycode is error"]) {
                [self showHint:@"验证码错误"];
            }
        } else if([result[@"code"] isEqualToString:@"MEMBER_Q_FAL_0X001"]){
            [self showHint:@"未找到该成员"];
        } else if([result[@"code"] isEqualToString:@"MEMBER_Q_FAL_0X002"]){
            [self showHint:@"手机号码为空"];
        } else if([result[@"code"] isEqualToString:@"MEMBER_Q_FAL_0X004"]){
            [self showHint:@"org status is normal"];
        } else if([result[@"code"] isEqualToString:@"MEMBER_Q_FAL_0X005"]){
            [self showHint:@"该成员不是销售顾问"];
        } else if([result[@"code"] isEqualToString:@"MEMBER_Q_FAL_0X006"]){
            [self showHint:@"该成员所在组织没有整车业务"];
        } else if([result[@"code"] isEqualToString:@"MEMBER_Q_FAL_0X007"]){
            [self showHint:@"数据异常,请联系管理员"];
        } else{
            [self showHint:[NSString stringWithFormat:@"登录失败,错误码:%@", result[@"code"]]];
        }
        
    } failBlock:^(id error) {
        [self hideHud];
        [self showHint:[NSString stringWithFormat:@"登录失败,错误码:%@", error]];
    }];
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UITextField *cTF = _codes[range.location];

    if (string.length == 1) {
        cTF.text = string;
        if (range.location == 5) {
            //调用登录
            NSString *c = [NSString stringWithFormat:@"%@%@",_testTF.text,string];
            NSString *device = [JPUSHService registrationID];
            [self startRequest:@{@"phone":_phoneTF.text, @"idCode":c , @"type":@"valid", @"source" : @"crm", @"device" : device}];
        }
    }else if(string.length == 0){
        cTF.text = @"";
    }

    return YES;
}

@end
