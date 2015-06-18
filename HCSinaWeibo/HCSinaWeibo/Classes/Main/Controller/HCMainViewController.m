//
//  HCMainViewController.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCMainViewController.h"
#import "HCHomeTableViewController.h"
#import "HCMessageTableViewController.h"
#import "HCProfileTableViewController.h"
#import "HCDiscoverTableViewController.h"
#import "HCTabBar5ContentView.h"

@interface HCMainViewController ()<HCTabBar5ContenViewDelegate>

@end

@implementation HCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1. 设置子控制器
    HCHomeTableViewController *homeVc = [[HCHomeTableViewController alloc] init];
    [self creatChildViewController:homeVc title:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    
    HCMessageTableViewController *messageVc = [[HCMessageTableViewController alloc] init];
    [self creatChildViewController:messageVc title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]];
    
    HCDiscoverTableViewController *discoverVc = [[HCDiscoverTableViewController alloc] init];
    [self creatChildViewController:discoverVc title:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    
    HCProfileTableViewController *profileVc = [[HCProfileTableViewController alloc] init];
    [self creatChildViewController:profileVc title:@"我" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    
    //2. 用自定义的tabBar更换系统自带的tabBar
    HCTabBar5ContentView *tabBars = [[HCTabBar5ContentView alloc] init];
    //设置代理
    tabBars.tabBardelegate = self;
//    self.tabBar = tabBar; 系统自带的tabBar是只读的，因此没有提供setter方法，因此只能用KVC赋值
    [self setValue:tabBars forKey:@"tabBar"];
}

/**
 *  添加一个子控制器的tabBarItem
 *
 *  @param vc            控制器名称
 *  @param title         tabBarItem的标题
 *  @param image         tabBarItem的图片
 *  @param selectedImage 选中的tabBarItem图片
 */
- (void)creatChildViewController:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    //设置子控制器
//    vc.view.backgroundColor = [UIColor colorWithRandom];
    //设置选中字体颜色
    NSDictionary *titleFont = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                NSForegroundColorAttributeName : [UIColor orangeColor]
                                };
    [vc.tabBarItem setTitleTextAttributes:titleFont forState:UIControlStateSelected];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    //设置系统不自动渲染图片
    UIImage *newImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = newImage;
    
    //包装一个导航控制器
    HCNavigationController *navc = [[HCNavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.title = title;
    
    [self addChildViewController:navc];
}

#pragma mark - 自定义tabBar的监听点击代理事件
- (void)tabBar5ContenViewWithTabBar:(HCTabBar5ContentView *)tabBar
{
    HCLog(@"点击了plusButton。。。");
}

@end
