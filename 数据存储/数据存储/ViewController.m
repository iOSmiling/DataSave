//
//  ViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "ViewController.h"
#import "NSUserDefaultViewController.h"
#import "Masonry.h"
#import "KeyChainViewController.h"
#import "PlistViewController.h"
#import "FMDBViewController.h"
#import "CoreDataViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *saveTableView;
@property (nonatomic,copy) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = @"数据存储";

    [self.view addSubview:self.saveTableView];
    [self.dataArray addObject:@"NSUserDefault"];
    [self.dataArray addObject:@"keychain"];
    [self.dataArray addObject:@"plist"];
    [self.dataArray addObject:@"FMDB"];
    [self.dataArray addObject:@"CoreData"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.saveTableView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(weakSelf.view);
         make.width.equalTo(weakSelf.view.mas_width);
         
     }];

}

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
    if (indexPath.row ==0)
    {
         NSUserDefaultViewController *nSUserDefaultViewController = [[NSUserDefaultViewController alloc] init];
        [self.navigationController pushViewController:nSUserDefaultViewController animated:YES];
    }else if (indexPath.row ==1)
    {
        KeyChainViewController *keyChainViewController = [[KeyChainViewController alloc] init];
        [self.navigationController pushViewController:keyChainViewController animated:YES];
    }else if (indexPath.row == 2)
    {
        PlistViewController *plistViewController = [[PlistViewController alloc] init];
       [self.navigationController pushViewController:plistViewController animated:YES];
    }else if (indexPath.row ==3)
    {
        FMDBViewController * fMDBViewController = [[FMDBViewController alloc] init];
        [self.navigationController pushViewController:fMDBViewController animated:YES];
    }else if (indexPath.row ==4)
    {
        CoreDataViewController *coreDataViewController = [[CoreDataViewController alloc] init];
        [self.navigationController pushViewController:coreDataViewController animated:YES];
    }
}

-(UITableView *)saveTableView
{
    if (!_saveTableView)
    {
        _saveTableView = [[UITableView alloc] init];
        _saveTableView.dataSource = self;
        _saveTableView.delegate = self;
    }
    return _saveTableView;
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
