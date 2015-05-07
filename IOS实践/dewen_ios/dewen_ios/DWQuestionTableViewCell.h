//
//  SKQuestionTableViewCell.h
//  dewen_ios
//
//  Created by 王超 on 15/4/20.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DWQuestion;

@interface DWQuestionTableViewCell : UITableViewCell

#pragma mark 问题对象
@property (nonatomic, strong) DWQuestion *question;

#pragma mark 单元格高度
@property (nonatomic, assign) CGFloat height;

@end
