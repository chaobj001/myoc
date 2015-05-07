//
//  BNRCrosshairView.m
//  Homepwner_UITableView
//
//  Created by 王超 on 15-2-1.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRCrosshairView.h"

@implementation BNRCrosshairView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    float radius=hypot(bounds.size.width, bounds.size.height)/10.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    [path moveToPoint:CGPointMake(center.x, center.y-radius-15)];
    
    [path addLineToPoint:CGPointMake(center.x, center.y-radius+15)];
    
    [path moveToPoint:CGPointMake(center.x, center.y+radius-15)];
    
    [path addLineToPoint:CGPointMake(center.x, center.y+radius+15)];
    
    [path moveToPoint:CGPointMake(center.x-radius-15, center.y)];
    
    [path addLineToPoint:CGPointMake(center.x-radius+15, center.y)];
    
    [path moveToPoint:CGPointMake(center.x+radius-15, center.y)];
    
    [path addLineToPoint:CGPointMake(center.x+radius+15, center.y)];
    
    
    path.lineWidth=7;
    
    [[UIColor lightGrayColor] setStroke];
    
    //Draw it!
    
    [path stroke];
}

@end
