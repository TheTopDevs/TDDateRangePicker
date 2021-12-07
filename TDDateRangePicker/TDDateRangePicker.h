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

- (void)dateRangePickerWillShow:(TDDateRangePicker *_Nonnull)dateRangePicker;

- (void)dateRangePickerDidShow:(TDDateRangePicker *_Nonnull)dateRangePicker;

- (void)dateRangePickerWillHide:(TDDateRangePicker *_Nonnull)dateRangePicker;

- (void)dateRangePickerDidHide:(TDDateRangePicker *_Nonnull)dateRangePicker;

/**
 Delegate method returns dateRange with two selected dates from date range picker.
 */
- (void)dateRangePicker:(TDDateRangePicker *_Nonnull)dateRangePicker didSelectDateRange:(TDDateRange *_Nonnull)dateRange;

/**
 Delegate method returns selected date from single date picker.
 */
- (void)dateRangePicker:(TDDateRangePicker *_Nonnull)dateRangePicker didSelectDate:(NSDate *_Nonnull)date;

@end

@interface TDDateRangePicker : UIViewController

/**
The delegate of the TDDateRangePicker object.
The delegate must adopt the TDDateRangePickerDelegate protocol. The TDDateRangePicker class, which does not retain the delegate, invokes each protocol method the delegate implements.
*/
@property (nonatomic, weak, nullable) id <TDDateRangePickerDelegate> delegate;

///Object themes for customizing the type of date range picker.
@property (nonatomic, strong) TDPickerTheme * _Nonnull theme;

/// The title that will be displayed on the picker.
@property (nonatomic, strong) NSString * _Nonnull pickerTitle;

/// The title that will be displayed in the from date section.
@property (nonatomic, strong) NSString * _Nonnull fromDateTitle;

/// The title that will be displayed in the to date section.
@property (nonatomic, strong) NSString * _Nonnull toDateTitle;

/// The PickerType is a type of displayed date range picker. This type contains two types of pickers with one date or with a date range.
@property (nonatomic, assign) PickerType type;

/// Automatically change the maximum start date depending on the selected end date.
@property (nonatomic, assign) BOOL autoChangeMaximumStartDate;

/// The mode of the date pickers.
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

///The minimum date that a date range picker can show.
@property (nonatomic, retain) NSDate * _Nonnull minimumDate;

///The maximum date that a date range picker can show. 
@property (nonatomic, retain) NSDate * _Nonnull maximumDate;

///A Boolean value that determines whether the view is hidden.
@property (nonatomic, assign, getter=isHidden, ) BOOL hidden;

/**
 A method that creates the picker with a selected theme.
 */
- (instancetype _Nonnull )initWithTheme:(TDPickerTheme * _Nonnull)theme;

/// Present picker from view controller.
- (void)showPickerFromViewController:(UIViewController * _Nonnull)viewController
                            animated:(BOOL)animated
                          completion:(void(^_Nullable)(void))completion;

/// Present picker from anywhere.
- (void)showPickerAnimated:(BOOL)animated
                completion:(void(^_Nullable)(void))completion;

@end
