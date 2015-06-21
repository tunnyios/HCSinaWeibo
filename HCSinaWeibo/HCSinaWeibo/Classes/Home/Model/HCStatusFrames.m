//
//  HCStatusFrames.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStatusFrames.h"


#define HCStatusCellBorderW   10

@implementation HCStatusFrames

- (void)setStatus:(HCStatus *)status
{
    _status = status;
    
    /** 头像 */
    CGFloat iconWH = 50;
    CGFloat iconX = HCStatusCellBorderW;
    CGFloat iconY = HCStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
//    @property (nonatomic, assign) CGRect nameLabelF;
    /** 会员 */
//    @property (nonatomic, assign) CGRect vipViewF;
    /** 微博发布时间 */
//    @property (nonatomic, assign) CGRect timeLabelF;
    /** 微博来源 */
//    @property (nonatomic, assign) CGRect sourceLabelF;
    /** 微博正文 */
//    @property (nonatomic, assign) CGRect contentLabelF;
    
    /** 原创微博 */
    self.originalViewF = CGRectMake(HCStatusCellBorderW, HCStatusCellBorderW, HCScreenWidth - 2 * HCStatusCellBorderW, 60);
    
    /** cell高度 */
    self.cellHeight = 100;
    
    
}

@end
