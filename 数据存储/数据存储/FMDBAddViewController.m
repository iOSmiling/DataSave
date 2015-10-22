//
//  FMDBAddViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/16.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "FMDBAddViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "FMDB.h"

@interface FMDBAddViewController ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *ageTextField;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *modifyButton;

@end

@implementation FMDBAddViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.ageLabel];
    [self.view addSubview:self.ageTextField];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.modifyButton];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (_type == CHANGE)
    {
        //根据上个界面传递过来的id 进行数据库查询
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.userDbPath];
        [db open];
        
        //主意数据库中id的数据类型。 和你要查询的时候的数据类型要一致
        NSString *nameOut = [db stringForQuery:@"SELECT name FROM UserList WHERE id = ?",[NSString stringWithFormat:@"%ld",(long)self.arrayIndex]];
        NSString *ageOut=  [db stringForQuery:@"SELECT age FROM UserList WHERE id = ?",[NSString stringWithFormat:@"%ld",(long)self.arrayIndex]];
        
        self.nameTextField.text = nameOut;
        self.ageTextField.text = ageOut;
        
        [db close];
        
    }else
    {
        self.modifyButton.hidden = YES;
    
    }
    
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
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
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
    }];
    
    [self.ageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.nameTextField.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf.ageLabel.mas_right).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
        
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.ageLabel.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
        
    }];
    
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.ageTextField.mas_bottom);
        make.left.equalTo(weakSelf.saveButton.mas_right).with.offset(20);
        make.width.offset(100);
        make.height.offset(46);
        
    }];

    
}


#pragma mark Delegate


#pragma mark event response

-(void)saveEvent:(UIButton*)sender
{
    if(self.nameTextField.text.length != 0 ||self.ageTextField.text.length != 0)
    {
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.userDbPath];
        [db open];
        
        NSString *aid = [NSString stringWithFormat:@"%ld",(long)_arrayIndex];
        
        BOOL res;
        
        if (_type == ADD)
        {
            res = [db executeUpdate:@"INSERT INTO UserList (name, age, id) VALUES (?, ?, ?)",self.nameTextField.text, self.ageTextField.text, aid];
            if (res == NO) {
                NSLog(@"数据插入失败");
            }else{
                NSLog(@"数据插入成功");
            }
            
            
        }else
        {
            res = [db executeUpdate:@"UPDATE UserList SET name = ?, age = ? WHERE id = ?",self.nameTextField.text,self.ageTextField.text,aid];
            if (res == NO) {
                NSLog(@"数据更新失败");
            }else{
                NSLog(@"数据更新成功");
            }
        
        }
        
        [db close];
    
    }else
    {
    
        
    }

}

-(void)modifyEvent:(UIButton*)sender
{
    //删除
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.userDbPath];
    [db open];
    
    NSString *aid = [NSString stringWithFormat:@"%ld",(long)_arrayIndex];
    
    BOOL res;
    
    res = [db executeUpdate:@"DELETE FROM UserList WHERE id = ?",aid];
    
    if (res == NO)
    {
        NSLog(@"数据删除失败");
    }else
    {
        NSLog(@"数据删除成功");
        self.nameTextField.text = nil;
        self.ageTextField.text = nil;
    }
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

-(UILabel *)ageLabel
{
    if (!_ageLabel)
    {
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.text = @"年龄";
    }
    return _ageLabel;
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

-(UITextField *)ageTextField
{
    if (!_ageTextField)
    {
        _ageTextField = [[UITextField alloc] init];
        _ageTextField.borderStyle=UITextBorderStyleRoundedRect;
    }
    return _ageTextField;
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

-(UIButton *)modifyButton
{
    if (!_modifyButton)
    {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_modifyButton setTitle:@"删除" forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
