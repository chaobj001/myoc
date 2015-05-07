//
//  DWTopicsViewController.m
//  dewen_ios
//
//  Created by 王超 on 15/5/4.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWTopicsViewController.h"
#import "DWMainViewController.h"

@implementation DWTopicsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"话题";
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(movePanelRight)];
        
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(movePanelLeft)];
        searchBarButton.imageInsets = UIEdgeInsetsZero;
        
        UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
        self.navigationItem.rightBarButtonItems = @[searchBarButton, refreshBarButton];
        
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)movePanelRight {
    //NSLog(@"%@", self.navigationController.parentViewController);
    [(DWMainViewController *)self.parentViewController.parentViewController movePanelRight];
    
}

- (void)movePanelLeft {
    //NSLog(@"%@", self.navigationController.parentViewController);
    [(DWMainViewController *)self.parentViewController.parentViewController movePanelLeft];
    
}

@end
