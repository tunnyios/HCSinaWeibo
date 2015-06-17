//
//  UIBarButtonItem+Extension.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/17.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

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
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image heighImage:(NSString *)heighImage title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    //设置图片
    if (image) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    
    if (heighImage) {
        [btn setImage:[UIImage imageNamed:heighImage] forState:UIControlStateHighlighted];
    }
    
    //设置title
    if (title) {
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
    }
    
    //设置尺寸
    if (title) {
        btn.frame = CGRectMake(0, 0, 30, 30);
    } else if (image || heighImage) {
        btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
