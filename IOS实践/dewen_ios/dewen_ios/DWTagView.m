//
//  SKTagView.m
//  dewen_ios
//
//  Created by 王超 on 15/4/20.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWTagView.h"

#define CORNER_RADIUS 3.0f
#define LABEL_MARGIN_DEFAULT 5.0f
#define BOTTOM_MARGIN_DEFAULT 5.0f
#define FONT_SIZE_DEFAULT 11.0f
#define HORIZONTAL_PADDING_DEFAULT 5.0f
#define VERTICAL_PADDING_DEFAULT 2.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define TEXT_COLOR [UIColor grayColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define BORDER_WIDTH 1.0f
#define DEFAULT_AUTOMATIC_RESIZE NO


@implementation DWTagView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _label.backgroundColor = BACKGROUND_COLOR;
        _label.textColor = TEXT_COLOR;
        _label.shadowColor = TEXT_SHADOW_COLOR;
        _label.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
        _label.shadowOffset = TEXT_SHADOW_OFFSET;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CORNER_RADIUS;
        self.layer.borderColor = BORDER_COLOR.CGColor;
        self.layer.borderWidth = BORDER_WIDTH;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
{
    self = [self init];
    if (self) {
        CGSize labelSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE_DEFAULT]}];
        CGRect labelRect = CGRectMake(0, 0, labelSize.width+HORIZONTAL_PADDING_DEFAULT*2, labelSize.height+VERTICAL_PADDING_DEFAULT*2);
        _label.text = text;
        _label.frame = labelRect;
        self.frame = CGRectMake(0, 0, labelRect.size.width, labelRect.size.height);
    }
    return self;
}

@end

@implementation SKTagList
{
    NSArray *_textArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textArray = [[NSArray alloc] init];
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textArray = [[NSArray alloc] init];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    _textArray = array;
    [self display];
}

- (void)display
{
    //NSMutableArray *tagViews = [NSMutableArray array];
    for (UIView *subview in [self subviews]) {
//        if ([subview isKindOfClass:[SKTagView class]]) {
//            SKTagView *tagView = (SKTagView*)subview;
//            [tagViews addObject:subview];
//        }
        [subview removeFromSuperview];
    }
    
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in _textArray) {
        DWTagView *tagView = [[DWTagView alloc] initWithText:text];
        if (gotPreviousFrame) {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + tagView.frame.size.width + LABEL_MARGIN_DEFAULT > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + tagView.frame.size.height + BOTTOM_MARGIN_DEFAULT);
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN_DEFAULT, previousFrame.origin.y);
            }
            newRect.size = tagView.frame.size;
            [tagView setFrame:newRect];
        }
        previousFrame = tagView.frame;
        gotPreviousFrame = YES;
        
        [self addSubview:tagView];
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.x, self.frame.size.width, previousFrame.size.height)];
}

@end
