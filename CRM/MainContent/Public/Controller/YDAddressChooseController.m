//
//  YDAddressChooseController.m
//  CRM
//
//  Created by ios on 16/8/27.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDAddressChooseController.h"
#import "OSAddressPickerView.h"
#import "YDUpdateCusInfoS2Cell.h"
#import "MBProgressHUD.h"

@interface YDAddressChooseController () <UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong)  OSAddressPickerView *pickerview;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) UITextField *addressTextField;
@end

@implementation YDAddressChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];

}


- (void)createView
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"居住地址选择";
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 40, 20);
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kViewControllerBackgroundColor;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib(@"YDUpdateCusInfoS2Cell")];
    
}


#pragma mark - =====================tableView delegete==========================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS2Cell"];
        
        cell.titleString = @"请选择所在地区";
        cell.subTitleString = @"";
        cell.showNextButton = YES;
        
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
        _addressTextField = [[UITextField alloc] init];
        _addressTextField.frame = CGRectMake(25.0f, 0, kScreenWidth, 44.0f);
        _addressTextField.placeholder = @"请填写详细地址";
        _addressTextField.font = [UIFont systemFontOfSize:14.0f];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 43.5f, kScreenWidth, 0.5f);
        lineView.backgroundColor = kTableViewLineColor;
        
        [cell addSubview:_addressTextField];
        [cell addSubview:lineView];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (indexPath.row == 0) {
        
        YDUpdateCusInfoS2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        _pickerview = [OSAddressPickerView shareInstance];
        [kWindow addSubview:_pickerview];
        [self.pickerview showBottomView];
        WEAKSELF
        self.pickerview.block = ^(NSString *province,NSString *city,NSString *district)
        {
            weakSelf.address = [NSString stringWithFormat:@"%@ %@ %@", province, city, district];
            cell.subTitleString = weakSelf.address;
        };
    }
}

- (void)doneButtonClick
{
//    if (_addressTextField.text.length <= 0) {
//        [MBProgressHUD showTips:@"请填写详细地址" toView:kWindow];
//        return;
//    }
    
    NSString *address = [NSString stringWithFormat:@"%@ %@", _address, _addressTextField.text];
    
    if (self.ChangeBlock) {
        self.ChangeBlock(address);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
