//
//  BNRItemStore.m
//  Homepwner_UITableView
//
//  Created by 王超 on 15-1-27.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    //判断是否要创建一个sharedStore对象
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

//如果调用[[BNRItemStore alloc] init]， 就提示应该使用[BNRItemStore sharedStore]
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例模式" reason:@"使用 [BNRItemStore sharedStore]" userInfo:nil];
    return nil;
}

//真正的（私有）初始化方法
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //如果之前没有保存过privateItems，就创建一个新的
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

//说明，BNRItemStore.h将allItems声明为只读属性，而BNRItemStore.m又覆盖了allItems的取方法，
//因此编译器不会为allItems生成取方法和实例变量_allItems。
- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
    //BNRItem *item = [BNRItem randomItem];
    BNRItem *item = [[BNRItem alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    
    [[BNRImageStore shareStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItenAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    //得到要移动的对象的指针，以便稍后能将其插入新的位置
    BNRItem *item = self.privateItems[fromIndex];
    
    //将item从allItem数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //根据新的索引位置，将item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
}

//获取相应文件的全路径
- (NSString *)itemArchivePath
{
    //注意第一个参数是NSDocumentDirectory而不是NSDocumentationDirectory
    //通过C函数NSSearchPathForDirectoriesInDomains获取沙盒中某种目录的全路径
    //第一个实参NSSearchPathDirectory类型的常量，负责指定露露的类型，传入NSCachesDirectory可以得到Caches目录的路径
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //从documentDirectories数组获取第一个，也是唯一文档目录路径
    NSString *documentDirectory = [documentDirectories firstObject];
    
    //追加归档固化文件的文件名
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    //通过NSKeyedArchiver类保存BNRItem对象，其为NSCoder子类
    //如果固化成功就返回YES
    return [NSKeyedArchiver archiveRootObject:self.privateItems
                                       toFile:path];
}


@end
