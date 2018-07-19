//
//  TDDateRange.m
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/16/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import "TDDateRange.h"

@implementation TDDateRange

+ (TDDateRange *)rangeWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    return [[TDDateRange alloc] initRangeWithFromDate:fromDate toDate:toDate];
}

- (instancetype)initRangeWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    self = [self init];
    self.fromDate = fromDate;
    self.toDate = toDate;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fromDate = [NSDate distantPast];
        self.toDate = [NSDate distantFuture];
    }
    
    return self;
}

- (NSDateComponents *)componentsInRangeWithComponents:(NSCalendarUnit)components {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCalendar components:components
                                                            fromDate:self.fromDate
                                                              toDate:self.toDate
                                                             options:0];
    return dateComponents;
}

- (NSInteger)numberOfYearsInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitYear] year];
}

- (NSInteger)numberOfMonthsInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitMonth] month];
}

- (NSInteger)numberOfWeeksInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitWeekday] weekday];
}

- (NSInteger)numberOfDaysInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitDay] day];
}

- (NSInteger)numberOfHoursInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitHour] hour];
}


- (NSInteger)numberOfMinutesInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitMinute] minute];
}

- (NSInteger)numberOfSecondsInRange {
    return [[self componentsInRangeWithComponents:NSCalendarUnitSecond] second];
}

@end
