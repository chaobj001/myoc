//
//  BNRChangeDateViewController.m
//  Homepwner_UITableView
//
//  Created by 王超 on 15-1-30.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRChangeDateViewController.h"
#import "BNRItem.h"

@interface BNRChangeDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRChangeDateViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"修改时间";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(dateChanged:)];
        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

-(void)dateChanged:(id)sender
{
    BNRItem *item = self.item;
    [item changeDate:self.datePicker.date];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
