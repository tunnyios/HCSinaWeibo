//
//  HCComposTextToolBar.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/26.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    HCComposTextToolBarTypeCarema,
    HCComposTextToolBarTypeAlbum,
    HCComposTextToolBarTypeAite,
    HCComposTextToolBarTypeTopic,
    HCComposTextToolBarTypeEmotion,
} HCComposTextToolBarType;

@protocol HCComposTextToolBarDelegate <NSObject>

@optional
/** toolbar上各个按钮被点击事件处理 */
- (void)composTextToolBarClickedWithType:(HCComposTextToolBarType)type;

@end

@interface HCComposTextToolBar : UIView

@property (nonatomic, weak) id<HCComposTextToolBarDelegate> delegate;

@end
