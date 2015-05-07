//
//  BNRImageStore.m
//  Homepwner_UITableView
//
//  Created by 王超 on 15-2-1.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

//声明一个属性，用于存储照片
@property (nonatomic, strong) NSMutableDictionary *dictionary;
- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation BNRImageStore

+ (instancetype)shareStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

//不允许直接调用init方法
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例模式"
                                   reason:@"Use +[BNRImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

//私有方法初始化
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        //对象首次初始化建议是用_前缀变量
        _dictionary = [[NSMutableDictionary alloc] init];
        
        //注册通知观察者，在内存过低时清理内存
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
    
    //获取保存图片的全路径
    NSString *imagePath = [self imagePathForKey:key];
    
    //从图片提取JPEG格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    //将JPEG格式的数据写入文件
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    //return [self.dictionary objectForKey:key];
    //return self.dictionary[key];
    
    //先尝试通过字典对象获取图片
    UIImage *result = self.dictionary[key];
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        //通过文件创建UIImage对象
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        //如果能够通过文件创建图片，就将其放入缓存
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}


@end
