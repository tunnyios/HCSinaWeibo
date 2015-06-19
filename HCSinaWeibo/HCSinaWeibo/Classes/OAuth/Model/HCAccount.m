//
//  HCAccount.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCAccount.h"

@interface HCAccount()<NSCoding>

@end

@implementation HCAccount

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.access_token = dict[@"access_token"];
        self.expires_in = dict[@"expires_in"];
        self.uid = dict[@"uid"];
    }
    
    return self;
}

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[HCAccount alloc] initWithDict:dict];
}

#pragma mark - 实现NSCoding的代理方法，用于解档， 归档

/** 归档 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
}

/** 解档 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
    }
    
    return self;
}

@end
