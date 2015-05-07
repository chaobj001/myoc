//
//  BNRHypnosisView.m
//  UIViewExample
//
//  Created by 王超 on 15-1-24.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRHypnosisView.h"

//類擴展
@interface BNRHypnosisView ()

//聲明一個圓形屬性
@property (nonatomic, strong) UIColor *circleColor;

@end


@implementation BNRHypnosisView


//UIView類指定初始化方法
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //設置BNRHypnosisView對象的背景顏色為透明；
        self.backgroundColor = [UIColor clearColor];
        
        //設置圓形屬性的默認顏色
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}


// 自定義繪圖方法，視圖根據drawRect:方法將自己繪製到圖層上。
// UIView的子類可以覆蓋drawRect:完成自定義繪圖任務；
// 繪製圓形
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    //根據bounds計算中心點
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;

    //使最外層圓形成為視圖的外接圓
    float maxRadius = hypotf(bounds.size.width, bounds.size.height) / 2.0;
    
    //UIBezierPath用來繪製直線或者曲線，聰哥組成各種形狀；
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    //設置線條寬度為10點
    path.lineWidth = 10;
    
    //設置繪製顏色為淺灰色
    //[[UIColor lightGrayColor] setStroke];
    [self.circleColor setStroke];
    
    //向UIBezierPath發送消息，繪製路徑
    [path stroke];
    
    //CGRect imageRect = CGRectMake(5, 5, bounds.size.width, bounds.size.width);
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    [logoImage drawInRect:bounds];
    
}

//BNRHypnosisView視圖對象被觸摸時會收到該消息
//觸摸時創建隨機生成UIColor對象，并賦給circleColor屬性
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    //獲取三個0到1之間的數字
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    self.circleColor = randomColor;
}

//實現自定義存方法
- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];//通知自己需要重繪視圖, 重繪某一區域的方法setNeedsDisplayInRect:
}

@end
