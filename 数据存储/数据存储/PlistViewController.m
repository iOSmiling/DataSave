//
//  PlistViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "PlistViewController.h"
#import "PlistAddViewController.h"
#import "Masonry.h"

@interface PlistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *dataTableView;
@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation PlistViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"plist";
    [self loadNaviBar];
    
    [self.view addSubview:self.dataTableView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /**
    //读取工程里面的plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"用户：%@",[dic objectForKey:@"user"]);
    NSLog(@"年龄：%@",[dic objectForKey:@"age"]);
    NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"users"]];
    NSLog(@"数组：%@",array);
    **/
    
    //获取沙盒里面的plist文件
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"user3.plist"];
    NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [self.dataArray removeAllObjects];
    for (int i =0; i<[applist allValues].count; i++)
    {
        NSString *key = [NSString stringWithFormat:@"name%d",i];
        [self.dataArray addObject:[applist objectForKey:key]];
        
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

#pragma mark TableViewDelegate

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     PlistAddViewController *plistAddViewController = [[PlistAddViewController alloc] init];
     plistAddViewController.type = CHANGE;
     plistAddViewController.arrayIndex = indexPath.row;
    [self.navigationController pushViewController:plistAddViewController animated:YES];
    
}

#pragma mark event response

- (void) loadNaviBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd:)];
}

- (void) clickAdd:(id)sender
{
    PlistAddViewController *plistAddViewController = [[PlistAddViewController alloc] init];
    plistAddViewController.type = ADD;
    plistAddViewController.arrayIndex = [self.dataArray count];
    [self.navigationController pushViewController:plistAddViewController animated:YES];
    
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
