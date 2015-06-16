//
//  HCMainViewController.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCMainViewController.h"
#import "UIColor+Tools.h"
#import "HCHomeTableViewController.h"
#import "HCMessageTableViewController.h"
#import "HCProfileTableViewController.h"
#import "HCDiscoverTableViewController.h"

@interface HCMainViewController ()

@end

@implementation HCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置子控制器
    HCHomeTableViewController *homeVc = [[HCHomeTableViewController alloc] init];
    [self setChildViewControllerProperty:homeVc title:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    
    HCMessageTableViewController *messageVc = [[HCMessageTableViewController alloc] init];
    [self setChildViewControllerProperty:messageVc title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]];
    HCDiscoverTableViewController *discoverVc = [[HCDiscoverTableViewController alloc] init];
    [self setChildViewControllerProperty:discoverVc title:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    HCProfileTableViewController *profileVc = [[HCProfileTableViewController alloc] init];
    [self setChildViewControllerProperty:profileVc title:@"我" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    
}

/**
 *  设置一个子控制器的tabBarItem属性
 *
 *  @param vc            控制器名称
 *  @param title         tabBarItem的标题
 *  @param image         tabBarItem的图片
 *  @param selectedImage 选中的tabBarItem图片
 */
- (void)setChildViewControllerProperty:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    //设置子控制器
    vc.view.backgroundColor = [UIColor colorWithRandom];
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
    
    [self addChildViewController:vc];
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
