//
//  HCUser.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCUser : NSObject

/** 用户友好昵称显示 */
@property (nonatomic, copy) NSString *name;

/** 用户ID */
@property (nonatomic, copy) NSString *idstr;

/** 用户头像URL */
@property (nonatomic, copy) NSString *profile_image_url;

/** 用户类型 > 2 才是会员*/
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic, assign) int mbrank;

/** 是否是会员 */
@property (nonatomic, assign, getter=isVip) BOOL vip;

@end
