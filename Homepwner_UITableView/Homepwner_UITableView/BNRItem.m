//
//  BNRItem.m
//  randdomItems
//
//  Created by 王超 on 15-1-23.
//  Copyright (c) 2015年 sk80.com. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem


//類方法 創建隨機對象
+ (instancetype)randomItem
{
    //創建不可變數組對象， 包含三個形容詞
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    //創建不可變數組， 包含三個名詞
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    //根據數組對象所包含的對象個數， 得到隨機索引
    // 注意：運算符％是模運算符， 運算后得到的是餘數
    //因此adjectiveIndex =是一個0到2（包括2）的隨機數
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    //注意， 類型為NSInteger的變量不是對象
    //NSInteger是一種針對unsigned long(無符號長整數)的類型定義
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    return newItem;
}


//指定初始化方法
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
{
    //調用父類的指定初始化方法
    self = [super init];
    
    //父類的指定初始化方法是否成功創建了父類對象？
    if (self) {
        //為實例變量設定初始值
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        //設置_dateCreated的值為系統當前時間
        _dateCreated = [[NSDate alloc] init];
    }
    
    //返回初始化後的對象的新地址
    return self;
}

//其他初始化方法
- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

//其他初始化方法
- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (void)setContainedItem:(BNRItem *)containedItem
{
    _containedItem = containedItem;
    self.containedItem.container = self;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recored on %@",
                                   self.itemName,
                                   self.serialNumber,
                                   self.valueInDollars,
                                   self.dateCreated];
    return descriptionString;
}

@end
