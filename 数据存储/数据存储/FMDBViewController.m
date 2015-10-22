//
//  FMDBViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "FMDBViewController.h"
#import "Masonry.h"
#import "FMDBAddViewController.h"
#import "FMDB.h"
#import "User.h"


@interface FMDBViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UITableView *dataTableView;
@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation FMDBViewController


#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"FMDB";
    
    [self loadNaviBar];
    [self.view addSubview:self.dataTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if (self.dataArray.count!=0)
    {
        [self.dataArray removeAllObjects];
    }
    
    //打开数据库 读取全部数据
    NSString *dicAddress = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbpath = [dicAddress stringByAppendingPathComponent:@"UserData12.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open])
    {
        NSString * sql =@"select * from UserList";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            
            User *user = [[User alloc] init];
            int userId = [rs intForColumn:@"id"];
            NSString * name = [rs stringForColumn:@"name"];
            NSString * age = [rs stringForColumn:@"age"];
            user.name = name;
            user.age = age;
            user.arrayId = [NSString stringWithFormat:@"%d",userId];
            NSLog(@"user id = %d, name = %@, age = %@", userId, name, age);
            [self.dataArray addObject:user];
        }
        
        [db close];
        
    }
    
    [self.dataTableView reloadData];

}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(weakSelf.view);
         make.width.equalTo(weakSelf.view.mas_width);
         
     }];
}

#pragma mark Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = self.dataArray.count;
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier =  @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    User *user = [[User alloc] init];
    user = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.age;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   //把选择的项的id传过去， 下个界面根据id查找并修改
    FMDBAddViewController *fMDBAddViewController = [[FMDBAddViewController alloc] init];
    fMDBAddViewController.type = CHANGE;
    
    //
    User *user = [[User alloc] init];
    user = [self.dataArray objectAtIndex:indexPath.row];
    fMDBAddViewController.arrayIndex = [user.arrayId integerValue];
    [self.navigationController pushViewController:fMDBAddViewController animated:YES];
    
}

#pragma mark event response
- (void) loadNaviBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd:)];
}

- (void) clickAdd:(id)sender
{
    FMDBAddViewController *fMDBAddViewController = [[FMDBAddViewController alloc] init];
    fMDBAddViewController.type = ADD;
    fMDBAddViewController.arrayIndex = [self.dataArray count];
    [self.navigationController pushViewController:fMDBAddViewController animated:YES];
    
}

#pragma mark getters and setters

-(UITableView *)dataTableView
{
    if (!_dataTableView)
    {
        _dataTableView = [[UITableView alloc] init];
        _dataTableView.dataSource = self;
        _dataTableView.delegate = self;
    }
    return _dataTableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


@end
