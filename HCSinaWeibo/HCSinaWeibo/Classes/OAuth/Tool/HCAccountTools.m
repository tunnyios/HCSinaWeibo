//
//  HCAccountTools.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  实现一些与账户相关的方法：账户存储、账户读取、账户验证是否过期

#import "HCAccountTools.h"
#import "HCAccount.h"


#define HCAccountPath   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation HCAccountTools

/**
 *  存储账户到沙盒
 *
 *  @param account
 */
+ (void)saveAccountWithAccount:(HCAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:HCAccountPath];
}

/**
 *  获取账户
 *
 *  @return 获取不到或者账户过期返回nil
 */
+ (HCAccount *)account
{
    //从沙盒中获取账户
    HCAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HCAccountPath];
    
    //判断账户是否过期
    NSDate *currentDate = [NSDate date];
    long long expires_in = [account.expires_in longLongValue];
    NSDate *expiresDate = [account.created_time dateByAddingTimeInterval:expires_in];
    if (NSOrderedDescending != [expiresDate compare:currentDate]) {  //过期
       
        return nil;
    }
    
//    DLog(@"--%@--%@--", currentDate, expiresDate);
    return account;
}

@end
