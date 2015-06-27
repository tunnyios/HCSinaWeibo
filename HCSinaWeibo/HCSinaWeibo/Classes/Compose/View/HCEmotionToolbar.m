//
//  HCEmotionToolbar.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCEmotionToolbar.h"

@interface HCEmotionToolbar ()
/** 被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation HCEmotionToolbar

- (void)setDelegate:(id<HCEmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    //设置默认选中(根据tag取出对应的view)
    [self btnClick:(UIButton *)[self viewWithTag:HCEmotionToolbarTypeDefault]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //表情工具栏切换按钮
        UIButton *recentBtn = [self creatBtnWithTitle:@"最近" backNorImg:@"compose_emotion_table_left_normal" backSelectedImg:@"compose_emotion_table_left_selected"];
        recentBtn.tag = HCEmotionToolbarTypeRecent;
        
        UIButton *defaultBtn = [self creatBtnWithTitle:@"默认" backNorImg:@"compose_emotion_table_mid_normal" backSelectedImg:@"compose_emotion_table_mid_selected"];
        defaultBtn.tag = HCEmotionToolbarTypeDefault;
        
        UIButton *emojiBtn = [self creatBtnWithTitle:@"Emoji" backNorImg:@"compose_emotion_table_mid_normal" backSelectedImg:@"compose_emotion_table_mid_selected"];
        emojiBtn.tag = HCEmotionToolbarTypeEmoji;
        
        UIButton *lxhBtn = [self creatBtnWithTitle:@"浪小花" backNorImg:@"compose_emotion_table_right_normal" backSelectedImg:@"compose_emotion_table_right_selected"];
        lxhBtn.tag = HCEmotionToolbarTypeLxh;
    }
    
    return self;
}

/**
 *  创建一个按钮
 *
 *  @param title
 *  @param backgroundImg
 */
- (UIButton *)creatBtnWithTitle:(NSString *)title backNorImg:(NSString *)backNorImg backSelectedImg:(NSString *)backSelectedImg
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:backNorImg] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:backSelectedImg] forState:UIControlStateSelected];
    
    [self addSubview:btn];
    
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    self.selectedBtn = btn;
    self.selectedBtn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbarDidSelectedWithType:)]) {
        [self.delegate emotionToolbarDidSelectedWithType:btn.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    __block CGFloat btnX = 0;
    __block CGFloat btnY = 0;
    __block CGFloat btnW = viewW / self.subviews.count;
    __block CGFloat btnH = viewH;
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {  
        btnX = idx * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }];
}
@end
