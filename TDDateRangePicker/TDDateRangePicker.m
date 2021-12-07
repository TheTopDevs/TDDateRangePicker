//
//  TDDateRangePicker.m
//  PickerDemo
//
//  Created by TopDevs on 5/8/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import "TDDateRangePicker.h"

@interface TDDateRangePicker (Private)

@property (nonatomic, strong) UIViewController *topViewController;

@end

@implementation TDDateRangePicker (Private)

@dynamic topViewController;

- (UIViewController *)topViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if (topController.presentingViewController && topController.isBeingDismissed) {
        return topController.presentingViewController;
    }
    return topController;
}

- (void)presentPickerViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^)(void))completion {
    
    UIViewController *controller = self.topViewController;
    UIViewController *presented = controller.presentedViewController;
    if (presented != nil) {
        [presented dismissViewControllerAnimated:YES completion:^{
            [controller presentViewController:viewController animated:NO completion:^{
                [viewController presentViewController:presented animated:NO completion:completion];
            }];
        }];
    } else {
        [controller presentViewController:viewController animated:NO completion:completion];
    }
}

@end

#define isIPad  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define screenSize  [UIScreen mainScreen].bounds.size

#define displayWidth MIN(screenSize.height, screenSize.width)

#define displayHeight MAX(screenSize.height, screenSize.width)

typedef NS_ENUM(NSUInteger, PickerAxis) {
    PickerAxisVertical = 0,
    PickerAxisHorizontal
};

@interface TDDateRangePicker () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *visualEffectViewBottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *visualEffectViewTopOffset;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *toDateView;
@property (weak, nonatomic) IBOutlet UIView *fromDateView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;

@property (weak, nonatomic) IBOutlet UIStackView *datesPickerStackView;

@property (nonatomic, strong) NSDate *selectedStartDate;
@property (nonatomic, strong) NSDate *selectedEndDate;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) UIDeviceOrientation orientation;
@property (nonatomic, assign) PickerAxis axis;

@property (nonatomic, assign) UIEdgeInsets deviceSafeAreaInsets;

@end

@implementation TDDateRangePicker

#pragma mark - Initialization methods

- (void)setPickerTitle:(NSString *)pickerTitle {
    _pickerTitle = pickerTitle;
    self.titleLabel.text = pickerTitle;
}

- (void)setFromDateTitle:(NSString *)fromDateTitle {
    _fromDateTitle = fromDateTitle;
    self.fromDateLabel.text = fromDateTitle;
}

- (void)setToDateTitle:(NSString *)toDateTitle {
    _toDateTitle = toDateTitle;
    self.toDateLabel.text = toDateTitle;
}

- (void)dealloc {
    _theme = nil;
    _pickerTitle = nil;
    _fromDateTitle = nil;
    _toDateTitle = nil;
    _minimumDate = nil;
    _maximumDate = nil;
    
    self.selectedStartDate = nil;
    self.selectedEndDate = nil;
    self.selectedDate = nil;
}

- (instancetype)init {
    
    self = [super initWithNibName:@"TDDateRangePicker" bundle:nil];
    if (self) {
        self.datePickerMode = UIDatePickerModeDate;
        self->_type = PickerTypeDateRange;
        self->_hidden = YES;
        self.autoChangeMaximumStartDate = YES;
        _pickerTitle = self.titleLabel.text;
        _fromDateTitle = self.fromDateLabel.text;
        _toDateTitle = self.toDateLabel.text;
        self.selectedDate = [NSDate date];
        self.selectedStartDate = [NSDate date];
        self.selectedEndDate = [NSDate date];
        self.maximumDate = [NSDate distantFuture];
        self.minimumDate = [NSDate distantPast];
        self.theme = [TDPickerTheme lightTheme];
        self.modalPresentationStyle = self.theme.modalPresentationStyle;
        [self addObserver:self forKeyPath:@"theme.themeMaster" options:NSKeyValueObservingOptionOld context:NULL];

    }
    
    return self;
}

