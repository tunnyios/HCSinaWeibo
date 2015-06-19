//
//  HCAccountTools.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  定义一些与账户相关的方法：账户存储、账户读取、账户验证是否过期

#import <Foundation/Foundation.h>
#import "HCAccount.h"


@interface HCAccountTools : NSObject

/** 存储账户 */
+ (void)saveAccountWithAccount:(HCAccount *)account;

/** 获取账户,验证是否过期也在这里做 */
+ (HCAccount *)account;

@end
