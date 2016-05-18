//
//  DateManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import "DateManager.h"

@interface DateManager ()

@property (nonatomic,strong) NSDateFormatter *format;

@property (nonatomic,strong) NSCalendar *calender_CN;

@property (nonatomic,strong) NSDate *todayDate;

@end

@implementation DateManager


- (NSInteger)currentWeek {
    return [[self.calender_CN components:NSCalendarUnitWeekday fromDate:self.currentDate] weekday];
}


- (NSDate *)dateByAddingDays: (NSInteger)dDays
{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [self.calender_CN dateByAddingComponents:dateComponents toDate:self.todayDate options:0];
    return newDate;
}

//时间转字符串的时间戳
- (NSString *)timeStampWithDate:(NSDate *)date
{
   return [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
}

//时间戳转字符串的时间
- (NSString *)timeWithTimeStamp:(NSUInteger)timeStamp {
  return [self stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [self.format stringFromDate:date];
}
- (NSDate *)dateFromString:(NSString *)string {
    return [self.format dateFromString:string];
}



+ (instancetype)share
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DateManager alloc] init];
    });
    
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.format = [NSDateFormatter new];
        
        [self.format setDateFormat:@"yyyy-MM-dd"];
        
        
        self.calender_CN = [NSCalendar currentCalendar];
        
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
        [NSTimeZone setDefaultTimeZone:timeZone];
        
        [self.calender_CN setTimeZone:timeZone];

    }
    return self;
}

- (NSDate *)todayDate {
    if (!_todayDate) {
        
        NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
        _todayDate = [self.calender_CN dateFromComponents:
                     [self.calender_CN components:unit fromDate:self.currentDate]];
    }
    return _todayDate;
}

- (NSDate *)currentDate {
    return [NSDate date];
}

@end
