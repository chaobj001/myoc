//
//  LeftPanelViewController.m
//  dewen_ios
//
//  Created by 王超 on 15/4/29.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWLeftPanelViewController.h"
#import "DWMainViewController.h"

@interface DWLeftPanelViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menu;

@end

@implementation DWLeftPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_menu = @[@"首页", @"浏览", @"话题", @"最近阅读", @"设置"];
    
    _menu = @[
              @[@{@"class":@"DWItemsViewController", @"title":@"首页"}, @{@"class":@"DWItemsViewController", @"title":@"热门问题"}, @{@"class":@"DWTopicsViewController", @"title":@"话题"}],
              @[@{@"class":@"DWReadViewController", @"title":@"最近看过"}],
              @[@{@"class":@"DWSettingViewController", @"title":@"设置"}]
    ];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    
    //解决状态栏干扰
//    UIView *barBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    barBackground.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
//    barBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:barBackground];
}

- (void)initTableView
{
    //CGRect screen = [[UIScreen mainScreen] bounds];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                              style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _menu[indexPath.section][indexPath.row][@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *obj;
    NSString *className = _menu[indexPath.section][indexPath.row][@"class"];
    Class someClass = NSClassFromString(className);
    obj = [[someClass alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:obj];
    
    [(DWMainViewController *)self.parentViewController setCenterViewController:navController];
    [(DWMainViewController *)self.parentViewController moveLeftPanelToOriginalPositon];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
