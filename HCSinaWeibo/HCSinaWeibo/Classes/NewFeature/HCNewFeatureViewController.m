//
//  HCNewFeatureViewController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCNewFeatureViewController.h"
#import "HCMainViewController.h"

@interface HCNewFeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation HCNewFeatureViewController

#define kImageCount     4

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        CGFloat sizeX = self.view.bounds.size.width * kImageCount;
        _scrollView.contentSize = CGSizeMake(sizeX, 0);

        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        
        _scrollView.delegate = self;
        
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        //设置位置
        CGSize size = [_pageControl sizeForNumberOfPages:kImageCount];
        CGRect frame = _pageControl.frame;
        frame.size = size;
        _pageControl.frame = frame;
        
        CGPoint center = _pageControl.center;
        center.x = self.view.center.x;
        center.y = self.view.bounds.size.height - 30;
        _pageControl.center = center;
        //设置属性
        _pageControl.numberOfPages = kImageCount;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithR:189 G:189 B:189 A:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithR:253 G:98 B:42 A:1.0];
        //监听pageControl的pageChange事件
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_pageControl];
    }
    
    return _pageControl;
}

/**
 *  监听pageControl的pageChange事件
 */
- (void)pageChanged:(UIPageControl *)pageControl
{
    //如果点击位置在当前位置左边，则value － 1，否则value ＋ 1
//    HCLog(@"--%ld--", (long)pageControl.currentPage);
    //根据当前的page修改scrollView的偏移
    CGFloat offsetX = pageControl.currentPage * self.view.bounds.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 创建scrollView
    [self scrollView];
    
    //2. 设置scrollView内容图片
    CGFloat viewW = self.view.bounds.size.width;
    for (int i = 0; i < kImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        //设置iamgeView的位置
        CGRect frame = imageView.frame;
        frame.origin.x = i * viewW;
        imageView.frame = frame;
        
        //为最后一张图片添加两个button
        if (i == (kImageCount - 1)) {
            imageView.userInteractionEnabled = YES;
            [self lastImageView:imageView];
        }
        
        [self.scrollView addSubview:imageView];
    }
    
    //3. 添加分页控制器
    [self pageControl];
}

/**
 *  在最后一个页面添加分享和进入微博按钮
 */
- (void)lastImageView:(UIImageView *)imageView
{
    //分享按钮
    UIButton *sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharedBtn addTarget:self action:@selector(shareNewFeature:) forControlEvents:UIControlEventTouchUpInside];
    sharedBtn.selected = YES;
    //位置
    CGFloat btnY = imageView.bounds.size.height * 0.6;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    sharedBtn.frame = CGRectMake(0, btnY, btnW, btnH);
    CGPoint center = sharedBtn.center;
    center.x = imageView.bounds.size.width * 0.5;
    sharedBtn.center = center;
    //内容
    [sharedBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateNormal];
    [sharedBtn setTitle:@"分享新特性" forState:UIControlStateNormal];
    [sharedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sharedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [imageView addSubview:sharedBtn];
    
    //进入微博按钮
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterBtn addTarget:self action:@selector(enterWeibo:) forControlEvents:UIControlEventTouchUpInside];
    //位置
    CGFloat enterY = imageView.bounds.size.height * 0.7;
    enterBtn.frame = CGRectMake(0, enterY, btnW, btnH);
    center = enterBtn.center;
    center.x = imageView.bounds.size.width * 0.5;
    enterBtn.center = center;
    //内容
    [enterBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [enterBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [enterBtn setTitle:@"进入新浪微博" forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [imageView addSubview:enterBtn];

    
    
    
    
}

/**
 *  进入微博按钮的点击事件
 */
- (void)enterWeibo:(UIButton *)button
{
    //切换控制器(不可逆型的，不需要再返回了，切换后直接销毁新特性控制器)
    //切换到主控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = [[HCMainViewController alloc] init];
}

/**
 *  分享按钮的点击是事件
 */
- (void)shareNewFeature:(UIButton *)button
{
    button.selected = !button.isSelected;
    //更改图标
    if (button.isSelected) {
        [button setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    }
}

#pragma mark - 监听scrollView的拖拽事件

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //使用者方法，更加精准
    CGPoint currentPoint = scrollView.contentOffset;
    //根据偏移量，计算出当前是第几张图
    //加上0.5 进行四舍五入
    self.pageControl.currentPage = (currentPoint.x / self.view.bounds.size.width + 0.5);
}

@end
