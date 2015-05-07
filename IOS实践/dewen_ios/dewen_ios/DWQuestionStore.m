//
//  SKQuestionStore.m
//  dewen_ios
//
//  Created by 王超 on 15/4/19.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWQuestionStore.h"
#import "DWQuestion.h"
#import "DWUtil.h"
#import "DWUser.h"
//#import <AFNetworking/AFNetworking.h>
//#import <SBJson/SBJson4.h>

@interface DWQuestionStore ()

@property (nonatomic) NSMutableArray *questions;

@end


@implementation DWQuestionStore

+ (instancetype)sharedStore
{
    static DWQuestionStore *sharedStore = nil;
    //线程安全单例，避免多核CPU创建多个线程
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例模式" reason:@"使用 [SKQuestionStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        if (!_questions) {
            _questions = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)loadQuestions:(void(^)(NSArray *results, BOOL success))completionBlock
{
    //1.创建url
    NSString *urlStr = [NSString stringWithFormat:@"http://dewen.sk80.com/questions/%@/%@", @"all", @"newest"];
    //NSString *urlStr = [NSString stringWithFormat:@"http://127.0.0.1:3000/questions/%@/%@", @"all", @"newest"];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    //2.创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话(使用全局会话)病启动任务
    NSURLSession *session = [NSURLSession sharedSession];
    //从会话创建任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    //NSLog(@"%@", response);
                                                    //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    //NSLog(@"JSON:%@", json);
                                                    if (!error) {
                                                        NSError *e = nil;
                                                        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
                                                        if (!jsonArray) {
                                                            NSLog(@"error parsing json: %@", e);
                                                        } else {
                                                            
                                                            NSMutableArray *result = [[NSMutableArray alloc] init];
                                                            [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                //NSLog(@"%lu", idx);
                                                                //NSLog(@"%@", obj);
                                                                DWQuestion *qst = [[DWQuestion alloc] init];
                                                                qst.qid = [obj[@"qid"] integerValue];
                                                                qst.title = obj[@"title"];
                                                                qst.content = obj[@"content"];
                                                                qst.votes = [obj[@"votes"] integerValue];
                                                                qst.answers = [obj[@"answers"] integerValue];
                                                                qst.comments = [obj[@"comments"] integerValue];
                                                                qst.created = [obj[@"created"] integerValue];
                                                                
                                                                //话题遍历
                                                                qst.topics = [[NSMutableArray alloc] init];
                                                                for (NSDictionary *topic in obj[@"topics"]) {
                                                                    //[qst.topics addObject:[topic objectForKey:@"name"]];
                                                                    [qst.topics addObject:[NSString stringWithString:topic[@"name"]]];
                                                                    //NSLog(@"%@", topic[@"name"]);
                                                                }
                                                                //NSLog(@"%@", qst.topics);
                                                                
                                                                //creator
                                                                NSDictionary *creator = obj[@"creator"];
                                                                DWUser *user = [[DWUser alloc] init];
                                                                user.pub_uid = [creator[@"pub_uid"] integerValue];
                                                                user.name = creator[@"name"];
                                                                user.points = [creator[@"points"] integerValue];
                                                                user.avatar = creator[@"avator"];
                                                                
                                                                qst.creator = user;
                                                                
                                                            
                                                                
                                                                
                                                                
                                                                
                                                                [result addObject:qst];
                                                            }];
                                                            _questions = result;
                                                            
                                                            //for (id obj in _questions) {
                                                            //    NSLog(@"%lu", [obj created]);
                                                            //}
                                                            
                                                            //NSLog(@"%@", _questions);
                                                            
                                                            completionBlock(result, YES);
                                                            //NSLog(@"%@", jsonArray);
                                                        }
                                                    } else {
                                                        completionBlock(nil, NO);
                                                        NSLog(@"error: %@", error.localizedDescription);
                                                    }

                                                    
                                                    
                                                    /*if (!error) {
                                                        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"%@", dataStr);
                                                    } else {
                                                        NSLog(@"error: %@", error.localizedDescription);
                                                    }*/
                                                }];
    [dataTask resume];//恢复线程，启动任务

}



@end
