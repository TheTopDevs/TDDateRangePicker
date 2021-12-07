//
//  ViewController.m
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/10/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import "ViewController.h"

#import "TDDateRangePicker.h"
#import "TDDateRange.h"
#import "ThemeTableViewProtocol.h"

@interface ViewController () <TDDateRangePickerDelegate, ThemeTableViewProtocolDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TDDateRangePicker *picker;
@property (nonatomic, strong) ThemeTableViewProtocol *protocolManager;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ViewController

#pragma mark - View Cycle

- (void)dealloc {
    self.picker = nil;
    self.protocolManager = nil;
    self.dateFormatter = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picker = [[TDDateRangePicker alloc] init];
    self.picker.delegate = self;
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    self.protocolManager = [ThemeTableViewProtocol new];
    self.protocolManager.delegate = self;
    
    self.tableView.delegate = self.protocolManager;
    self.tableView.dataSource = self.protocolManager;
}

#pragma mark - Private

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return _dateFormatter;
}

#pragma mark - IBActions

- (IBAction)dataRangeAction:(UIButton *)sender {
    
    self.picker.type = PickerTypeDateRange;
    self.picker.datePickerMode = UIDatePickerModeTime;
    [self.picker showPickerFromViewController:self animated:YES completion:^{}];
}

- (IBAction)oneDateAction:(id)sender {
    
    self.picker.type = PickerTypeOneDate;
    [self.picker showPickerAnimated:YES completion:^{}];
}

#pragma mark - TDDateRangePickerDelegate

- (void)dateRangePicker:(TDDateRangePicker *)dateRangePicker didSelectDateRange:(TDDateRange *)dateRange {
    self.selectedRangeLabel.text = [NSString stringWithFormat:@"Selected range from date %@ - to date %@", [self.dateFormatter stringFromDate:dateRange.fromDate], [self.dateFormatter stringFromDate:dateRange.toDate]];
}

- (void)dateRangePicker:(TDDateRangePicker *)dateRangePicker didSelectDate:(NSDate *)date {
    self.selectedDateLabel.text = [NSString stringWithFormat:@"Selected date %@", [self.dateFormatter stringFromDate:date]];
}

#pragma mark - ThemeTableViewProtocolDelegate

- (void)themeTableViewProtocolDidSelectTheme:(TDPickerTheme *)theme {
    self.picker.theme = theme;
}

@end
