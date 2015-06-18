//
//  HCDropDownMenu.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCDropDownMenuView : UIView

/** 下拉菜单容器图片 */
@property (nonatomic, strong) NSString *containerImage;
/** 下拉菜单的内容 */
@property (nonatomic, strong) UIView *content;
/** 下拉菜单的内容控制器 */
@property (nonatomic, strong) UIViewController *contentController;

+ (instancetype)dropDownMenu;

- (void)showFromView:(UIView *)from;

- (void)disMiss;
@end
