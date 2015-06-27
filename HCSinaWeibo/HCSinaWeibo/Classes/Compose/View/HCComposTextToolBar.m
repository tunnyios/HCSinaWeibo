//
//  HCComposTextToolBar.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCComposTextToolBar.h"

@interface HCComposTextToolBar()

@end

@implementation HCComposTextToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //设置toobar内容
        [self setupButtons];
        
    }
    return self;
}

/**
 *  设置按钮内容
 */
- (void)setupButtons
{
    UIButton *carema = [self creatBtnWithIcon:@"compose_camerabutton_background" heighIcon:@"compose_camerabutton_background_highlighted"];
    carema.tag = HCComposTextToolBarTypeCarema;
    
    UIButton *album = [self creatBtnWithIcon:@"compose_toolbar_picture" heighIcon:@"compose_toolbar_picture_highlighted"];
    album.tag = HCComposTextToolBarTypeAlbum;
    
    UIButton *aite= [self creatBtnWithIcon:@"compose_mentionbutton_background" heighIcon:@"compose_mentionbutton_background_highlighted"];
    aite.tag = HCComposTextToolBarTypeAite;
    
    UIButton *topic = [self creatBtnWithIcon:@"compose_trendbutton_background" heighIcon:@"compose_trendbutton_background_highlighted"];
    topic.tag = HCComposTextToolBarTypeTopic;
    
    UIButton *emotion = [self creatBtnWithIcon:@"compose_emoticonbutton_background" heighIcon:@"compose_emoticonbutton_background_highlighted"];
    self.isEmotion = YES;
    emotion.tag = HCComposTextToolBarTypeEmotion;
    
}

/**
 *  创建一个按钮
 *
 *  @param icon      图片
 *  @param heighIcon 高亮图片
 *
 *  @return
 */
- (UIButton *)creatBtnWithIcon:(NSString *)icon heighIcon:(NSString *)heighIcon
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:heighIcon] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return btn;
}

/** 按钮被点击 */
- (void)btnClick:(UIButton *)btn
{
    //切换emotion图标
    if (HCComposTextToolBarTypeEmotion == btn.tag) {
        self.isEmotion = !_isEmotion;
        if (self.isEmotion) {
            [btn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
        } else {
            [btn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(composTextToolBarClickedWithType:)]) {
        [self.delegate composTextToolBarClickedWithType:btn.tag];
    }
    
}


#pragma mark - 设置各个按钮的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGFloat btnX = 0;
    __block CGFloat btnY = 0;
    __block CGFloat btnW = self.bounds.size.width / self.subviews.count;
    __block CGFloat btnH = self.bounds.size.height;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btnX = idx * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }];
}

@end
