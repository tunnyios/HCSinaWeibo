//
//  HCStatus.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCUser;
@interface HCStatus : NSObject

/** 微博ID */
@property (nonatomic, copy) NSString *idStr;

/** 微博内容 */
@property (nonatomic, copy) NSString *text;

/** 微博作者的用户信息字段 */
@property (nonatomic, strong) HCUser *user;

@end
