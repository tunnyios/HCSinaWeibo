//
//  HCAccount.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCAccount : NSObject
/**
 "access_token" = "2.00jpaY9CCUqnfB667adfe6ca0qACwU";
 "expires_in" = 157679999;
 "remind_in" = 157679999;
 uid = 2254247815;
 */

/** appKey */
@property (nonatomic, copy) NSString *access_token;
/** 授权时长 */
@property (nonatomic, copy) NSString *expires_in;
/** 授权用户的UID */
@property (nonatomic, copy) NSString *uid;
/** 授权时的日期 */
@property (nonatomic, strong) NSDate *created_time;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
