//
//  CoreDataAddViewController.m
//  数据存储
//
//  Created by 薛坤龙 on 15/10/17.
//  Copyright © 2015年 薛坤龙. All rights reserved.
//

#import "CoreDataAddViewController.h"
#import "Masonry.h"
#import "CoreDataManager.h"
#import "UserCoreList.h"

@interface CoreDataAddViewController ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *ageTextField;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *modifyButton;

@property (nonatomic, strong) CoreDataManager *manager;

@end

@implementation CoreDataAddViewController


#pragma mark life cycle

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
    //读取数据
    
    if (_type ==ADD)
    {
         self.modifyButton.hidden = YES;
        
    }else
    {
       
        
        //  user 对象可以直接传递过来
        
        /*
        self.nameTextField.text = _user.name;
        self.ageTextField.text = _user.age;
        */
        
        
        //  练习一下 coredata查询 利用user对象的id来查找user
        _arrayIndex = [_user.aid integerValue];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *user = [NSEntityDescription entityForName:@"UserCoreList" inManagedObjectContext:_manager.managedObjContext];
        [request setEntity:user];
        request.predicate = [NSPredicate predicateWithFormat:@"aid like[cd] %@",_user.aid];
        NSMutableArray *sortDescriptors = [NSMutableArray array];
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"aid" ascending:YES] ];
        [request setSortDescriptors:sortDescriptors];
        [request setReturnsObjectsAsFaults:NO];
        [request setPropertiesToFetch:[NSArray arrayWithObjects:@"name", @"aid", @"age", nil]];
        NSError *error = nil;
        NSArray *fetchedItems = [_manager.managedObjContext executeFetchRequest:request error:&error];
        if (fetchedItems == nil)
        {
            // an error occurred
            NSLog(@"fetch request resulted in an error %@, %@", error, [error userInfo]);
        }else
        {
            NSLog(@"fetchedItems=%@",fetchedItems);
            for ( UserCoreList*user in fetchedItems)
            {
                NSLog(@"user.name=%@",user.name);
                self.nameTextField.text = user.name;
                self.ageTextField.text = user.age;
                _user = user;
            }
        }
    }
    
}



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

-(void)saveEvent:(UIButton*)sender
{
    //保存数据
    if(self.nameTextField.text.length != 0 ||self.ageTextField.text.length != 0)
    {
        
        if (_type == ADD)
         {
           //插入数据
           _user = [NSEntityDescription insertNewObjectForEntityForName:@"UserCoreList" inManagedObjectContext:_manager.managedObjContext];
           [_user setName:self.nameTextField.text];
           [_user setAge:self.ageTextField.text];
           [_user setAid:[NSString stringWithFormat:@"%ld",self.arrayIndex]];
           
           NSError *error = nil;
           
           //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
           BOOL isSaveSuccess = [_manager.managedObjContext save:&error];
           if (!isSaveSuccess)
           {
               NSLog(@"Error: %@,%@",error,[error userInfo]);
           }else
           {
               NSLog(@"Save successFull");
               
               self.saveButton.hidden = YES;
           }
           
         }else
         {
             //修改数据
             [_user setName:self.nameTextField.text];
             [_user setAge:self.ageTextField.text];
             [_user setAid:[NSString stringWithFormat:@"%ld",self.arrayIndex]];
             NSError *error = nil;
             
             //    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
             BOOL isSaveSuccess = [_manager.managedObjContext save:&error];
             if (!isSaveSuccess)
             {
                 NSLog(@"Error: %@,%@",error,[error userInfo]);
             }else
             {
                 NSLog(@"Change successFull");
                  self.saveButton.hidden = YES;
             }
         }
    }else
    {

    }
}

-(void)modifyEvent:(UIButton*)sender
{
    //删除数据
    [_manager.managedObjContext deleteObject:_user];
    
    NSError *error = nil;
    
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [_manager.managedObjContext save:&error];
    
    if (!isSaveSuccess)
    {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
        
    }else
    {
        NSLog(@"del successFull");
        
        self.nameTextField.text = nil;
        self.ageTextField.text = nil;
    }
}

- (void) clickEnd
{
    [self.view endEditing:YES];
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
