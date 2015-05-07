//
//  BNRDetailViewController.h
//  Homepwner_UITableView
//
//  Created by 王超 on 15-1-30.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//前置声明
@class BNRItem;

@interface BNRDetailViewController : UIViewController

//
@property (nonatomic, strong) BNRItem *item;
- (IBAction)changeDate:(id)sender;

@end
