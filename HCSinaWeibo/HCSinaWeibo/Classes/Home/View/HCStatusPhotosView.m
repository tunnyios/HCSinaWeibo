//
//  HCStatusPhotosView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStatusPhotosView.h"
#import "HCStatusPhotoView.h"
#import "UIImageView+WebCache.h"


#define HCStatusPhotosViewMaxCol(count)    ((count == 4) ? 2 : 3)
#define HCStatusPhotosViewPadding   5
#define HCStatusPhotoWH             70

@implementation HCStatusPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建count个小图片控件
        
    }
    return self;
}

- (void)setPhotosList:(NSArray *)photosList
{
    _photosList = photosList;
    
    //创建子控件count个小图片
    while (self.subviews.count < photosList.count) {
        HCStatusPhotoView *photoView = [[HCStatusPhotoView alloc] init];
        photoView.backgroundColor = [UIColor yellowColor];
        [self addSubview:photoView];
    }
    //已创建足够个小图片,设置图片
    [self.subviews enumerateObjectsUsingBlock:^(HCStatusPhotoView *photoView, NSUInteger idx, BOOL *stop) {
        if (idx >= photosList.count) {
            //隐藏多余的子控件
            photoView.hidden = YES;
        } else {
            photoView.photo = photosList[idx];
            photoView.hidden = NO;
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置位置
    for (int i = 0; i < self.photosList.count; i++) {
        HCStatusPhotoView *photoView = self.subviews[i];
        NSUInteger maxCol = HCStatusPhotosViewMaxCol(self.photosList.count);
        NSUInteger row = i / maxCol;
        NSUInteger col = i % maxCol;
        CGFloat photoViewX = col * (HCStatusPhotoWH + HCStatusPhotosViewPadding);
        CGFloat photoViewY = row * (HCStatusPhotoWH + HCStatusPhotosViewPadding);
        
        photoView.frame = CGRectMake(photoViewX, photoViewY, HCStatusPhotoWH, HCStatusPhotoWH);
    }
}

/**
 *  传入一个值计算photosView的尺寸
 *
 *  @param count 传入photos中包含多少个子控件
 *
 *  @return CGSize
 */
+ (CGSize)photosViewSizeWithCount:(NSUInteger)count
{
    NSUInteger maxCol = HCStatusPhotosViewMaxCol(count);
    NSUInteger row = (count - 1) / maxCol;
    NSUInteger col = (count > maxCol) ? maxCol - 1 : count - 1;
    
    CGFloat photsViewW = col * (HCStatusPhotoWH + HCStatusPhotosViewPadding) + HCStatusPhotoWH;
    CGFloat photosViewH = row * (HCStatusPhotoWH + HCStatusPhotosViewPadding) + HCStatusPhotoWH;
    
//    DLog(@"-count:%lu-row:%lu--col:%lu--W:%f--H:%f", (unsigned long)count, (unsigned long)row, (unsigned long)col, photsViewW, photosViewH);
    
    return CGSizeMake(photsViewW, photosViewH);
}

@end
