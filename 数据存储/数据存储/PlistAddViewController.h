//
//  PlistAddViewController.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "BaseViewController.h"

//操作类型
typedef enum
{
    ADD = 0,
    CHANGE
}handleType;

@interface PlistAddViewController : BaseViewController


@property (nonatomic,assign) handleType type;
@property (nonatomic,strong) UITextField *nameTextField;

@property (nonatomic,assign) NSInteger arrayIndex;

@end
