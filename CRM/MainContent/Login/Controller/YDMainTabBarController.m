//
//  YDMainTabBarController.m
//  CRM
//
//  Created by YD_iOS on 16/7/14.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDMainTabBarController.h"
#import "ViewController.h"
#import "YDHomeViewController.h"
#import "YDCustomerListController.h"
#import "YDNavigationController.h"
#import "YDMyInfoController.h"

@interface YDMainTabBarController ()

@property (nonatomic, strong) UIView *sliderView; //滑块

@end

@implementation YDMainTabBarController

#pragma mark ----- vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTabViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----- get and setter 属性的set和get方法
#pragma mark ----- event Response 事件响应(手势 通知)
#pragma mark ----- custom action for UI 界面处理有关
- (void)createTabViewController {
    
    //首页
    YDHomeViewController *homeVC = [[YDHomeViewController alloc] initWithNibName:@"YDHomeViewController" bundle:nil];
    homeVC.tabBarItem.image = [UIImage imageNamed:@"tabBarItem_home_n"];
    homeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_select_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.tag = 0;
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.navigationBar.tintColor = [UIColor whiteColor];
    [homeNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

    for (UIView *v in homeNav.navigationBar.subviews) {
        if ([[NSString stringWithFormat:@"%@",v.class] isEqualToString:@"_UINavigationBarBackground"]) {
            
            UIView *navBGView = nil;
            if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                navBGView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
            } else {
                navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, 64)];
            }
            
            navBGView.backgroundColor = kNavigationBackgroundColor;
            navBGView.userInteractionEnabled = NO;
            navBGView.tag = 30000;
            [v  addSubview:navBGView];
        }
    }
    
    //客户
    YDCustomerListController *customerListController = [[YDCustomerListController alloc] init];
    customerListController.tabBarItem.image = [UIImage imageNamed:@"tabBarItem_Con_n"];
    customerListController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    customerListController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_select_center"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    customerListController.tabBarItem.tag = 1;
    YDNavigationController *custNavigationController = [[YDNavigationController alloc] initWithRootViewController:customerListController];

    //我的
    YDMyInfoController *myInfoController = [[YDMyInfoController alloc] init];
    myInfoController.tabBarItem.image = [UIImage imageNamed:@"tabBarItem_set_n"];
    myInfoController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    myInfoController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_select_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myInfoController.tabBarItem.tag = 2;
    YDNavigationController *myNavigationController = [[YDNavigationController alloc] initWithRootViewController:myInfoController];

    self.viewControllers = @[homeNav,
                             custNavigationController,
                             myNavigationController];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar_BG"]];
    
    [self.tabBar setShadowImage:[UIImage imageWithColor:kViewControllerBackgroundColor size:CGSizeMake(kScreenWidth, 0.5)]];
    
    CGFloat itemWidth = (kScreenWidth - 12.0f) / 3;
    CGFloat sliderX = (itemWidth / 2) - 25.0f + 2.0f;
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(sliderX, 45.0f, 50.0f, 4.0f)];
    _sliderView.backgroundColor = kNavigationBackgroundColor;
    [self.tabBar addSubview:_sliderView];
    
}
#pragma mark ----- custom action for DATA 数据处理有关
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    CGFloat itemWidth = (kScreenWidth - 12.0f) / 3;
    CGFloat sliderX = ((itemWidth / 2) - 25.0f + 2.0f) + (itemWidth + 4.0f) *item.tag;
    [UIView animateWithDuration:0.2f animations:^{
        _sliderView.x = sliderX;
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    CGFloat itemWidth = (kScreenWidth - 12.0f) / 3;
    CGFloat sliderX = ((itemWidth / 2) - 25.0f + 2.0f) + (itemWidth + 4.0f) *1;
    [UIView animateWithDuration:0.2f animations:^{
        _sliderView.x = sliderX;
    }];
    [super setSelectedIndex:selectedIndex];
}

#pragma mark ----- xxxxxx delegate 各种delegate回调

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
