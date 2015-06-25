//
//  HCToolView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/22.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCToolView.h"
#import "HCStatus.h"

@interface HCToolView ()

/** button数组 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/** 分割线数组 */
@property (nonatomic, strong) NSMutableArray *dividerArray;

/** 转发按钮 */
@property (nonatomic, weak) UIButton *repostBtn;
/** 评论按钮 */
@property (nonatomic, weak) UIButton *commentBtn;
/** 点赞按钮 */
@property (nonatomic, weak) UIButton *attitudeBtn;

@end

@implementation HCToolView

- (NSMutableArray *)btnArray
{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (NSMutableArray *)dividerArray
{
    if (_dividerArray == nil) {
        _dividerArray = [NSMutableArray array];
    }
    
    return _dividerArray;
}

#pragma mark - 创建cell工具条的子控件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        //添加button
        self.repostBtn = [self setupBtnWithTitle:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtnWithTitle:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtnWithTitle:@"赞" icon:@"timeline_icon_unlike"];
        
        //添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    
    return self;
}

- (void)setStatus:(HCStatus *)status
{
    _status = status;
    
    //设置按钮的title
    [self setupBtnWithCount:status.reposts_count title:@"转发" btn:self.repostBtn];
    [self setupBtnWithCount:status.comments_count title:@"评论" btn:self.commentBtn];
    [self setupBtnWithCount:status.attitudes_count title:@"赞" btn:self.attitudeBtn];
    
}

- (void)setupBtnWithCount:(int)count title:(NSString *)title btn:(UIButton *)btn
{
    if (count) {
        if (count >= 10000) {
            title = [NSString stringWithFormat:@"%.01f万", (count / 10000.0)];
            //如果是1.0万,去掉.0
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        } else {
            title = [NSString stringWithFormat:@"%d", count];
        }
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
}

#pragma  mark - 设置位置
/**
 *  自动布局设置各个按钮的位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGFloat btnX = 0;
    __block CGFloat btnY = 0;
    __block CGFloat btnW = self.bounds.size.width / self.btnArray.count;
    __block CGFloat btnH = self.bounds.size.height;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btnX = idx * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }];
    
    [self.dividerArray enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectMake(0, 0, 1, btnH);
        CGRect frame = obj.frame;
        frame.origin.x = [self.btnArray[idx + 1] frame].origin.x;
        obj.frame = frame;
    }];
}

/**
 *  创建一条分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line_highlighted"];
    
    [self addSubview:divider];
    [self.dividerArray addObject:divider];
}

/**
 *  创建一个button按钮
 */
- (UIButton *)setupBtnWithTitle:(NSString *)titile icon:(NSString *)icon
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:titile forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_line_highlighted"] forState:UIControlStateHighlighted];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [self addSubview:btn];
    [self.btnArray addObject:btn];
    btn.backgroundColor = [UIColor colorWithRandom];
    return btn;
}

@end
