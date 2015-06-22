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

- (NSString *)created_at
{
    /**
     1.今年
     1> 今天
     * 1分内： 刚刚
     * 1分~59分内：xx分钟前
     * 大于60分钟：xx小时前
     
     2> 昨天
     * 昨天 xx:xx
     
     3> 其他
     * xx-xx xx:xx
     
     2.非今年
     1> xxxx-xx-xx xx:xx
     */
    
    //转换创建日期格式 Mon Jun 22 11:09:02 +0800 2015
//    _created_at = @"Mon Jun 22 14:50:00 +0800 2015";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //真机调试需要转换这种欧美时间，需要设置local
//    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //2015-06-22 03:15:03 +0000
    NSDate *creatDate = [formatter dateFromString:_created_at];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *creatStr = [formatter stringFromDate:creatDate];

    //取当前日期时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit currentUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *currentComponents = [calendar components:currentUnit fromDate:currentDate];
    NSString *currentYearStr = [NSString stringWithFormat:@"%ld-12-31 23:59:59", (long)currentComponents.year];
    NSDate *currentYearDate = [formatter dateFromString:currentYearStr];
    NSDate *currentDayDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", (long)currentComponents.year, (long)currentComponents.month, (long)currentComponents.day]];

    //计算创建日期距当前的时间差
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *creatYearComponents = [calendar components:unit fromDate:creatDate toDate:currentYearDate options:0];
    NSDateComponents *creatDayComponents = [calendar components:unit fromDate:creatDate toDate:currentDayDate options:0];
    
    //判断是否今年
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    creatStr = [formatter stringFromDate:creatDate];
    
    if (0 == creatYearComponents.year) {
//        DLog(@"是今年");
        if (0 == creatDayComponents.day) {  //今天
            NSTimeInterval second = [creatDate timeIntervalSinceNow];
            if ((int)(second / 3600)) {  //几小时前
                creatStr = [NSString stringWithFormat:@"%d小时前", (int)-second / 3600];
            } else {
                if ((int)(second / 60)) {  //几分钟前
                    creatStr = [NSString stringWithFormat:@"%d分钟前", (int)-second / 60];
                } else {
                    creatStr = @"刚刚";
                }
            }
           
        } else if (1 == creatDayComponents.day) {   //昨天
            creatStr = [creatStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%ld-%ld-%ld", (long)currentComponents.year, (long)currentComponents.month, (long)currentComponents.day] withString:@"昨天"];
        } else {    //其他
            creatStr = [creatStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%ld-", (long)currentComponents.year] withString:@""];
        }

    } else {
        DLog(@"去年--%@--", creatStr);
    }
    
    return creatStr;
}

- (NSString *)source
{
    //<a href="http://app.weibo.com/t/feed/4ovNG8" rel="nofollow">果壳网</a>
    
    NSString *str = _source;
    NSRange startRange = [str rangeOfString:@">"];
    str = [str substringFromIndex:(startRange.location + startRange.length)];

    NSRange endRange = [str rangeOfString:@"<"];
    str = [str substringToIndex:endRange.location];
    str = [NSString stringWithFormat:@"来自 %@", str];
    return str;
}
@end
