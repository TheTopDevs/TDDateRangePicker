//
//  TDDateRangePicker.h
//  PickerDemo
//
//  Created by TopDevs on 5/8/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TDDateRange.h"
#import "TDPickerTheme.h"

@class TDDateRangePicker;

typedef NS_ENUM(NSUInteger, PickerType) {
    PickerTypeDateRange = 0,
    PickerTypeOneDate
};

///The delegate of a TDDateRangePicker object must adopt the TDDateRangePickerDelegate protocol.
@protocol TDDateRangePickerDelegate <NSObject>

@optional

- (void)dateRangePickerWillShow:(TDDateRangePicker *)dateRangePicker;

- (void)dateRangePickerDidShow:(TDDateRangePicker *)dateRangePicker;

- (void)dateRangePickerWillHide:(TDDateRangePicker *)dateRangePicker;

- (void)dateRangePickerDidHide:(TDDateRangePicker *)dateRangePicker;

/**
 Delegate method returns dateRange with two selected dates from date range picker.
 */
- (void)dateRangePicker:(TDDateRangePicker *)dateRangePicker didSelectDateRange:(TDDateRange *)dateRange;

/**
 Delegate method returns selected date from single date picker.
 */
- (void)dateRangePicker:(TDDateRangePicker *)dateRangePicker didSelectDate:(NSDate *)date;

@end

@interface TDDateRangePicker : UIViewController

/**
The delegate of the TDDateRangePicker object.
The delegate must adopt the TDDateRangePickerDelegate protocol. The TDDateRangePicker class, which does not retain the delegate, invokes each protocol method the delegate implements.
*/
@property (nonatomic, weak, nullable) id <TDDateRangePickerDelegate> delegate;

///Object themes for customizing the type of date range picker.
@property (nonatomic, strong) TDPickerTheme *theme;

/// The title that will be displayed on the picker.
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// The title that will be displayed in the from date section.
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;

/// The title that will be displayed in the to date section.
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;

/// The PickerType is a type of displayed date range picker. This type contains two types of pickers with one date or with a date range.
@property (nonatomic, assign) PickerType type;

/// Automatically change the maximum start date depending on the selected end date.
@property (nonatomic, assign) BOOL autoChangeMaximumStartDate;

/// The mode of the date pickers.
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

///The minimum date that a date range picker can show.
@property (nonatomic, strong) NSDate *minimumDate;

///The maximum date that a date range picker can show. 
@property (nonatomic, strong) NSDate *maximumDate;

///A Boolean value that determines whether the view is hidden.
@property (nonatomic, assign, getter=isHidden, ) BOOL hidden;

/**
 A method that creates the picker with a selected theme.
 */
- (instancetype)initWithTheme:(TDPickerTheme *)theme;

/// Present picker from view controller.
- (void)showPickerFromViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                          completion:(void(^)(void))completion;

/// Present picker from anywhere.
- (void)showPickerAnimated:(BOOL)animated
                completion:(void(^)(void))completion;

@end
