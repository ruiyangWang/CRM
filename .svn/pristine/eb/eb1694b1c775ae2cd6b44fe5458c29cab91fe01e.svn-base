//
//  YDPriceListInfoVC.m
//  CRM
//
//  Created by YD_iOS on 16/8/4.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDPriceListInfoVC.h"
#import "YDUpdateCusInfoS2Cell.h"
#import "PriceDisplayView.h"
#import "YDQuoteModel.h"
#import "UIImageView+WebCache.h"

@interface YDPriceListInfoVC ()<UIWebViewDelegate> {
    NSArray *headerTitle;
    NSArray *titles;
    NSArray *subTitles;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet PriceDisplayView *priceView;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carTypeNameLabel;


@property (nonatomic, strong) UIWebView *webView; //报价详情

@end

@implementation YDPriceListInfoVC

#pragma mark ----- vc lift cycle 生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报价明细";
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib(@"YDUpdateCusInfoS2Cell")];
    _myTableView.tableFooterView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 161);
    
    
    [_priceView setItemWidth:30 itemSpace:7.5];
    
    headerTitle = @[@"",@"精品加装",@"保险",@"代办",@"贷款（厂家金融）"];
    titles = @[@[@"裸车价格",@"购置税"],@[@"精英版套餐"],@[@"保险套餐"],@[@"无"],@[@"首付", @"贷款", @"月供"]];
    
    //[self setupData];
    
    [self createView];
    
    [MBProgressHUD showStatus:@"正在加载..." toView:kWindow];
}

- (void)createView
{
    self.myTableView.hidden = YES;
    self.headerView.hidden = YES;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f)];
    _webView.delegate = self;
    _webView.backgroundColor = kViewControllerBackgroundColor;
    [self.view addSubview:_webView];
    
    NSString *urlString = [NSString stringWithFormat:@"%@id=%@&sid=suibian", kQuoteDetailAddress, _qutoeModel.modelId];
    //NSString *urlString = @"http://192.168.8.113:8080/admin-webapp/api/showPolicy/showApiPolicy?id=c0a80871585213c08158527ddfdc000e";
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:urlRequest];

}

#pragma mark 设置数据
- (void)setupData
{
    subTitles = @[
                  @[[NSString stringWithFormat:@"¥%@",_qutoeModel.carSoldPrice],[NSString stringWithFormat:@"¥%@",_qutoeModel.purchaseTax]],
                  @[[NSString stringWithFormat:@"¥%@",_qutoeModel.giftMoney]],
                  @[[NSString stringWithFormat:@"¥%@",_qutoeModel.insurMoney]],
                  @[[NSString stringWithFormat:@"¥%@",_qutoeModel.agencyMoney]],
                  @[[NSString stringWithFormat:@"¥%@",_qutoeModel.downPayment],@"贷款", @"月供"]
                  ];
    
    [_carImageView sd_setImageWithURL:[NSURL URLWithString:_qutoeModel.logoPath]];
    _carTypeNameLabel.text = _qutoeModel.modelsName;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_priceView setPrice:[self.qutoeModel.totalBidAmount integerValue] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [titles count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titles[section] count];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"444444"];
    label.text = [NSString stringWithFormat:@"    %@",headerTitle[section]];
    return label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS2Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleString = titles[indexPath.section][indexPath.row];
    cell.subTitleString = subTitles[indexPath.section][indexPath.row];
    cell.showNextButton = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"");
}

#pragma mark webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSString *headerStr = @"document.getElementsByTagName('header')[0].remove();";
//    $(".m-nav").remove();
//    $("#card").remove();
//    $(".chok-doc").css({
//        "margin-top":"0px",
//        "padding-top":"0px",
//        "padding-bottom":"0px"
//    });
    //[webView stringByEvaluatingJavaScriptFromString:headerStr];
    [MBProgressHUD hideHUDForView:kWindow animated:YES];
}

@end
