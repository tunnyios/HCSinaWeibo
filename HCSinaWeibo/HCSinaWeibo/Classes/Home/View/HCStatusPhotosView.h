//
//  HCStatusPhotosView.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCStatusPhotosView : UIImageView

/** 图片url数组 */
@property (nonatomic, strong) NSArray *photosList;

/** 根据count获取photosView的尺寸 */
+ (CGSize)photosViewSizeWithCount:(NSUInteger)count;
@end
