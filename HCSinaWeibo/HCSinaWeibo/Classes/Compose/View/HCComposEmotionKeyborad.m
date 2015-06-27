//
//  HCComposEmotionView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCComposEmotionKeyborad.h"
#import "HCEmotionToolbar.h"
#import "HCEmotionContentView.h"

@interface HCComposEmotionKeyborad()<HCEmotionToolbarDelegate>

/** 表情工具条 */
@property (nonatomic, weak) HCEmotionToolbar *emotionToolbar;
/** 表情容器 */
@property (nonatomic, weak) HCEmotionContentView *emotionContent;

/** 最近表情 */
@property (nonatomic, strong) HCEmotionContentView *emotionRecentView;
/** 默认表情 */
@property (nonatomic, strong) HCEmotionContentView *emotionDefaultView;
/** Emoji表情 */
@property (nonatomic, strong) HCEmotionContentView *emotionEmojiView;
/** 浪小花表情 */
@property (nonatomic, strong) HCEmotionContentView *emotionLxhView;

@end

@implementation HCComposEmotionKeyborad

- (HCEmotionContentView *)emotionRecentView
{
    if (_emotionRecentView == nil) {
        _emotionRecentView = [[HCEmotionContentView alloc] init];
        _emotionRecentView.count = 4;
    }
    
    return _emotionRecentView;
}

- (HCEmotionContentView *)emotionDefaultView
{
    if (_emotionDefaultView == nil) {
        _emotionDefaultView = [[HCEmotionContentView alloc] init];
        _emotionDefaultView.count = 2;
    }
    
    return _emotionDefaultView;
}

- (HCEmotionContentView *)emotionEmojiView
{
    if (_emotionEmojiView == nil) {
        _emotionEmojiView = [[HCEmotionContentView alloc] init];
        _emotionEmojiView.count = 5;
    }
    
    return _emotionEmojiView;
}

- (HCEmotionContentView *)emotionLxhView
{
    if (_emotionLxhView == nil) {
        _emotionLxhView = [[HCEmotionContentView alloc] init];
        _emotionLxhView.count = 1;
    }
    
    return _emotionLxhView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //contentView
        self.emotionContent = self.emotionDefaultView;
        [self addSubview:self.emotionContent];
        
        //emotionToolbar
        HCEmotionToolbar *emotionToolbar = [[HCEmotionToolbar alloc] init];
        emotionToolbar.delegate = self;
        [self addSubview:emotionToolbar];
        self.emotionToolbar = emotionToolbar;
    }
    
    return self;
}

#pragma mark - emotionToolBar代理 点击事件处理
- (void)emotionToolbarDidSelectedWithType:(HCEmotionToolbarType)type
{
    //1. 移除从视图上移除当前的view
    [self.emotionContent removeFromSuperview];
    //2. 切换view
    switch (type) {
        case HCEmotionToolbarTypeRecent:
            [self addSubview:self.emotionRecentView];
            break;
        case HCEmotionToolbarTypeDefault:
            [self addSubview:self.emotionDefaultView];
            break;
        case HCEmotionToolbarTypeEmoji:
            [self addSubview:self.emotionEmojiView];
            break;
        case HCEmotionToolbarTypeLxh:
            [self addSubview:self.emotionLxhView];
            break;
            
        default:
            break;
    }
    
    //设置view的位置
    self.emotionContent = [self.subviews lastObject];
    
    //重新调用layoutSubViews
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    CGFloat emotionToolbarW = viewW;
    CGFloat emotionToolbarH = 32;
    CGFloat emotionToolbarX = 0;
    CGFloat emotionToolbarY = viewH - emotionToolbarH;
    self.emotionToolbar.frame = CGRectMake(emotionToolbarX, emotionToolbarY, emotionToolbarW, emotionToolbarH);
    
    CGFloat contentX = 0;
    CGFloat contentY = 0;
    CGFloat contentW = viewW;
    CGFloat contentH = emotionToolbarY;
    self.emotionContent.frame = CGRectMake(contentX, contentY, contentW, contentH);
}

@end
