//
//  FMDBAddViewController.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/16.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "BaseViewController.h"

//操作类型
typedef enum
{
    ADD = 0,
    CHANGE
}handleFMDBType;

@interface FMDBAddViewController : BaseViewController


@property (nonatomic,assign) handleFMDBType type;

@property (nonatomic,assign) NSInteger arrayIndex; 

@end
