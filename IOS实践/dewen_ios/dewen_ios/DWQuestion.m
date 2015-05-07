//
//  SKQuestion.m
//  dewen_ios
//
//  Created by 王超 on 15/4/19.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWQuestion.h"

@implementation DWQuestion

- (NSString *)createdStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_created];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter1 stringFromDate:date];
}


- (void)loadClearReadLoadBody:(void(^)(NSString *resultBody, DWQuestion *question))completionBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"http://dewen.sk80.com/q/%li",self.qid];
    //NSString *urlStr = [NSString stringWithFormat:@"http://127.0.0.1:3000/q/%li",self.qid];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    //2.创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话(使用全局会话)病启动任务
    NSURLSession *session = [NSURLSession sharedSession];
    //从会话创建任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *e = nil;
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            
            if (!jsonArray) {
                NSLog(@"error parsing json: %@", e);
            } else {
                
                completionBlock(jsonArray[@"html"], self);
            }
        }
    }];
    
    [dataTask resume];//恢复线程，启动任务

};


@end
