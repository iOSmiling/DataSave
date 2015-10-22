//
//  UserCoreList+CoreDataProperties.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/17.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserCoreList.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCoreList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *aid;
@property (nullable, nonatomic, retain) NSString *age;

@end

NS_ASSUME_NONNULL_END
