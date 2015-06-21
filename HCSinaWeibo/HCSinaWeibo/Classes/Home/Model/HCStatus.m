//
//  HCStatus.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStatus.h"
#import "HCPhoto.h"
#import "MJExtension.h"

@implementation HCStatus

+ (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [HCPhoto class]};
}

@end
