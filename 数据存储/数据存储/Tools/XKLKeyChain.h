//
//  XKLKeyChain.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

extern NSString * const KEY_USERNAME_PASSWORD;
extern NSString * const KEY_USERNAME;
extern NSString * const KEY_PASSWORD;

@interface XKLKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end

/**
 
 keychain里保存的信息不会因App被删除而丢失，在用户重新安装App后依然有效，数据还在
 
 **/