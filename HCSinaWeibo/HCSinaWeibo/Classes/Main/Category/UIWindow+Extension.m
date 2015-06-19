//
//  UIWindow+Extension.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "HCMainViewController.h"
#import "HCNewFeatureViewController.h"

@implementation UIWindow (Extension)

/**
 *  切换控制器
 */
+ (void)switchRootViewController
{
    /**
     *  1. 取沙盒中的版本号
     *  2. 取info.plist中的版本号
     *  3. 比较，如果一致，说明已经显示过新特性了，跳转至主控制器
     *  4. 如果不一致，则将新版本号存入沙盒，跳转至新特性控制器
     */
    //判断是否需要展示新特性，否则展示主视图
    NSString *key = @"CFBundleVersion";
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedVersion = [defaults objectForKey:key];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([savedVersion isEqualToString:currentVersion]) {
        //不需要展示新特性
        window.rootViewController = [[HCMainViewController alloc] init];
    } else {
        //展示新特性
        window.rootViewController = [[HCNewFeatureViewController alloc] init];
        //将新版本号存入沙盒
        [defaults setObject:currentVersion forKey:key];
    }

}
@end
