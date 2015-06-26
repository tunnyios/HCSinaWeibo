//
//  HCPlaceHolderTextView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCPlaceHolderTextView.h"

@implementation HCPlaceHolderTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self becomeFirstResponder];
        
        //监听textView自己发出的 UITextViewTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

/**
 *  监听通知的回调函数
 */
- (void)textDidChanged
{
    //重绘，消除占位文字
    [self setNeedsDisplay];
}

/** 画出占位文字 */
- (void)drawRect:(CGRect)rect {
    
    //如果textView有文字输入，则不画占位文字
    if (self.hasText) return;
    
    CGRect textRect = CGRectMake(6, 7, 100, 20);
    NSDictionary *fontDict = @{NSFontAttributeName : self.font,
                               NSForegroundColorAttributeName : [UIColor redColor]
                               };
    [self.placeHolderText drawInRect:textRect withAttributes:fontDict];
}


@end