- (instancetype)initWithTheme:(TDPickerTheme *)theme {
    self = [self init];
    self.theme = theme;
    self.modalPresentationStyle = self.theme.modalPresentationStyle;
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = self.type;
    self.datePickerMode = self.datePickerMode;
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0.01f];
    self.topOffset.constant = screenSize.height;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionOld context:NULL];
    self.orientation = [UIDevice currentDevice].orientation;
    
    if ([self.delegate respondsToSelector:@selector(dateRangePickerWillShow:)]) {
        [self.delegate dateRangePickerWillShow:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"view.frame"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(dateRangePickerDidHide:)]) {
        [self.delegate dateRangePickerDidHide:self];
    }
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if([keyPath isEqualToString:@"view.frame"]) {
        
        CGRect oldFrame = CGRectNull;
        CGRect newFrame = CGRectNull;
        if([change objectForKey:@"old"] != [NSNull null]) {
            oldFrame = [[change objectForKey:@"old"] CGRectValue];
        }
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
        }
        if (oldFrame.size.height != newFrame.size.height) {
            if (newFrame.size.height == displayHeight) {
                self.orientation = UIDeviceOrientationPortrait;
            } else {
                self.orientation = UIDeviceOrientationLandscapeLeft;
            }
        }
    } else if ([keyPath isEqualToString:@"theme.themeMaster"]) {
        [self updateUIToNewTheme:self.theme];
    }
}

#pragma mark - UI

- (void)updateUIToNewTheme:(TDPickerTheme *)theme {
    
    self.view.backgroundColor = [theme.backgroundDimmingColor colorWithAlphaComponent:0.01];
    self.visualEffectView.backgroundColor = theme.backgroundColor;
    self.cancelButton.tintColor = theme.tintColor;
    self.doneButton.tintColor = theme.tintColor;
    self.titleLabel.textColor = theme.titleColor;
    self.fromDateLabel.textColor = theme.subtitlesColor;
    self.toDateLabel.textColor = theme.subtitlesColor;
    self.modalPresentationStyle = theme.modalPresentationStyle;
    [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:theme.blurEffectStyle]];
    self.modalPresentationStyle = theme.modalPresentationStyle;
    [self setMaskTo:self.visualEffectView byRoundingSides:theme.sides];
    [self.endDatePicker setValue:theme.datePickerTextColor forKey:@"textColor"];
    [self.startDatePicker setValue:theme.datePickerTextColor forKey:@"textColor"];
    if (@available(iOS 13.4, *)) {
        self.endDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    if (@available(iOS 13.4, *)) {
        self.startDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    
    self.toDateView.layer.cornerRadius = self.theme.cornersRadius;
    self.fromDateView.layer.cornerRadius = self.theme.cornersRadius;
    
    self.toDateView.layer.borderColor = [self.theme.datePickerTextColor colorWithAlphaComponent:0.4f].CGColor;
    self.fromDateView.layer.borderColor = [self.theme.datePickerTextColor colorWithAlphaComponent:0.4f].CGColor;
    self.toDateView.layer.borderWidth = 0.5f;
    self.fromDateView.layer.borderWidth = 0.5f;
    
    [self setupUI];
}

- (UIEdgeInsets)deviceSafeAreaInsets {
     _deviceSafeAreaInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        _deviceSafeAreaInsets = window.safeAreaInsets;
    }
    return _deviceSafeAreaInsets;
}

- (CGFloat)rangePickerHeight {
    
    CGFloat resultHeight = 0.f;
    
    CGFloat titleHeight = self.titleLabel.bounds.size.height;
    CGFloat subTitlesHeight = self.fromDateLabel.bounds.size.height;
    CGFloat pichersHeight = self.pickerHeight.constant;
    
    if (self.type == PickerTypeDateRange && self.orientation == UIDeviceOrientationPortrait && !(isIPad)) {
        resultHeight += 8.f * 3;
        pichersHeight *= 2.f;
        subTitlesHeight += self.toDateLabel.bounds.size.height;
    } else {
        resultHeight += 8.f;
    }
    resultHeight += titleHeight + pichersHeight + subTitlesHeight + 35.f + (8.f * 4.f);
    
    return resultHeight;
    
}

