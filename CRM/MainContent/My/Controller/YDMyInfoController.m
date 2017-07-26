//
//  YDMyInfoController.m
//  CRM
//
//  Created by ios on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDMyInfoController.h"
#import "YDUserInfoController.h"
#import "YDUserSetController.h"
#import "YDImportCustomerController.h"
#import "YDUpdateCusInfoS2Cell.h"
#import "YDCommonSettingsController.h"
#import "YDUserInfoFMDB.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>

//IM
#import "NTESSessionListViewController.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#define kPictureWidth  127.0f
#define kHeaderHeight  260.0f

@interface YDMyInfoController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *cellArray;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *positionLabel; //职位

@property (nonatomic, strong) NSMutableDictionary *userInfoDic; //销售顾问信息

@end

@implementation YDMyInfoController


- (instancetype)init
{
    if (self = [super init]) {
        _userInfoDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self createView];
    
    [self doLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.tabBarController.selectedIndex != 2) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }

    [super viewWillAppear:animated];
    
    [self getMemberInfoFromNetwork];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - ====================网络==========================
- (void)getMemberInfoFromNetwork
{
    NSString *url = [NSString stringWithFormat:@"%@sid=%@", kGetMemberInfoAddress, getNSUser(kCRM_SIDKey)];
    
    [YDDataService startRequest:@{} url:url block:^(id result) {
        
        if ([[result valueForKey:@"code"] isEqualToString:@"S_OK"]) {
            //个人信息
            NSDictionary *memberInfo = result[@"var"];
            NSArray *brandInfo = memberInfo[@"list"];
            //个人信息
            [_userInfoDic setValue:memberInfo[@"memberName"] forKey:@"memberName"]; //姓名
            [_userInfoDic setValue:memberInfo[@"mobilePhone"] forKey:@"mobilePhone"]; //手机号
            [_userInfoDic setValue:memberInfo[@"headPic"] forKey:@"headPic"]; //头像
            [_userInfoDic setValue:memberInfo[@"jobTitle"] forKey:@"jobTitle"]; //职位
            [_userInfoDic setValue:memberInfo[@"orgName"] forKey:@"orgName"]; //4s店全称
            [_userInfoDic setValue:memberInfo[@"id"] forKey:@"modelId"]; //id
            
            //品牌信息
            NSMutableString *brandName = [NSMutableString string];
            for (NSDictionary *dic in brandInfo) {
                NSString *brandsNameStr = [dic valueForKey:@"brandsName"];
                if ([brandsNameStr isKindOfClass:[NSString class]]) {
                    [brandName appendFormat:@"%@", brandsNameStr.length > 0 ? brandsNameStr : @""];
                }
            }
            [_userInfoDic setValue:brandName forKey:@"brandsName"];
            
            NSString *urlStr = _userInfoDic[@"headPic"];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"iconImage_default"]];
            
            _nameLabel.text = _userInfoDic[@"memberName"];
            
            _positionLabel.text = _userInfoDic[@"jobTitle"];
        }
        
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - ====================view==========================
- (void)createView
{
    NSDictionary *dic = getNSUser(@"youdao.CRM_mobilePhone");
    NSLog(@"%@---", dic);
    _cellArray = @[@" 个人信息", @" 业务设置", @" 导入客户", @" 通用设置"];
    _cellArray = @[@" 个人信息", @" 业务设置", @" 通用设置", @"云信测试"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kViewControllerBackgroundColor;
    //[_tableView registerNib(@"YDUpdateCusInfoS2Cell")];
    [self.view addSubview:_tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    headerView.backgroundColor = kNavigationBackgroundColor;
    
    //NSDictionary *userInfoDic = [[YDUserInfoFMDB sharedYDUserInfoFMDB] queryUserInfoWithUserID:getNSUser(kUserInfoKey)];
    
    //头像
    _imageView = [[UIImageView alloc] init];
    _imageView.bounds = CGRectMake(0, 0, kPictureWidth, kPictureWidth);
    _imageView.center = CGPointMake(kScreenWidth / 2, kPictureWidth / 2 + 50.0f);
    //_imageView.layer.cornerRadius = 63.0f;
    _imageView.layer.cornerRadius = 3.0f;
    _imageView.layer.borderWidth = 1.5f;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    //NSString *urlStr = userInfoDic[@"headPic"];
    //[_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"iconImage_default"]];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alterHeadPortrait:)];
    [_imageView addGestureRecognizer:tap];
    
    
    //姓名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(0, kHeaderHeight - 40.0f - 35.0f, kScreenWidth, 35.0f);
    //_nameLabel.text = userInfoDic[@"memberName"];
    _nameLabel.font = [UIFont systemFontOfSize:24.0f];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_nameLabel];
    
    //职位
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.frame = CGRectMake(0, _nameLabel.maxY + 7.0f, kScreenWidth, 20.0f);
    //_positionLabel.text = userInfoDic[@"jobTitle"];
    _positionLabel.font = [UIFont systemFontOfSize:14.0f];
    _positionLabel.textColor = [UIColor whiteColor];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_positionLabel];
    
    //表头
    [headerView addSubview:_imageView];
    _tableView.tableHeaderView = headerView;
    
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, -200.0f, kScreenWidth, 200.0f)];
    redView.backgroundColor = kNavigationBackgroundColor;
    [headerView addSubview:redView];
    
}

