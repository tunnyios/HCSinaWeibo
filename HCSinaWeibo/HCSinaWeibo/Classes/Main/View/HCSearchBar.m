//
//  HCSearchBar.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCSearchBar.h"

@implementation HCSearchBar

/**
 *  创建一个搜索框
 *
 *  @param frame 搜索框的尺寸和位置
 *
 *  @return searchBar
 */
+ (instancetype)searchBarWithFrame:(CGRect)frame
{
    //searchbar basic
    HCSearchBar *searchBar = [[HCSearchBar alloc] init];
    searchBar.frame = frame;
    searchBar.background = [UIImage imageNamed:@"searchbar_textfield_background"];
    searchBar.font = [UIFont systemFontOfSize:15];
    searchBar.placeholder = @"请输入搜索条件";
    
    //leftView
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
    searchIcon.contentMode = UIViewContentModeCenter;
    
    searchBar.leftView = searchIcon;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    
    return searchBar;
}

@end
