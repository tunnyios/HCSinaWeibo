//
//  AppDelegate.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "AppDelegate.h"
#import "HCOAuthViewController.h"
#import "HCAccount.h"
#import "HCAccountTools.h"
#import "SDWebImageManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1. 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //2. 设置为主窗口并显示
    [self.window makeKeyAndVisible];
    
    //3。 设置根控制器
    //获取账户
    HCAccount *account = [HCAccountTools account];
    if (account) {
        //切换控制器
        [UIWindow switchRootViewController];
    } else {
        //如果没有， 则加载授权
        self.window.rootViewController = [[HCOAuthViewController alloc] init];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark - 进入后台后如还需要运行，则需在在该方法中申请
- (void)applicationDidEnterBackground:(UIApplication *)application {

    //向操作系统申请后台运行资格，能维持多久， 是不确定的
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        //当申请的后台运行时间已过期，则会执行这个block
        //关闭后台运行
        [application endBackgroundTask:task];
    }];
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

#pragma mark - 接收到内存警告时，取消下载图片，清空图片缓存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

@end
