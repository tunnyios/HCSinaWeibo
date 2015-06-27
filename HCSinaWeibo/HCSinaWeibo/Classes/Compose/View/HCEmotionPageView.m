//
//  HCEmotionPageView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/27.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCEmotionPageView.h"
#import "HCEmotionModel.h"
#import "NSString+Emoji.h"


#define HCEmotionCol    7
#define HCEmotionRow    3
#define HCEmotionMargin     10

@interface HCEmotionPageView ()
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation HCEmotionPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.adjustsImageWhenHighlighted = NO;
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    
    return self;
}

- (void)cancelClick:(UIButton *)btn
{
    
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    //创建button
    for (int i = 0; i < emotions.count; i++) {
        HCEmotionModel *emotion = emotions[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        if (emotion.png) {
            [btn setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        } else if (emotion.code) {
            [btn setTitle:emotion.code.emoji forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //表情按钮
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = (self.bounds.size.width - 2 * HCEmotionMargin) / HCEmotionCol;
    CGFloat btnH = (self.bounds.size.height - HCEmotionMargin) / HCEmotionRow;
    for (int i = 0; i < self.emotions.count; i++) {
        UIButton *btn = self.subviews[i + 1];
        NSUInteger row = i / HCEmotionCol;
        NSUInteger col = i % HCEmotionCol;
    
        btnX = col * btnW + HCEmotionMargin;
        btnY = row * btnH + HCEmotionMargin;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    //删除按钮
    CGFloat deleteX = self.bounds.size.width - btnW - HCEmotionMargin;
    CGFloat deleteY = self.bounds.size.height - btnH;
    self.deleteBtn.frame = CGRectMake(deleteX, deleteY, btnW, btnH);
}

@end
