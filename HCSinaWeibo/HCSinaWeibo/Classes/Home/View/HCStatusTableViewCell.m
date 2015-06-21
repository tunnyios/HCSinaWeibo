//
//  HCStatusTableViewCell.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStatusTableViewCell.h"
#import "HCStatusFrames.h"
#import "HCStatus.h"
#import "HCUser.h"
#import "UIImageView+WebCache.h"

@interface HCStatusTableViewCell()
/** 原创微博 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 会员 */
@property (nonatomic, weak) UIImageView *vipView;
/** 微博发布时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 微博来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 微博正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 微博配图 */
@property (nonatomic, weak) UIImageView *photoView;



@end

@implementation HCStatusTableViewCell

/**
 *  快速实例化微博cell对象
 */
+ (instancetype)statusWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    HCStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HCStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {     //初始化子控件, 并设置一些唯一属性
        /** 原创微博 */
        UIView *originalView = [[UIView alloc] init];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /** 头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.originalView addSubview:iconView];
        self.iconView = iconView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = HCStatusNameFont;
        [self.originalView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 会员 */
        UIImageView *vipView = [[UIImageView alloc] init];
        [self.originalView addSubview:vipView];
        self.vipView = vipView;
        
        /** 微博发布时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = HCStatusTimeFont;
        [self.originalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 微博来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = HCStatusSourceFont;
        [self.originalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 微博正文 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = HCStatusContentFont;
        contentLabel.numberOfLines = 0;
        [self.originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;

    }
    
    return self;
}

/**
 *  设置微博cell的数据和位置
 */
- (void)setStatusFrames:(HCStatusFrames *)statusFrames
{
    _statusFrames = statusFrames;
    
    HCStatus *status = statusFrames.status;
    HCUser *user = status.user;
    
    /** 原创微博 */
    self.originalView.frame = statusFrames.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrames.iconViewF;
    NSURL *url = [NSURL URLWithString:user.profile_image_url];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    /** 昵称 */
    self.nameLabel.frame = statusFrames.nameLabelF;
    self.nameLabel.text = user.name;
    if (user.vip) {
        self.nameLabel.textColor = [UIColor redColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    /** 会员 */
    self.vipView.frame = statusFrames.vipViewF;
    if (user.vip) {
        NSString *imageStr = nil;
        if (user.mbrank > 6) {
            imageStr = @"common_icon_membership";
        } else if (user.mbrank < 1) {
            imageStr = @"common_icon_membership_expired";
        } else {
            imageStr = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        }
        self.vipView.image = [UIImage imageNamed:imageStr];
    }
    
    /** 微博发布时间 */
    self.timeLabel.frame = statusFrames.timeLabelF;
#warning sssssssss
//    self.timeLabel.text = status.created_at;
    self.timeLabel.text = @"刚刚";
    self.timeLabel.textColor = [UIColor orangeColor];
    
    /** 微博来源 */
    self.sourceLabel.frame = statusFrames.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 微博正文 */
    self.contentLabel.frame = statusFrames.contentLabelF;
    self.contentLabel.text = status.text;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
