//
//  DateManager.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/3.
//  Copyright © 2016年 name. All rights reserved.
//

#import "DateManager.h"


@interface DateManager ()

@property (nonatomic,strong) NSCalendar *calender_CN;

@property (nonatomic,strong) NSDate *todayDate;

@end

static inline NSTimeInterval getDefaultTimeStamp(NSNumber *timeStamp) {
    return timeStamp.stringValue.length > 10 ? timeStamp.doubleValue * 0.001 : timeStamp.doubleValue;
}

@implementation DateManager



- (NSInteger)currentWeek {
    return [[self.calender_CN components:NSCalendarUnitWeekday fromDate:self.currentDate] weekday];
}



- (NSDate *)dateByTodayAddingDays: (NSInteger)dDays
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
- (NSString *)timeWithTimeStamp:(NSInteger)timeStamp  {
    [self.format setDateFormat:defautFormat];
    return [self.format stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
}

- (NSString *)conversionTimeStamp:(NSNumber *)timeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:getDefaultTimeStamp(timeStamp)];
        
   NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;

   NSDateComponents *dc     = [self.calender_CN components:unit fromDate:date];

   NSDateComponents *nowDc  = [self.calender_CN components:unit fromDate:self.currentDate];

    [self.format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSArray *times = [[self.format stringFromDate:date] componentsSeparatedByString:@" "];
    
    if (dc.year < nowDc.year) return times[0];
    
    if (dc.month < nowDc.month || dc.day < nowDc.day - 2) {
        return [times[0] substringWithRange:NSMakeRange(5, 5)];
    }
    
    if (dc.day == nowDc.day - 2) {                  //前天
        return [NSString stringWithFormat:@"前天 %@",times[1]];
    }
    
    if (dc.day == nowDc.day - 1 || dc.hour < nowDc.hour - 2) {
        return [NSString stringWithFormat:@"昨天 %@",times[1]];
    }
    
    if (dc.hour == nowDc.hour - 2)    return @"2 小时前";
    if (dc.hour == nowDc.hour - 1)    return @"1 小时前";

    if (dc.minute <  nowDc.minute)    return [NSString stringWithFormat:@"%zd 分钟前",nowDc.minute - dc.minute];
    if (dc.minute == nowDc.minute)    return @"刚刚";
    
    return nil;
}

- (NSString *)conversionTimeStampVer2:(NSNumber *)timeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:getDefaultTimeStamp(timeStamp)];
    
    NSCalendarUnit unit      = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *dc     = [self.calender_CN components:unit fromDate:date];
    
    NSDateComponents *nowDc  = [self.calender_CN components:unit fromDate:self.currentDate];
    
    if (dc.year < nowDc.year) return [NSString stringWithFormat:@"%zd年%zd月%zd日更新",dc.year,dc.month,dc.day];
    
    if (dc.month < nowDc.month || dc.day < nowDc.day - 1) {
        return [NSString stringWithFormat:@"%zd月%zd日更新",dc.month,dc.day];
    }
    
    if (dc.day == nowDc.day - 1) return @"昨天更新";
    if (dc.day == nowDc.day) return @"今天更新";

    return nil;
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
        
        _format = [[NSDateFormatter alloc] init];
        
        [_format setDateFormat:defautFormat];
        
        _format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        self.calender_CN = [NSCalendar currentCalendar];
        [self.calender_CN setTimeZone:[NSTimeZone systemTimeZone]];
        
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
