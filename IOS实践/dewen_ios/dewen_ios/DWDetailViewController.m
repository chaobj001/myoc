//
//  SKQuestionDetailViewController.m
//  dewen_ios
//
//  Created by 王超 on 15/4/21.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWDetailViewController.h"
#import "DWQuestion.h"

@interface DWDetailViewController () <UIWebViewDelegate>
{
    //UIWebView *_webView;
    UIToolbar *_toolBar;
    UIBarButtonItem *_barButtonPrev;
    UIBarButtonItem *_barButtonNext;
    NSMutableString *_string;
}

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DWDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld个答案", (long)self.question.answers];

    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self setNeedsStatusBarAppearanceUpdate];
    
    [self layoutUI];
    
    [self request];
}

#pragma mark - 私有方法
#pragma mark 界面布局
- (void)layoutUI
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    //添加浏览器控件
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    _webView.dataDetectorTypes = UIDataDetectorTypeLink;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    //_webView.scrollView.alwaysBounceHorizontal = NO;
    [self.view addSubview:_webView];
    
    
    
    //添加下方工具栏
    
    //Query
    //NSString *detailUrl = [NSString stringWithFormat:@"http://www.dewen.io/q/%d", self.question.qid];
    //[self request:detailUrl];
    
    //NSURL *url=[[NSBundle mainBundle] URLForResource:@"detail.html" withExtension:nil];
    //NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //[_webView loadRequest:request];
}


#pragma mark 浏览器请求
- (void)request
{
//    //创建url
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    //创建请求
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    //加载页面
//    [_webView loadRequest:request];
    
    
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
    
    
    NSMutableString *string = [[NSMutableString alloc] initWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
    
//    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"]
//                                                         encoding:NSUTF8StringEncoding
//                                                            error:nil] mutableCopy];
    [string replaceOccurrencesOfString:@"{{{title}}}" withString:_question.title options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"{{{content}}}" withString:_question.content options:0 range:NSMakeRange(0, string.length)];
    //NSLog(@"%@", string);
    
    _string = string;
    [_webView loadHTMLString:string baseURL:nil];

    __weak DWDetailViewController *weakSelf = self;
    [_question loadClearReadLoadBody:^(NSString *resultBody, DWQuestion *question)
     {
         if (question != _question) return;
         NSString *clearReadDocument = [string stringByReplacingOccurrencesOfString:@"Loading..." withString:resultBody options:0 range:NSMakeRange(0, _string.length)];
         [weakSelf.webView loadHTMLString:clearReadDocument baseURL:nil];
     }];
    
    
    //NSLog(@"AASDASD");
}

#pragma mark - WebView 代理方法
#pragma mark 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示网络请求加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

#pragma mark 加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏网络请求图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

#pragma mark 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error detail:%@", error.localizedDescription);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示"
                                                    message:@"网络连接发生错误"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
