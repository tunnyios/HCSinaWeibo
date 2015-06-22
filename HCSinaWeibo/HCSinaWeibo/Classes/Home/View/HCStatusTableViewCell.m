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
#import "HCPhoto.h"
#import "HCToolView.h"
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

/** 转发微博 */
@property (nonatomic, weak) UIView *retweetedView;
/** 转发微博微博正文 */
@property (nonatomic, weak) UILabel *retweeted_contentLabel;
/** 转发微博配图 */
@property (nonatomic, weak) UIImageView *retweeted_photoView;

/** 转发、评论、点赞工具条 */
@property (nonatomic, weak) HCToolView *toolView;

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
        //1. 创建原创微博View
        [self creatOriginalStatusView];
        
        //2. 创建转发微博View
        [self creatRetweetedStatusView];
        
        //3. 创建转发、评论、点赞工具条
        HCToolView *toolView = [[HCToolView alloc] init];
        [self.contentView addSubview:toolView];
        self.toolView = toolView;
        
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
    
    //1. 设置原创微博View的内容和位置
    [self setOriginalViewContentAndFrames:statusFrames status:status user:user];
    
    //2. 设置转发微博View的内容和位置
    if (self.statusFrames.status.retweeted_status) {
        [self setRetweetedViewContentAndFrames:statusFrames status:status];
        self.retweetedView.hidden = NO;
    }else {
        self.retweetedView.hidden = YES;
    }
    
    //3. 设置转发、评论、点赞工具条的内容位置
    self.toolView.frame = statusFrames.toolViewF;
    self.toolView.status = statusFrames.status;
}

/**
 *  创建转发微博View
 */
- (void)creatRetweetedStatusView
{
    /** 转发微博 */
    UIView *retweetedView = [[UIView alloc] init];
    retweetedView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_retweet_background"]];
    [self.contentView addSubview:retweetedView];
    self.retweetedView = retweetedView;
    
    /** 转发微博正文 */
    UILabel *retweeted_contentLabel = [[UILabel alloc] init];
    retweeted_contentLabel.font = HCStatusContentFont;
    retweeted_contentLabel.numberOfLines = 0;
    [self.retweetedView addSubview:retweeted_contentLabel];
    self.retweeted_contentLabel = retweeted_contentLabel;
    
    /** 转发微博配图 */
    UIImageView *retweeted_photoView = [[UIImageView alloc] init];
    [self.retweetedView addSubview:retweeted_photoView];
    self.retweeted_photoView = retweeted_photoView;
}

/**
 *  设置转发微博View的内容和位置
 */
- (void)setRetweetedViewContentAndFrames:(HCStatusFrames *)statusFrames status:(HCStatus *)status
{
    HCStatus *retweeted_status = status.retweeted_status;
    HCUser *retweeted_user = retweeted_status.user;
    
    /** 转发微博 */
    self.retweetedView.frame = statusFrames.retweetedViewF;
    
    /** 转发微博正文 */
    self.retweeted_contentLabel.frame = statusFrames.retweeted_contentLabelF;
    NSString *contentStr = [NSString stringWithFormat:@"@%@:%@", retweeted_user.name, retweeted_status.text];
    self.retweeted_contentLabel.text = contentStr;
    
    /** 转发微博配图 */
    if (retweeted_status.pic_urls.count) {
        self.retweeted_photoView.hidden = NO;
        self.retweeted_photoView.frame = statusFrames.retweeted_photoViewF;
        NSURL *photoUrl = [NSURL URLWithString:[[retweeted_status.pic_urls firstObject] thumbnail_pic]];
        [self.retweeted_photoView sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    } else {
        self.retweeted_photoView.hidden = YES;
    }
}

/**
 *  创建原创微博View控件
 */
- (void)creatOriginalStatusView
{
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
    
    /** 微博配图 */
    UIImageView *photoView = [[UIImageView alloc] init];
    [self.originalView addSubview:photoView];
    self.photoView = photoView;
}

/**
 *  设置原创微博View的内容和位置
 */
- (void)setOriginalViewContentAndFrames:(HCStatusFrames *)statusFrames status:(HCStatus *)status user:(HCUser *)user
{
    /** 原创微博 */
    self.originalView.frame = statusFrames.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrames.iconViewF;
    NSURL *iconUrl = [NSURL URLWithString:user.profile_image_url];
    [self.iconView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
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
    self.timeLabel.text = status.created_at;
    self.timeLabel.textColor = [UIColor orangeColor];
    
    /** 微博来源 */
    self.sourceLabel.frame = statusFrames.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 微博正文 */
    self.contentLabel.frame = statusFrames.contentLabelF;
    self.contentLabel.text = status.text;
    
    /** 微博配图 */
    if (status.pic_urls.count) {
        self.photoView.hidden = NO;
        self.photoView.frame = statusFrames.photoViewF;
        NSURL *photoUrl = [NSURL URLWithString:[[status.pic_urls firstObject] thumbnail_pic]];
        [self.photoView sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    } else {
        self.photoView.hidden = YES;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
