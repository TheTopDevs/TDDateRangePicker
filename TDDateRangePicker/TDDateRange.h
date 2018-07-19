//
//  TDDateRange.h
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/16/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDDateRange : NSObject

/// Init date range with from date any to date.
+ (TDDateRange *)rangeWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/// Init date range with from date any to date.
- (instancetype)initRangeWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/// the start date of date range
@property (nonatomic, strong) NSDate *fromDate;
/// the end date of date range
@property (nonatomic, strong) NSDate *toDate;

- (NSDateComponents *)componentsInRangeWithComponents:(NSCalendarUnit)components;
/// The number of years in the date range.
- (NSInteger)numberOfYearsInRange;
/// The number of months in the date range.
- (NSInteger)numberOfMonthsInRange;
/// The number of weeks in the date range.
- (NSInteger)numberOfWeeksInRange;
/// The number of days in the date range.
- (NSInteger)numberOfDaysInRange;
/// The number of hours in the date range.
- (NSInteger)numberOfHoursInRange;
/// The number of minutes in the date range.
- (NSInteger)numberOfMinutesInRange;
/// The number of seconds in the date range.
- (NSInteger)numberOfSecondsInRange;

@end
