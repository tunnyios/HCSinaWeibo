//
//  HCEmotionContentView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCEmotionContentView.h"
#import "HCEmotionPageView.h"


#define HCEmotionOnePageMaxCount    20

@interface HCEmotionContentView ()<UIScrollViewDelegate>
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
        scrollView.delegate = self;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        
        //pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    //计算需要分多少页，
    NSUInteger count = (emotions.count + HCEmotionOnePageMaxCount - 1) / HCEmotionOnePageMaxCount;
    self.pageControl.numberOfPages = count;
    
    //创建EmotionPageView
    for (int i = 0; i < count; i++) {
        HCEmotionPageView *pageView = [[HCEmotionPageView alloc] init];
        
        //计算每一页的表情范围
        NSRange range;
        range.location = i * HCEmotionOnePageMaxCount;
        NSUInteger left = emotions.count - range.location;
        if (i == count - 1) {
            range.length = left;
        } else {
            range.length = HCEmotionOnePageMaxCount;
        }
        
        //设置pageView的内容
        pageView.emotions = [emotions subarrayWithRange:range];
        
        [self.scrollView addSubview:pageView];
    }
    
}

#pragma mark - scorllView滚动监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger count = scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.pageControl.currentPage =  count + 0.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //pageControl
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 40, 320, 40);

    //ScorllView
    CGFloat scrollX = 0;
    CGFloat scrollY = 0;
    CGFloat scrollW = self.bounds.size.width;
    CGFloat scrollH = self.pageControl.frame.origin.y;
    self.scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    
    //设置每一个pageView的位置
    __block CGFloat pageX = 0;
    __block CGFloat pageY = 0;
    __block CGFloat pageW = scrollW;
    __block CGFloat pageH = scrollH;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(HCEmotionPageView *pageView, NSUInteger idx, BOOL *stop) {
        pageX = idx * pageW;
        pageView.frame = CGRectMake(pageX, pageY, pageW, pageH);
    }];
    
    //设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(scrollW * self.scrollView.subviews.count, scrollH);
}

@end
