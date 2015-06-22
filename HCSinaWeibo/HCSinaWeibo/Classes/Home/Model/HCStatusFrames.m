//
//  HCStatusFrames.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStatusFrames.h"
#import "HCUser.h"
#import "HCStatus.h"


#define HCStatusCellBorderW   10

@implementation HCStatusFrames

/**
 *  计算文字的最合适的尺寸
 *
 *  @param text     文字
 *  @param font     字体
 *  @param maxWidth 一行最大宽度
 *
 *  @return 
 */
- (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font MaxWidth:(CGFloat)maxWidth
{
    NSDictionary *fontDict = @{NSFontAttributeName : font
                               };
    
    return [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil].size;
}


- (void)setStatus:(HCStatus *)status
{
    _status = status;
    
    //1. 设置原创微博View的frame
    [self setOriginalViewFramesWithStatus:status];
    
    //2. 设置转发微博View的frame
    if (status.retweeted_status) {
        [self setRetweetedViewFramesWithStatus:status];
        
        //3. 设置转发、评论、点赞工具条的frame
        self.toolViewF = CGRectMake(0, CGRectGetMaxY(self.retweetedViewF), HCScreenWidth, 30);
        
        /** cell高度 */
        self.cellHeight = CGRectGetMaxY(self.originalViewF) + self.retweetedViewF.size.height + self.toolViewF.size.height + HCStatusCellBorderW;
    } else {
        //3. 设置转发、评论、点赞工具条的frame
        self.toolViewF = CGRectMake(0, CGRectGetMaxY(self.originalViewF), HCScreenWidth, 30);
        
        /** cell高度 */
        self.cellHeight = CGRectGetMaxY(self.originalViewF) + self.toolViewF.size.height + HCStatusCellBorderW;
    }
    
    
}

/**
 *  设置转发微博View的frame
 */
- (void)setRetweetedViewFramesWithStatus:(HCStatus *)status
{
    HCStatus *retweeted_status = status.retweeted_status;
    HCUser *retweeted_user = retweeted_status.user;
    
    /** 转发微博正文 */
    CGFloat contentX = HCStatusCellBorderW;
    CGFloat contentY = HCStatusCellBorderW;
    CGFloat maxWidth = HCScreenWidth - HCStatusCellBorderW - HCStatusCellBorderW * 2;
    //取正文
    NSString *contentStr = [NSString stringWithFormat:@"@%@:%@", retweeted_user.name, retweeted_status.text];
    CGSize contentSize = [self textSizeWithText:contentStr font:HCStatusContentFont MaxWidth:maxWidth];
    self.retweeted_contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 转发微博配图 */
    CGFloat retweetedH = 0;
    if (retweeted_status.pic_urls.count) {
        CGFloat photoX = HCStatusCellBorderW;
        CGFloat photoY = CGRectGetMaxY(self.retweeted_contentLabelF) + HCStatusCellBorderW;
        CGFloat photoWH = 100;
        self.retweeted_photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        
        retweetedH = CGRectGetMaxY(self.retweeted_photoViewF) + HCStatusCellBorderW;
    } else {
        retweetedH = CGRectGetMaxY(self.retweeted_contentLabelF) + HCStatusCellBorderW;
    }
    
    /** 转发微博 */
    CGFloat retweetedY = CGRectGetMaxY(self.originalViewF);
    self.retweetedViewF = CGRectMake(0, retweetedY, HCScreenWidth, retweetedH);
}

/**
 *  设置原创微博View的frame
 */
- (void)setOriginalViewFramesWithStatus:(HCStatus *)status
{
    HCUser *user = status.user;
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = HCStatusCellBorderW;
    CGFloat iconY = HCStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGSize nameSize = [self textSizeWithText:user.name font:HCStatusNameFont MaxWidth:CGFLOAT_MAX];
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HCStatusCellBorderW;
    CGFloat nameY = iconY;
//    self.nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员 */
    if (user.vip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + HCStatusCellBorderW * 0.5;
        CGFloat vipY = iconY;
        CGFloat vipW = 15;
        CGFloat vipH = nameSize.height;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    } else {
        self.vipViewF = CGRectZero;
    }
    
    /** 微博发布时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + HCStatusCellBorderW * 0.3;
    CGSize timeSize = [self textSizeWithText:@"刚刚" font:HCStatusTimeFont MaxWidth:CGFLOAT_MAX];
//    self.timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 微博来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + HCStatusCellBorderW * 0.5;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self textSizeWithText:status.source font:HCStatusSourceFont MaxWidth:CGFLOAT_MAX];
//    self.sourceLabelF = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 微博正文 */
    CGFloat contentX = HCStatusCellBorderW;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + HCStatusCellBorderW;
    CGFloat maxWidth = HCScreenWidth - HCStatusCellBorderW - HCStatusCellBorderW * 2;
    CGSize contentSize = [self textSizeWithText:status.text font:HCStatusContentFont MaxWidth:maxWidth];
//    self.contentLabelF = CGRectMake(contentX, contentY, contentW, contentH);
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 微博配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) {
        CGFloat photoX = iconX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + HCStatusCellBorderW;
        CGFloat photoWH = 100;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        
        originalH = CGRectGetMaxY(self.photoViewF) + HCStatusCellBorderW;
    } else {
        originalH = CGRectGetMaxY(self.contentLabelF) + HCStatusCellBorderW;
    }
    
    /** 原创微博 */
    self.originalViewF = CGRectMake(0, 0, HCScreenWidth, originalH);
}

@end
