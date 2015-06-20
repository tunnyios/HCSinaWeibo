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

@end
