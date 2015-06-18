//
//  HCDropDownRightMenuView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCDropDownRightMenuView.h"

@interface HCDropDownRightMenuView()
/** 下拉菜单容器 */
@property (nonatomic, strong) UIImageView *container;
@end

@implementation HCDropDownRightMenuView

/** 显示下拉菜单 */
- (void)showFromView:(UIView *)from
{
    //1. 设置下拉菜单容器的位置
    //将传入的fromview切换坐标系至窗口
    CGRect viewFrame = [from convertRect:from.bounds toView:nil];
    
    CGRect frame = self.container.frame;
    frame.origin.y = CGRectGetMaxY(viewFrame);
    frame.origin.x = CGRectGetMaxX(viewFrame) - frame.size.width + 7;
    self.container.frame = frame;
    
    //2. 在蒙板上添加下拉菜单容器view
    [self addSubview:self.container];
}

@end
