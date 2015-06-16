//
//  AppDelegate.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Tools.h"
#import "HCHomeTableViewController.h"
#import "HCMessageTableViewController.h"
#import "HCProfileTableViewController.h"
#import "HCDiscoverTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置根控制器
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    
    //设置子控制器
    HCHomeTableViewController *homeVc = [[HCHomeTableViewController alloc] init];
    [self setChildViewControllerProperty:homeVc title:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    HCMessageTableViewController *messageVc = [[HCMessageTableViewController alloc] init];
    [self setChildViewControllerProperty:messageVc title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]];
    HCDiscoverTableViewController *discoverVc = [[HCDiscoverTableViewController alloc] init];
    [self setChildViewControllerProperty:discoverVc title:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    HCProfileTableViewController *profileVc = [[HCProfileTableViewController alloc] init];
    [self setChildViewControllerProperty:profileVc title:@"我" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];

    [tabBarController addChildViewController:homeVc];
    [tabBarController addChildViewController:messageVc];
    [tabBarController addChildViewController:discoverVc];
    [tabBarController addChildViewController:profileVc];

    //设置为主窗口并显示
    [self.window makeKeyAndVisible];
    
    return YES;
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
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
