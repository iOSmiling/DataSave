//
//  KeyChainViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/15.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "KeyChainViewController.h"
#import "Masonry.h"
#import "XKLKeyChain.h"

@interface KeyChainViewController ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *ageTextField;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *modifyButton;

@end

@implementation KeyChainViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"KeyChain";
    
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

    if ((NSMutableDictionary *)[XKLKeyChain load:KEY_USERNAME_PASSWORD])
    {
         NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[XKLKeyChain load:KEY_USERNAME_PASSWORD];
        
        self.nameTextField.text = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
        self.ageTextField.text = [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
    }else
    {
         self.modifyButton.hidden = YES;
    
    }
    
    
    

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

//Notification的监听之类的事
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEnd)];
    [self.view addGestureRecognizer:tap];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Delegate

#pragma mark event response

- (void) clickEnd
{
    [self.view endEditing:YES];
}

-(void)saveEvent:(UIButton*)sender
{
    if(self.nameTextField.text.length != 0 ||self.ageTextField.text.length != 0)
    {
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:self.nameTextField.text forKey:KEY_USERNAME];
        [usernamepasswordKVPairs setObject:self.ageTextField.text forKey:KEY_PASSWORD];
        [XKLKeyChain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
    
    }else
    {
    
    }
}

-(void)modifyEvent:(UIButton*)sender
{
    [XKLKeyChain delete:KEY_USERNAME_PASSWORD];
    
    self.nameTextField.text = nil;
    self.ageTextField.text = nil;

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



@end
