//
//  HCStatus.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCUser, HCStatus;
@interface HCStatus : NSObject

/** 微博ID */
@property (nonatomic, copy) NSString *idstr;

/** 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/** 微博内容 */
@property (nonatomic, copy) NSString *text;

/** 微博作者的用户信息字段 */
@property (nonatomic, strong) HCUser *user;

/** 微博配图数组 */
@property (nonatomic, strong) NSArray *pic_urls;

/** 转发数量 */
@property (nonatomic, assign) int reposts_count;

/** 评论数量 */
@property (nonatomic, assign) int comments_count;

/** 点赞数量 */
@property (nonatomic, assign) int attitudes_count;

/** 转发微博属性 */
@property (nonatomic, strong) HCStatus *retweeted_status;


@end
