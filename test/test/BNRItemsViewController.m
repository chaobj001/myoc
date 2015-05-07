//
//  BNRItemsViewController.m
//  Homepwner_UITableView
//
//  Created by 王超 on 15-1-27.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//  使用XIB创建局部视图
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemsViewController ()

//声明插座变量
@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    //调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        //设置navigationItem属性
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"首页";
        
        //创建新的UIBarButtonItem对象
        //将其目标对象设置为当前对象，将其动作方法设置为addNewItem
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        //为UINavigationItem对象的rightBarButtonItem属性赋值
        //指向新创建的UIBarButtonItem对象
        navItem.rightBarButtonItem = bbi;
        
        UIBarButtonItem *bbiEdit = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(toggleEditingMode:)];
        navItem.leftBarButtonItem = bbiEdit;
        //navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建UITableViewCell对象,风格使用默认的UITableViewCellDefault
    /*
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"UITableViewCell"];*/
    //创建或重用UITableViewCell对象
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
//                                                            forIndexPath:indexPath];
//
    //获取BNRItemCell对象，返回的可能是现有对象，也可能是新创建的对象
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell"
                                                        forIndexPath:indexPath];
    
    //获取allItems的第n个BNRItem对象
    //然后将该BNRItem对象的描述信息赋给UITableViewCell对象的textLable
    //这里的n时该UITableViewCell对象所对应的表格索引
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    //根据BNRItem对象设置BNRItemCell对象
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    

    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //向表视图注册应该重复使用的UITbaleViewCell对象
//    [self.tableView registerClass:[UITableViewCell class]
//           forCellReuseIdentifier:@"UITableViewCell"];
    
    //创建UINib对象，该对象代表包含BNRItemCell的NIB文件
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    //通过UIBib对象注册显影的NIB文件
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BNRItemCell"];
    
    
    //添加表头
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}

//添加一行新数据
- (IBAction)addNewItem:(id)sender
{
    //创建新的BNRItem对象并将其加入BNRItemStore对象
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    //获取新创建的对象在allItems数组中的索引
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    
    //创建NSIndexPath对象，代表的位置是L第一个表格段，最后一个表格行
    //NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    //将新行插入UITableView对象
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
}

//表格编辑模式切换
- (IBAction)toggleEditingMode:(id)sender
{
    
    //如果当前的视图控制对象已经在编辑模式
    if (self.isEditing) {
        //修改安秀文字，提示用户当前的表格状态
        //[sender setTitle:@"编辑" forState:UIControlStateNormal];
        [sender setTitle:@"编辑"];
        
        //关闭编辑模式
        [self setEditing:NO animated:YES];
    } else {
        //修改按钮文字，提示用户当前的表格状态
        //[sender setTitle:@"完成" forState:UIControlStateNormal];
        [sender setTitle:@"完成"];
        
        //开始编辑模式
        [self setEditing:YES animated:YES];
    }

    
}

- (UIView *)headerView
{
    //如果没有载入headerView
    if (!_headerView) {
        //载入HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
}

//提交表格编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果UITableView对象请求确认的是删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore]removeItem:item];
        
        //还要删除表格视图中的相应表格行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItenAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}
//更换删除提示
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//表行移动限制
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row < [[[BNRItemStore sharedStore] allItems] count]) {
        return proposedDestinationIndexPath;
    } else {
        return sourceIndexPath;
    }
}
//表行编辑限制
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [[[BNRItemStore sharedStore] allItems] count]) {
        return YES;
    } else {
        return NO;
    }
}
//在表选择之前
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [[[BNRItemStore sharedStore] allItems] count]) {
        return indexPath;
    } else {
        return nil;
    }
}

//在选中表行之后操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
        
        /**
         * 在BNRDetaiViewCongtroller对象收到viewWillApper:消息前
         * 将其item属性设置为相应的BNRItem对象
         */
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *selectedItem = items[indexPath.row];
        //将选中的BNRItem对象赋给DetailViewController对象
        detailViewController.item = selectedItem;
        
        //将新创建的BNRDetailViewController对象压入UINavigationController对象的栈
        [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}





@end
