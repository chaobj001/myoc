//
//  QuizViewController.m
//  quiz01
//
//  Created by 王超 on 15-1-23.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

//創建模型對象 聲明一個整型變量和兩個數組對象
@property (nonatomic) int currentQuestionIndex;//跟蹤用戶正在回答的問題

@property (nonatomic, copy) NSArray *questions;//存儲一系列問題
@property (nonatomic, copy) NSArray *answers;//存儲答案

//聲明插座變量，它可以指向一個UILabel對象
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@end

@implementation QuizViewController

//QuizViewController對象創建完畢之後會收到消息 initWithNibName:bundle:
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    //調用父類實現的初始化方法
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        //創建兩個數組對象, 存儲所需的問題及答案
        //同時， 將questions和answers分別指向問題數組和答案數組
        
        self.questions = @[@"oc語言全稱是什麼?",
                           @"7 + 7 等於幾？",
                           @"北京地鐵票價起步多少錢?"];
        
        self.answers = @[@"objective-c",
                         @"14",
                         @"3元"];
    }
    
    //返回對象的地址
    return self;
    
}

//聲明兩個動作方法
- (IBAction)showQuestion:(id)sender
{
    //進入下一個問題
    self.currentQuestionIndex++;
    //是否已經回答完所有問題
    if (self.currentQuestionIndex == [self.questions count]) {
        //回到第一個問題
        self.currentQuestionIndex = 0;
    }
    //根據正在回答的問題序號從數組中取出問題字符串
    NSString *question = self.questions[self.currentQuestionIndex];
    //將問題字符串顯示在標籤上
    self.questionLabel.text = question;
    //重置答案字符串
    self.answerLabel.text = @"???";
    
}

- (IBAction)showAnswer:(id)sender
{
    //當前問題的答案是什麼？
    NSString *answer = self.answers[self.currentQuestionIndex];
    //在大難標籤上顯示響應的答案
    self.answerLabel.text = answer;
    
}
@end
