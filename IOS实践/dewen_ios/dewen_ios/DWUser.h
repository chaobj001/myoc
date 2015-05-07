//
//  DWUser.h
//  dewen_ios
//
//  Created by 王超 on 15/5/5.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWUser : NSObject

@property (nonatomic) NSInteger pub_uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic) NSInteger points;


@end
