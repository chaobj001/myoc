//
//  SKQuestion.h
//  dewen_ios
//
//  Created by 王超 on 15/4/19.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DWUser;

@interface DWQuestion : NSObject

@property (nonatomic) NSInteger qid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) NSInteger votes;
@property (nonatomic) NSInteger answers;
@property (nonatomic) NSInteger comments;
@property (nonatomic) NSUInteger created;
@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) NSString *createdStr;
@property (nonatomic, strong) DWUser *creator;

- (void)loadClearReadLoadBody:(void(^)(NSString *resultBody, DWQuestion *question))completionBlock;

@end