- (void)setupUI {
    
    self.viewWidth = screenSize.width - 32.f;
    self.topOffset.constant = screenSize.height;
    
    CGFloat pickerHeight = displayWidth;
    if (isIPad) {
        pickerHeight /= 4.f;
    }
    
    pickerHeight -= (self.deviceSafeAreaInsets.bottom + self.deviceSafeAreaInsets.top);
    
    if (self.axis == PickerAxisHorizontal && self.type == PickerTypeOneDate) {
        self.viewWidth /= 2.f;
    }
    
    if (self.orientation != UIDeviceOrientationPortrait && self.type != PickerTypeOneDate) {
        self.viewWidth = self.viewWidth - (self.deviceSafeAreaInsets.left + self.deviceSafeAreaInsets.right);
    }
    
    if (pickerHeight > 200) {
        pickerHeight = 200;
    } else if (pickerHeight < 100) {
        pickerHeight = 100;
    }
    
    if (displayHeight < 600 && pickerHeight > displayHeight / 3) {
        pickerHeight = displayHeight / 3;
    }
    self.pickerHeight.constant = pickerHeight;
    [self setMaskTo:self.visualEffectView byRoundingSides:self.theme.sides];
    [self.view layoutIfNeeded];

}

- (void)setMaskTo:(UIView*)view byRoundingSides:(PickerSides)sides {
    
    if (sides != PickerSidesNone) {
        [view.layer setMask:nil];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = self.theme.cornersRadius;
    } else {
        view.layer.cornerRadius = 0.f;
    }
    
    switch (sides) {
        case PickerSidesBottom:
            self.visualEffectViewBottomOffset.constant = 0;
            self.visualEffectViewTopOffset.constant = 0;
            break;
        case PickerSidesTop:
            self.visualEffectViewBottomOffset.constant = -100;
            self.visualEffectViewTopOffset.constant = 0;
            break;
        case PickerSidesAll:
            self.visualEffectViewBottomOffset.constant = 0;
            self.visualEffectViewTopOffset.constant = 0;
            break;
        case PickerSidesNone:
            self.visualEffectViewBottomOffset.constant = -100;
            self.visualEffectViewTopOffset.constant = 0;
            break;
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)finishDateChanged:(UIDatePicker *)sender {
    if (self.autoChangeMaximumStartDate) {
        self.startDatePicker.maximumDate = [sender date];
    }
}

- (IBAction)okayButtonAction:(id)sender {
    
    switch (self.type) {
        case PickerTypeDateRange:
            self.selectedStartDate = self.startDatePicker.date;
            self.selectedEndDate = self.endDatePicker.date;
            if ([self.delegate respondsToSelector:@selector(dateRangePicker:didSelectDateRange:)]) {
                [self.delegate dateRangePicker:self didSelectDateRange:[[TDDateRange alloc] initRangeWithFromDate:self.selectedStartDate toDate:self.selectedEndDate]];
            }
            break;
        case PickerTypeOneDate:
            self.selectedDate = self.startDatePicker.date;
            if ([self.delegate respondsToSelector:@selector(dateRangePicker:didSelectDate:)]) {
                [self.delegate dateRangePicker:self didSelectDate:self.selectedDate];
            }
            break;
        default:
            break;
    }
    [self hideDateRangePicker:YES animated:YES completion:^{
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self hideDateRangePicker:YES animated:YES completion:^{
    }];
}

#pragma mark - Gesture

- (IBAction)tapGestureHandler:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:sender.view];
    UIView *viewTouched = [sender.view hitTest:point withEvent:nil];
    if ([viewTouched isEqual:self.view]) {
        [self hideDateRangePicker:YES animated:YES completion:^{
        }];
    }
}

#pragma mark - Public

- (void)showPickerFromViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                          completion:(void(^)(void))completion {
    
    __weak __typeof(self) weakSelf = self;
    [viewController presentViewController:self animated:NO completion:^{
        [weakSelf hideDateRangePicker:NO animated:animated completion:completion];
    }];
}

- (void)showPickerAnimated:(BOOL)animated
                completion:(void(^)(void))completion{
    
    __weak __typeof(self) weakSelf = self;
    [self presentPickerViewController:self animated:YES completion:^{
        [weakSelf hideDateRangePicker:NO animated:animated completion:completion];
    }];
}

#pragma mark - Private

