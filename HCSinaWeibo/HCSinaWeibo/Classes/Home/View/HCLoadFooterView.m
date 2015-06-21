//
//  HCLoadFooterView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCLoadFooterView.h"

@implementation HCLoadFooterView

+ (instancetype)footer
{
    HCLoadFooterView *footer = [[[NSBundle mainBundle]loadNibNamed:@"HCLoadFooterView" owner:nil options:nil] lastObject];
    
    return footer;
}

@end