#pragma mark - tableview  数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"myInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _cellArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5f, kScreenWidth, 0.5f)];
    lineView.backgroundColor = kTableViewLineColor;
    [cell addSubview:lineView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self userInfomation];
            break;
        case 1:
            [self userSet];
            break;
//        case 2:
//            [self importCustomer];
//            break;
        case 2:
            [self commonSettings];
            break;
        case 3:
            [self NIMTest];
            break;
        default:
            break;
    }
}


#pragma mark scrollView 的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    /**
     *  这里的偏移量是纵向从contentInset算起 则一开始偏移就是0 向下为负 上为正 下拉
     */
    
    // 获取到tableView偏移量
    CGFloat Offset_y = scrollView.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if (-28.0f < Offset_y && Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = kPictureWidth - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / kPictureWidth;
        CGFloat imageWidth = kPictureWidth * scale;
        ///_imageView.layer.cornerRadius = imageWidth / 2;
        // 拉伸后图片位置
        _imageView.frame = CGRectMake((kScreenWidth - imageWidth) / 2, (260.0f - imageWidth - 44.0f) / 2, imageWidth, totalOffset);
    }
    
}

#pragma mark - =====================功能类===========================
#pragma mark 个人信息  界面
- (void)userInfomation {
    
    YDUserInfoController *userInfoController = [[YDUserInfoController alloc] init];
    userInfoController.userInfoDic = self.userInfoDic;
    [userInfoController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:userInfoController animated:YES];
}

#pragma mark 设置
- (void)userSet {
    YDUserSetController *userSetController = [[YDUserSetController alloc] init];
    [userSetController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:userSetController animated:YES];
}

#pragma mark 导入客户
- (void)importCustomer {
    YDImportCustomerController *importCustomerController = [[YDImportCustomerController alloc] init];
    [importCustomerController setHidesBottomBarWhenPushed:YES];
    importCustomerController.importType = ImportTypeDefult;
    [self.navigationController pushViewController:importCustomerController animated:YES];
}

#pragma mark 通用设置
- (void)commonSettings
{
    YDCommonSettingsController *commonSettingsVC = [[YDCommonSettingsController alloc] init];
    [commonSettingsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:commonSettingsVC animated:YES];
}

#pragma mark 云信测试
- (void)NIMTest
{
    NTESSessionListViewController *IMVC = [[NTESSessionListViewController alloc] init];
    IMVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:IMVC animated:YES];
}

#pragma mark - =====================头像===========================
#pragma mark 点击头像
//  方法：alterHeadPortrait
-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _imageView.image = newPhoto;
    
    //压缩图片
    NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    
    //获取正在编辑的图片
    
    __block NSURL *imageUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    __block NSString *imageName;
    //获取图片的名字信息
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        imageName = [representation filename];//self.imageName是属性
        
        if (imageName == nil) imageName = [NSString stringWithFormat:@"%d.PNG", arc4random() % 10000];
        //上传图片
        [self uploadImageWithData:fileData imageName:imageName];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageUrl
                   resultBlock:resultblock
                  failureBlock:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImageWithData:(NSData *)fileData imageName:(NSString *)imageName
{
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.上传文件
    NSDictionary *dict = @{};
    
    NSString *urlString = [NSString stringWithFormat:@"%@sid=%@", kUserIconAddress, getNSUser(kCRM_SIDKey)];;
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //这个就是参数
        [formData appendPartWithFileData:fileData name:@"file" fileName:imageName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"S_OK"]) {
            [MBProgressHUD showTips:@"上传成功" toView:self.view];
            NSString *urlStr = _userInfoDic[@"headPic"];
            [[SDImageCache sharedImageCache] removeImageForKey:urlStr];
            [self getMemberInfoFromNetwork];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
    }];
    
}

- (void)doLogin
{
   
    
    NSString *username = [@"ydtest123" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = @"123456";
    
    NSString *loginAccount = username;
    NSString *loginToken   = [password tokenByPassword];
    
    //NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
    //用户APP的帐号体系和 NIM SDK 并没有直接关系
    //DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
    //开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
    
    
    [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                       token:loginToken
                                  completion:^(NSError *error) {
                    
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = loginAccount;
                                          sdkData.token     = loginToken;
                                          [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                         
                                      }
                                      
                                  }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
