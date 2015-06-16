//
//  UIColor+Tools.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "UIColor+Tools.h"

@implementation UIColor (Tools)

+ (instancetype)colorWithRandom
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];

    return color;
}

@end
