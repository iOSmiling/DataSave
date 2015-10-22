//
//  PlistAddViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "PlistAddViewController.h"
#import "Masonry.h"

@interface PlistAddViewController ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIButton *saveButton;


@property (nonatomic,copy) NSString *key;

@end

@implementation PlistAddViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title ;
    if (_type == ADD)
    {
        title = @"新增";
    }else
    {
        title = @"修改";
    }
    self.title = title;
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.saveButton];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
     _key =[NSString stringWithFormat:@"name%ld",(long)self.arrayIndex];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"user3.plist"];
    NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    self.nameTextField.text = [applist objectForKey:_key];
    
}

//改变视图位子
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    __weak typeof(self) weakSelf = self;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).with.offset(89);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view.mas_top).with.offset(89);
        make.left.equalTo(weakSelf.nameLabel.mas_right).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
        
    }];

    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
        
    }];
}

//Notification的监听之类的事
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEnd)];
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark Delegate

#pragma mark event response

- (void) clickEnd
{
    [self.view endEditing:YES];
}


-(void)saveEvent:(UIButton*)sender
{
    
    NSLog(@"_key:%@",_key);
    
    //plist文件的操作
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"user3.plist"];
    NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *dictplist = [[NSMutableDictionary alloc ] init];
    [dictplist setDictionary:applist];
    NSLog(@"1:%@",dictplist);
    //设置属性值
    [dictplist setObject:self.nameTextField.text forKey:_key];
    NSLog(@"2:%@",dictplist);
    //写入文件
    [dictplist writeToFile:plistPath atomically:YES];

}

-(void)modifyEvent:(UIButton*)sender
{
    

}

#pragma mark getters and setters

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"名字";
    }
    return _nameLabel;
}

-(UITextField *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    }
    return _nameTextField;
}

-(UIButton *)saveButton
{
    if (!_saveButton)
    {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}



@end
