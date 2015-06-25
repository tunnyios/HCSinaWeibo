//
//  HCStatusPhotoView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "HCPhoto.h"

@implementation HCStatusPhotoView

- (void)setPhoto:(HCPhoto *)photo
{
    _photo = photo;
    
    NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

@end
