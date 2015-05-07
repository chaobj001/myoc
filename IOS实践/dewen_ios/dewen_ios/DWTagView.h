//
//  SKTagView.h
//  dewen_ios
//
//  Created by 王超 on 15/4/20.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWTagView : UIView

@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithText:(NSString *)text;

@end

@interface SKTagList : UIView

- (void)setTags:(NSArray *)array;
- (void)display;

@end
