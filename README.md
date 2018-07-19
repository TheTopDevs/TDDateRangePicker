# TDDateRangePicker

`TDDateRangePicker` is a picker with which you can get both a date range and one date and it's all with beautiful designs, animations and much more.
We have taken into account all the conditions of the its usage.
The library includes custom `TDDateRangePicker` and a `TDPickerTheme` which allow you to customize the appearance of the picker.

This library is easy to implement. All you need is to connect `TBDateRangePicker` to your class, and initialize a new class object. To get the result, your class must be adopt to the `TDDateRangePickerDelegate` protocol.
In order to show the picker there are two methods: one of them shows RangePicker from your controller, the other shows RangePicker when called from any class.

>An example of implementation:

```objective-c
- (void)showPicker {

    TDDateRangePicker *picker = [[TDDateRangePicker alloc] init];
    picker.delegate = self;
    
    // Default datePickerMode is - UIDatePickerModeDate
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    // This type is default type of range picker. Also you can use other type - PickerTypeOneDate
    picker.type = PickerTypeDateRange;
    
    // The customization object. The default theme is lightTheme.
    picker.theme = [self setUpTheme];

    [self.picker showPickerFromViewController:self animated:YES completion:^{ }];
}

- (TDPickerTheme *)setUpTheme {
    return [[TDPickerTheme alloc] initWithTintColor:UIColor.blueColor backgroundColor:UIColor.redColor datePickerTextColor:UIColor.blackColor backgroundDimmingColor:[UIColor.redColor colorWithAlphaComponent:0.6] titleColor:UIColor.blackColor subtitlesColor:UIColor.darkTextColor blurEffectStyle:UIBlurEffectStyleLight cornersRadius:16.];
}

#pragma mark - TDDateRangePickerDelegate

- (void)dateRangePicker:(TDDateRangePicker *)dateRangePicker didSelectDateRange:(TDDateRange *)dateRange {
    self.selectedRangeLabel.text = [NSString stringWithFormat:@"Selected range from date %@ - to date %@", [self.dateFormatter stringFromDate:dateRange.fromDate], [self.dateFormatter stringFromDate:dateRange.toDate]];
    NSLog(@"%ld", [dateRange numberOfMinutesInRange]);
}
```

More examples of usage can be seen in the demo application. 
