//
//  HCUser.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCUser.h"

@implementation HCUser

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

@end
