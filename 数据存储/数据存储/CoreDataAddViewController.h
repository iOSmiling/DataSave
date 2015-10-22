//
//  CoreDataAddViewController.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/17.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "BaseViewController.h"
#import "UserCoreList.h"

typedef enum : NSUInteger
{
    ADD,
    CHANGE
} Type;

@interface CoreDataAddViewController : BaseViewController


@property (nonatomic, assign) Type type;

@property (nonatomic,assign) NSInteger arrayIndex;

@property (nonatomic,retain) UserCoreList *user;

@end
