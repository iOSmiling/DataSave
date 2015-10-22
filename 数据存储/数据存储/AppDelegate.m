//
//  AppDelegate.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FMDB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *view = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //数据库路径
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.userDbPath = [self dataFilePath];
    
    
    [self createUserTable];
    
    return YES;
}


/**创建数据库  **/
-(void)createUserTable
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.userDbPath];
    
    NSLog(@"%@",myDelegate.userDbPath);
    
    if (![fileManager fileExistsAtPath:myDelegate.userDbPath])
    {
        NSLog(@"还未创建数据库，现在正在创建数据库");
        
        if ([db open])
        {
            [db executeUpdate:@"create table if not exists UserList (name text, age text, id text)"];
            [db close];
        }else
        {
            NSLog(@"database open error");
        }
    }else
    {
        NSLog(@"FMDatabase:---------%@",db);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//应用程序的沙盒路径
- (NSString *) dataFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    return [document stringByAppendingPathComponent:@"UserData12.sqlite"];
}

@end
