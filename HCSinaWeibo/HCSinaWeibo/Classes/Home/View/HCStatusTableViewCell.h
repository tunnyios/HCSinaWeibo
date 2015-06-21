//
//  HCStatusTableViewCell.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCStatusFrames;
@interface HCStatusTableViewCell : UITableViewCell

/** 提供一个statusFrames模型(包含数据和位置) */
@property (nonatomic, strong) HCStatusFrames *statusFrames;

/** 快速实例化tableViewCell */
+ (instancetype)statusWithTableView:(UITableView *)tableView;
@end
