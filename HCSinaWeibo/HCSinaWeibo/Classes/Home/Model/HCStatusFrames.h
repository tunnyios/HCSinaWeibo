//
//  HCStatusFrames.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  一个HWStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型HWStatus


#import <Foundation/Foundation.h>


#define HCStatusNameFont    [UIFont systemFontOfSize:15]
#define HCStatusTimeFont    [UIFont systemFontOfSize:10]
#define HCStatusSourceFont  [UIFont systemFontOfSize:10]
#define HCStatusContentFont [UIFont systemFontOfSize:15]


@class HCStatus;
@interface HCStatusFrames : NSObject
/** 原创微博 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 会员 */
@property (nonatomic, assign) CGRect vipViewF;
/** 微博发布时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 微博来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 微博正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** 微博配图 */
@property (nonatomic, assign) CGRect photoViewF;

/** 转发微博 */
@property (nonatomic, assign) CGRect retweetedViewF;
/** 转发微博正文 */
@property (nonatomic, assign) CGRect retweeted_contentLabelF;
/** 转发微博配图 */
@property (nonatomic, assign) CGRect retweeted_photoViewF;

/** 转发、评论、点赞工具条 */
@property (nonatomic, assign) CGRect toolViewF;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** status数据模型 */
@property (nonatomic, strong) HCStatus *status;

@end
