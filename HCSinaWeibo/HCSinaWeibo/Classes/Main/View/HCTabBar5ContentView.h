//
//  HCTabBar5ContentView.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCTabBar5ContentView;
@protocol HCTabBar5ContenViewDelegate <UITabBarDelegate>

@optional
- (void)tabBar5ContenViewWithTabBar:(HCTabBar5ContentView *)tabBar;

@end
@interface HCTabBar5ContentView : UITabBar
@property (nonatomic, weak) id<HCTabBar5ContenViewDelegate> tabBardelegate;

@end
