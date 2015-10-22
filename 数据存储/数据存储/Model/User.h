//
//  User.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>


@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * age;
@property (nonatomic,copy) NSString *arrayId;

@end
