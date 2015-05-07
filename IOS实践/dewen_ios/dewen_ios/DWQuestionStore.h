//
//  SKQuestionStore.h
//  dewen_ios
//
//  Created by 王超 on 15/4/19.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWQuestion;

@interface DWQuestionStore : NSObject

@property (nonatomic, readonly) NSArray *allQuestions;

+ (instancetype)sharedStore;

- (void)loadQuestions:(void(^)(NSArray *result, BOOL success))completionBlock;

@end
