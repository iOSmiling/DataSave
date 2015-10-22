//
//  User.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        self.name = [coder decodeObjectForKey:@"name"];
        self.age = [coder decodeObjectForKey:@"age"];
        self.arrayId = [coder decodeObjectForKey:@"arrayId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.age forKey:@"age"];
    [coder encodeObject:self.arrayId forKey:@"arrayId"];
}


@end
