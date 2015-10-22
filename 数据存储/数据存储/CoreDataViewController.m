//
//  CoreDataViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/17.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "CoreDataViewController.h"
#import "CoreDataAddViewController.h"
#import "CoreDataManager.h"
#import "UserCoreList.h"
#import "Masonry.h"

@interface CoreDataViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *dataTableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic, strong) CoreDataManager *manager;

@end

@implementation CoreDataViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _manager = [CoreDataManager sharedCoreDataManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CoreData";
    
    [self loadNaviBar];
    [self.view addSubview:self.dataTableView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //读取全部数据
    
    //    创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserCoreList" inManagedObjectContext:_manager.managedObjContext];
    //    设置请求实体
    [request setEntity:entity];
    
    //    指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"aid" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //    执行获取数据请求，返回数组
    NSArray *fetchResult = [_manager.managedObjContext executeFetchRequest:request error:&error];
    if (!fetchResult)
    {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:fetchResult];
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
//    UserCoreList *user = [[UserCoreList alloc] init];
    UserCoreList *user = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.age;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UserCoreList *user = [self.dataArray objectAtIndex:indexPath.row];
    
    CoreDataAddViewController *set = [[CoreDataAddViewController alloc] init];
    set.title = @"修改或者删除";
    set.type = CHANGE;
    set.user = user;
    [self.navigationController pushViewController:set animated:YES];
    
    

}

#pragma mark event response

- (void) loadNaviBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd:)];
}

- (void) clickAdd:(id)sender
{
    CoreDataAddViewController *coreDataAddViewController = [[CoreDataAddViewController alloc] init];
    coreDataAddViewController.arrayIndex = [self.dataArray count];
    [self.navigationController pushViewController:coreDataAddViewController animated:YES];

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
