//
//  SKHelper.m
//  dewen_ios
//
//  Created by 王超 on 15/4/20.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWUtil.h"

@implementation DWUtil

+ (NSString *)getFormatTime:(long long)timestamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateFormat:@"YY-mm-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
