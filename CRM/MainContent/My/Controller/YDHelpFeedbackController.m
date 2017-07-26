//
//  YDHelpFeedbackController.m
//  CRM
//
//  Created by ios on 16/11/8.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDHelpFeedbackController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"
#import "QMUITextView.h"

@interface YDHelpFeedbackController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,QMUITextViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) QMUITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIView *addImageBGView;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView4;


@property (nonatomic, strong) UIButton *addImageButton;

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@property (nonatomic, copy) NSString *imgpath; //上传图片路径
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) NSInteger addButtonIndex; //添加图片按钮的下标
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;

@end

@implementation YDHelpFeedbackController

- (instancetype)init
{
    if (self = [super init]) {
        _isFirst = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.addButtonIndex = 1;
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.textCountLabel];
    
    if (_isFirst) {
        self.addImageButton.frame = self.addImageView1.frame;
        [self.addImageBGView addSubview:self.addImageButton];
        _isFirst = NO;
    }
}


- (IBAction)buttonClick:(id)sender {
    
    [self submitFeedbackRequest];
    
}

- (void)setupView
{
    self.title = @"帮助与反馈";
    
    self.contentTextView = [[QMUITextView alloc] init];
    self.contentTextView.frame = CGRectMake(0, 35.0f, kScreenWidth, 170.0f);
    self.contentTextView.delegate = self;
    self.contentTextView.maximumTextLength = 200;
    self.contentTextView.placeholder = @"请输入要描述的问题和意见";
    self.contentTextView.placeholderColor = kThreeTextColor;
    self.contentTextView.placeholderMargins = UIEdgeInsetsMake(5.0f, 25.0f, 0, 0);
    self.contentTextView.returnKeyType = UIReturnKeyDone;
    self.contentTextView.shouldCountingNonASCIICharacterAsTwo = YES;
    [self.view addSubview:self.contentTextView];
    
    self.phoneTextField.delegate = self;
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageButton setBackgroundImage:[UIImage imageNamed:@"add_image_backgroundImage"] forState:UIControlStateNormal];
    [self.addImageButton addTarget:self action:@selector(createView) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat space = (kScreenWidth - 50.0f - 280.0f) / 3;
    self.addImageView2.frame = CGRectMake(self.addImageView1.maxX + space, self.addImageView1.y, 70.0f, 70.0f);
    self.addImageView3.frame = CGRectMake(self.addImageView2.maxX + space, self.addImageView1.y, 70.0f, 70.0f);
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.textCountLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length - range.length + text.length];
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText
{

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}


//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        
        _addButtonIndex++;
        
        //如果是图片
        switch (_addButtonIndex) {
            case 2:
                self.addImageView1.image = info[UIImagePickerControllerOriginalImage];
                break;
            case 3:
                self.addImageView2.image = info[UIImagePickerControllerOriginalImage];
                break;
            case 4:
                self.addImageView3.image = info[UIImagePickerControllerOriginalImage];
                break;
            case 5:
                self.addImageView4.image = info[UIImagePickerControllerOriginalImage];
                break;
            default:
                break;
        }
        
        
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(self.addImageView1.image, 0.1);
        
        //获取正在编辑的图片
        
        __block NSURL *imageUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        __block NSString *imageName;
        //获取图片的名字信息
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            imageName = [representation filename];//self.imageName是属性
            //上传图片
            [self uploadImageWithData:fileData imageName:imageName];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageUrl
                       resultBlock:resultblock
                      failureBlock:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            switch (_addButtonIndex) {
                case 2:
                {
                    self.addImageButton.frame = self.addImageView2.frame;
                    self.imageCountLabel.text = [NSString stringWithFormat:@"1/4"];
                }
                    break;
                case 3:
                {
                    self.addImageButton.frame = self.addImageView3.frame;
                    self.imageCountLabel.text = [NSString stringWithFormat:@"2/4"];
                }
                    break;
                case 4:
                {
                    self.addImageButton.frame = self.addImageView4.frame;
                    self.imageCountLabel.text = [NSString stringWithFormat:@"3/4"];
                }
                    break;
                case 5:
                {
                    self.addImageButton.frame = CGRectZero;
                    self.imageCountLabel.text = [NSString stringWithFormat:@"4/4"];
                }
                    break;
                default:
                    break;
            }
            
        }];
    }

}

- (void)uploadImageWithData:(NSData *)fileData imageName:(NSString *)imageName
{
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.上传文件
    NSDictionary *dict = @{};
    
    NSString *urlString = [NSString stringWithFormat:@"%@sid=%@", kAddImageAddress, getNSUser(kCRM_SIDKey)];;
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //这个就是参数-
        [formData appendPartWithFileData:fileData name:@"file" fileName:imageName mimeType:@"image/png"];
 
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"S_OK"]) {
            NSString *responseImageName = [responseObject valueForKey:@"var"];
            switch (_addButtonIndex) {
                case 2:
                    _imgpath = responseImageName;
                    break;
                case 3:
                    _imgpath = [NSString stringWithFormat:@"%@, %@", _imgpath, responseImageName];
                    break;
                case 4:
                    _imgpath = [NSString stringWithFormat:@"%@, %@", _imgpath, responseImageName];
                    break;
                case 5:
                    _imgpath = [NSString stringWithFormat:@"%@, %@", _imgpath, responseImageName];
                    break;
                default:
                    break;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
    }];
    
}


#pragma mark 提交
- (void)submitFeedbackRequest
{
    if (self.contentTextView.text.length <= 0) {
        [MBProgressHUD showTips:@"问题和内容不能为空" toView:kWindow];
        return;
    }
    
    NSDictionary *dic = @{@"content" : self.contentTextView.text,
                          @"phone" : self.phoneTextField.text,
                          @"imgpath" : self.imgpath,
                          @"source" : @"CRM"
                          };
    NSString *url = [NSString stringWithFormat:@"%@sid=%@", kFeedbackAddress, getNSUser(kCRM_SIDKey)];
    
    [YDDataService startRequest:dic url:url block:^(id result) {
        
        [MBProgressHUD showTips:@"反馈成功" toView:kWindow];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(id error) {
        
    }];
}


#pragma mark 打开相册
- (void)createView
{
    //是否能访问系统相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    _imagePickerVC = [[UIImagePickerController alloc] init];
    _imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerVC.delegate = self;
    [self presentViewController:_imagePickerVC animated:YES completion:^{
        
    }];
    
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

#pragma mark 获得所有相簿的原图
- (void)getOriginalImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}


#pragma mark 获得所有相簿中的缩略图
- (void)getThumbnailImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}


/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
        }];
    }
}


@end
