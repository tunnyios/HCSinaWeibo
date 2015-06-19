//
//  AppDelegate.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "AppDelegate.h"
#import "HCMainViewController.h"
#import "HCNewFeatureViewController.h"
#import "HCOAuthViewController.h"
#import "HCAccount.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //设置根控制器
    /**
        判断如果沙盒中有account.plist文件，则说明已经授权过
     */
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
    HCAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (account) {
        /**
         *  1. 取沙盒中的版本号
         *  2. 取info.plist中的版本号
         *  3. 比较，如果一致，说明已经显示过新特性了，跳转至主控制器
         *  4. 如果不一致，则将新版本号存入沙盒，跳转至新特性控制器
         */
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *savedVersion = [defaults objectForKey:@"CFBundleVersion"];
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        if ([savedVersion isEqualToString:currentVersion]) {
            //相等
            HCMainViewController *tabBarController = [[HCMainViewController alloc] init];
            self.window.rootViewController = tabBarController;
        } else {
            //不等...新特性
            self.window.rootViewController = [[HCNewFeatureViewController alloc] init];
            //存入沙盒
            [defaults setObject:currentVersion forKey:@"CFBundleVersion"];
            [defaults synchronize];
        }
        
    } else {
        //如果没有， 则加载授权
        self.window.rootViewController = [[HCOAuthViewController alloc] init];
    }
    

    //设置为主窗口并显示
    [self.window makeKeyAndVisible];
    
    return YES;
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
