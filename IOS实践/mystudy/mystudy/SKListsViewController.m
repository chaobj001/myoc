//
//  SKListsViewController.m
//  mystudy
//
//  Created by 王超 on 15/4/14.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "SKListsViewController.h"

@interface SKListsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_lists;
}

@end

@implementation SKListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self initTableView];
}

- (void)loadData
{
    NSArray *_lists = @[@"IOS概览", @"无线循环图片浏览器"];
}

- (void)initTableView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}



#pragma mark tableView 协议实现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString const cellIdentifier  = @"cellIdentifier";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

@end
