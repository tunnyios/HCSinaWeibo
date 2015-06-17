//
//  UIBarButtonItem+Extension.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/17.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  创建导航条左右的item
 *
 *  @param target     点击item后调用哪个对象
 *  @param action     点击item后调用调用的方法
 *  @param image      item普通状态的图标
 *  @param heighImage item高亮状态的图标
 *
 *  @return 返回一个UIBarButtonItem类型
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image heighImage:(NSString *)heighImage title:(NSString *)title;
@end
