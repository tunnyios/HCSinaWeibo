//
//  HCDropDownMenu.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCDropDownMenuView.h"

@interface HCDropDownMenuView()

/** 下拉菜单容器 */
@property (nonatomic, strong) UIImageView *container;

@end

@implementation HCDropDownMenuView

-(UIImageView *)container
{
    if (_container == nil) {
        _container = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
        //设置用户可交互
        _container.userInteractionEnabled = YES;
    }
    
    return _container;
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}

//根据容器的图片，手动计算内容的位置
- (void)setContent:(UIView *)content
{
    _content = content;
    
    //设置内容的位置
    CGFloat contentX = 10;
    CGFloat contentY = 14;
    CGFloat contentW = self.container.frame.size.width - 2 * contentX;
    CGFloat contentH = content.bounds.size.height;
    _content.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    //设置容器尺寸
    CGRect frame = self.container.frame;
    frame.size.height = contentH + contentY + 10;
    self.container.frame = frame;
    
    //3. 设置蒙板的内容
    [self.container addSubview:_content];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1. 创建一个透明的view当蒙板并显示
        UIApplication *application = [UIApplication sharedApplication];
        //这样可以得到最上面的窗口
        UIWindow *window = [application.windows lastObject];
        self.frame = window.bounds;
        self.backgroundColor = [UIColor clearColor];
        //添加蒙板到视图
        [window addSubview:self];
        
    }
    
    return self;
}

/** 点击蒙板销毁下拉菜单 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self disMiss];
}

/** 显示下拉菜单 */
- (void)showFromView:(UIView *)from
{
    //1. 设置下拉菜单容器的位置
    //将传入的fromview切换坐标系至窗口
    CGRect viewFrame = [from convertRect:from.bounds toView:nil];
    
    CGRect frame = self.container.frame;
    frame.origin.y = CGRectGetMaxY(viewFrame);
    self.container.frame = frame;
    
    CGPoint center = self.container.center;
    center.x = CGRectGetMidX(viewFrame);
    self.container.center = center;
    
    //2. 在蒙板上添加下拉菜单容器view
    [self addSubview:self.container];
}

/** 销毁下拉菜单 */
- (void)disMiss
{
    [self removeFromSuperview];
}

+ (instancetype)dropDownMenu
{
    return [[HCDropDownMenuView alloc] init];
}

@end
