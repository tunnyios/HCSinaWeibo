//
//  HCEmotionContentView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCEmotionContentView.h"

@interface HCEmotionContentView ()
/** 表情内容滚动框 */
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation HCEmotionContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //ScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor colorWithRandom];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        //pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.backgroundColor = [UIColor colorWithRandom];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //pageControl
    self.pageControl.numberOfPages = self.count;
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 20, 320, 20);

    //ScorllView
    CGFloat scrollX = 0;
    CGFloat scrollY = 0;
    CGFloat scrollW = self.bounds.size.width;
    CGFloat scrollH = self.pageControl.frame.origin.y;
    self.scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
}

@end
