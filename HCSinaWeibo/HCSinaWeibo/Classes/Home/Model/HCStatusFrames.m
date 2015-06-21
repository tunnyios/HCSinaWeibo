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
    CGFloat nameW = nameSize.width;
    CGFloat nameH = nameSize.height;
    self.nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);
    
    /** 会员 */
    if (user.vip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + HCStatusCellBorderW * 0.5;
        CGFloat vipY = iconY;
        CGFloat vipW = 15;
        CGFloat vipH = nameH;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    } else {
        self.vipViewF = CGRectZero;
    }
    
    /** 微博发布时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + HCStatusCellBorderW * 0.3;
    CGSize timeSize = [self textSizeWithText:@"刚刚" font:HCStatusTimeFont MaxWidth:CGFLOAT_MAX];
    CGFloat timeW = timeSize.width;
    CGFloat timeH = timeSize.height;
    self.timeLabelF = CGRectMake(timeX, timeY, timeW, timeH);
    
    /** 微博来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + HCStatusCellBorderW * 0.5;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self textSizeWithText:status.source font:HCStatusSourceFont MaxWidth:CGFLOAT_MAX];
    CGFloat sourceW = sourceSize.width;
    CGFloat sourceH = sourceSize.height;
    self.sourceLabelF = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    
    /** 微博正文 */
    CGFloat contentX = HCStatusCellBorderW;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + HCStatusCellBorderW;
    CGFloat maxWidth = HCScreenWidth - HCStatusCellBorderW - HCStatusCellBorderW * 2;
    CGSize contentSize = [self textSizeWithText:status.text font:HCStatusContentFont MaxWidth:maxWidth];
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    self.contentLabelF = CGRectMake(contentX, contentY, contentW, contentH);
    
    /** 原创微博 */
    CGFloat originalH = CGRectGetMaxY(self.contentLabelF);
    self.originalViewF = CGRectMake(0, 0, HCScreenWidth, originalH);
    
    /** cell高度 */
    self.cellHeight = 200;
    
    
}

@end
