//  SKQuestionsViewController.m
//  dewen_ios
//
//  Created by 王超 on 15/4/19.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWMainViewController.h"
#import "DWItemsViewController.h"
#import "DWQuestionStore.h"
#import "DWQuestion.h"
#import "DWQuestionTableViewCell.h"
#import "DWDetailViewController.h"

@interface DWItemsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DWItemsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"问题";
        self.view.autoresizingMask = YES;

        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(movePanelRight)];
        
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(movePanelLeft)];
        searchBarButton.imageInsets = UIEdgeInsetsZero;

        UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
        self.navigationItem.rightBarButtonItems = @[searchBarButton, refreshBarButton];
    }
    return self;
}

- (void)movePanelRight {
    //NSLog(@"%@", self.navigationController.parentViewController);
    [(DWMainViewController *)self.parentViewController.parentViewController movePanelRight];
    
}

- (void)movePanelLeft {
    //NSLog(@"%@", self.navigationController.parentViewController);
    [(DWMainViewController *)self.parentViewController.parentViewController movePanelLeft];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取数据
    __weak DWItemsViewController *weakSelf = self;
    [[DWQuestionStore sharedStore] loadQuestions:^(NSArray *result, BOOL success) {
        DWItemsViewController *innerSelf = weakSelf;
        if (success) {
            innerSelf.items = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [innerSelf.tableView reloadData];
            });
        }
    }];
    
    [self initTableView];
}

- (void)initTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
}

#pragma mark tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"qstCellIdentifier";
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
     */
    DWQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DWQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    DWQuestion *item = self.items[indexPath.row];
    cell.question = item;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // todo 以后调整为从逻辑缓存层获取
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DWQuestion *item = self.items[indexPath.row];
    DWQuestionTableViewCell *cell = [[DWQuestionTableViewCell alloc] init];
    cell.question = item;
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DWDetailViewController *qstDetailController = [[DWDetailViewController alloc] init];
    //隐藏tab bar
    qstDetailController.hidesBottomBarWhenPushed = YES;
    qstDetailController.question = self.items[indexPath.row];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back"
//                                                                 style:UIBarButtonItemStylePlain
//                                                                target:nil
//                                                                action:nil];
    
    //取消tableView选中效果
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    [self.navigationItem setBackBarButtonItem:item];
    [self.navigationController pushViewController:qstDetailController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
