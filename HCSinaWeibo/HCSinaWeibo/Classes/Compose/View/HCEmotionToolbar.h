//
//  HCEmotionToolbar.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    HCEmotionToolbarTypeRecent,
    HCEmotionToolbarTypeDefault,
    HCEmotionToolbarTypeEmoji,
    HCEmotionToolbarTypeLxh,
} HCEmotionToolbarType;

@protocol HCEmotionToolbarDelegate <NSObject>

@optional
/** 选中对应的toolbarButton */
- (void)emotionToolbarDidSelectedWithType:(HCEmotionToolbarType)type;

@end

@interface HCEmotionToolbar : UIView

@property (nonatomic, weak) id<HCEmotionToolbarDelegate> delegate;

@end
