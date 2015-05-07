//
//  BNRImageStore.h
//  Homepwner_UITableView
//
//  Created by 王超 on 15-2-1.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+ (instancetype)shareStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;




@end
