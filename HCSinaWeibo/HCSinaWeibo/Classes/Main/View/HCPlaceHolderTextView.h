//
//  HCPlaceHolderTextView.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  带有占位文字的textView

#import <UIKit/UIKit.h>

@interface HCPlaceHolderTextView : UITextView <UITextViewDelegate>

/** 占位文字 */
@property (nonatomic, copy) NSString *placeHolderText;

@end