- (void)hideDateRangePicker:(BOOL)hide
                   animated:(BOOL)animated
                 completion:(void(^)(void))completion {
    
    if (self.isHidden != hide && hide) {
        
        if ([self.delegate respondsToSelector:@selector(dateRangePickerWillHide:)]) {
            [self.delegate dateRangePickerWillHide:self];
        }
    }
    __weak __typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat offset = screenSize.height - (hide ? 0.f : ([weakSelf rangePickerHeight] + weakSelf.deviceSafeAreaInsets.bottom));
        [UIView animateWithDuration:(animated ? weakSelf.theme.animationDuration/2 : 0.f) animations:^{
            weakSelf.view.backgroundColor = hide ? UIColor.clearColor : weakSelf.theme.backgroundDimmingColor;
        }];
        
        [UIView animateWithDuration:(animated ? weakSelf.theme.animationDuration : 0.f)
                              delay:0.f
             usingSpringWithDamping:0.9f
              initialSpringVelocity:10
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             weakSelf.topOffset.constant = offset;
                             [weakSelf.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 if (hide != weakSelf.isHidden) {
                                     if (!hide) {
                                         if ([weakSelf.delegate respondsToSelector:@selector(dateRangePickerDidShow:)]) {
                                             [weakSelf.delegate dateRangePickerDidShow:weakSelf];
                                         }
                                     }
                                 }
                                 self->_hidden = hide;
                                 if (hide) {
                                     [weakSelf dismissViewControllerAnimated:NO completion:nil];
                                 }
                                 if (completion) {
                                     completion();
                                 }
                             }
                             
                         }];
    });
}

#pragma mark - Private Accessors

- (void)setViewWidth:(CGFloat)viewWidth {
    if (_viewWidth == viewWidth) {
        return;
    }
    _viewWidth = viewWidth;
    self.pickerWidth.constant = viewWidth;
    [self.view layoutIfNeeded];
}

- (void)setOrientation:(UIDeviceOrientation)orientation {
    _orientation = orientation;
    
    if (isIPad) {
        [self setAxis:PickerAxisHorizontal];
        return;
    }
    
    switch(_orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            [self setAxis:PickerAxisVertical];
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self setAxis:PickerAxisHorizontal];
            break;
            
        default: {
            if (self.view.bounds.size.height == displayHeight) {
                self.orientation = UIDeviceOrientationPortrait;
            } else {
                self.orientation = UIDeviceOrientationLandscapeLeft;
            }
        }
            break;
    }
}

- (void)setAxis:(PickerAxis)axis {
    _axis = axis;
    switch (axis) {
        case PickerAxisHorizontal:
            [self.datesPickerStackView setAxis:UILayoutConstraintAxisHorizontal];
            break;
        case PickerAxisVertical:
            [self.datesPickerStackView setAxis:UILayoutConstraintAxisVertical];
            break;
        default:
            break;
    }
    [self setupUI];
    if (!self.isHidden) {
        [self setHidden:NO];
    }
}

#pragma mark - Publick Accessors

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.startDatePicker.minimumDate = minimumDate;
    self.endDatePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.startDatePicker.maximumDate = maximumDate;
    self.endDatePicker.maximumDate = maximumDate;
    
    if (self.autoChangeMaximumStartDate) {
        self.startDatePicker.maximumDate = self.endDatePicker.date;
    }
}

- (void)setType:(PickerType)type {
    _type = type;
    [self.startDatePicker setDate:self.selectedStartDate];
    [self.endDatePicker setDate:self.selectedEndDate];
    switch (type) {
        case PickerTypeDateRange:
            self.startDatePicker.maximumDate = self.maximumDate;
            self.endDatePicker.maximumDate = self.maximumDate;
            self.startDatePicker.minimumDate = self.minimumDate;
            self.endDatePicker.minimumDate = self.minimumDate;
            self.startDatePicker.maximumDate = [self.endDatePicker date];
            [self.toDateView setHidden:NO];
            [self.toDateLabel setHidden:NO];
            [self.endDatePicker setHidden:NO];
            break;
        case PickerTypeOneDate:
            [self.startDatePicker setDate:self.selectedDate];
            self.startDatePicker.minimumDate = self.minimumDate;
            self.startDatePicker.maximumDate = self.maximumDate;
            [self.toDateLabel setHidden:YES];
            [self.endDatePicker setHidden:YES];
            [self.toDateView setHidden:YES];
            break;
        default:
            break;
    }
}

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    [self hideDateRangePicker:hidden animated:YES completion:nil];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.startDatePicker.datePickerMode = datePickerMode;
    self.endDatePicker.datePickerMode = datePickerMode;
}

- (void)setTheme:(TDPickerTheme *)theme {
    _theme = theme;
    [self updateUIToNewTheme:self.theme];
}

@end
