//
//  NSUserDefaultViewController.h
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "BaseViewController.h"

@interface NSUserDefaultViewController : BaseViewController

@end

/**

    1:NSUserDefaults支持的数据类型有：NSNumber（NSInteger、float、double），NSString，NSDate，NSArray，NSDictionary，BOOL.


 
    BOOL 
 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"one"];
 
        [[NSUserDefaults standardUserDefaults] boolForKey:@"one"];
 
    NSString
          
         [user setObject:self.nameTextField.text forKey:@"userName"];
        
         [user objectforkey:@""];

**/