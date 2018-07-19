//
//  ThemeTableViewProtocol.m
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/10/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import "ThemeTableViewProtocol.h"
#import "TDPickerTheme.h"
#import "ThemeCell.h"

@interface Container : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) TDPickerTheme *theme;

+ (instancetype)createWithName:(NSString *)name theme:(TDPickerTheme *)theme;

@end

@implementation Container

+ (instancetype)createWithName:(NSString *)name theme:(TDPickerTheme *)theme {
    Container *container = [Container new];
    container.name = name;
    container.theme = theme;
    return container;
}

@end

@interface ThemeTableViewProtocol()

@property (nonatomic, strong) NSMutableArray <Container *>*themesArray;

@end

@implementation ThemeTableViewProtocol

- (instancetype)init {
    self = [super init];
 
    return self;
}

- (NSMutableArray <Container *>*)themesArray {
    
    if (_themesArray == nil) {
        
        _themesArray = [NSMutableArray new];
        
        [_themesArray addObject:[Container createWithName:@"Light theme" theme:[TDPickerTheme lightTheme]]];
        [_themesArray addObject:[Container createWithName:@"Dark theme" theme:[TDPickerTheme darkTheme]]];
        
        [_themesArray addObject:[Container createWithName:@"Red theme" theme: [[TDPickerTheme alloc] initWithTintColor:UIColor.blueColor backgroundColor:UIColor.redColor datePickerTextColor:UIColor.blackColor backgroundDimmingColor:[UIColor.redColor colorWithAlphaComponent:0.6] titleColor:UIColor.blackColor subtitlesColor:UIColor.darkTextColor blurEffectStyle:UIBlurEffectStyleLight cornersRadius:16.]]];
        
        [_themesArray addObject:[Container createWithName:@"Blue theme" theme: [[TDPickerTheme alloc] initWithTintColor:UIColor.whiteColor backgroundColor:UIColor.blueColor datePickerTextColor:UIColor.whiteColor backgroundDimmingColor:[UIColor.blueColor colorWithAlphaComponent:0.6] titleColor:UIColor.whiteColor subtitlesColor:UIColor.whiteColor blurEffectStyle:UIBlurEffectStyleLight cornersRadius:16.]]];
        
         [_themesArray addObject:[Container createWithName:@"Black theme" theme: [[TDPickerTheme alloc] initWithTintColor:UIColor.whiteColor backgroundColor:UIColor.blackColor datePickerTextColor:UIColor.whiteColor backgroundDimmingColor:UIColor.blackColor titleColor:UIColor.whiteColor subtitlesColor:UIColor.whiteColor blurEffectStyle:UIBlurEffectStyleDark cornersRadius:30]]];
        [_themesArray addObject:[Container createWithName:@"White theme" theme: [[TDPickerTheme alloc] initWithTintColor:UIColor.blackColor backgroundColor:UIColor.whiteColor datePickerTextColor:UIColor.blackColor backgroundDimmingColor:[UIColor.whiteColor colorWithAlphaComponent:0.5] titleColor:UIColor.blackColor subtitlesColor:UIColor.blackColor blurEffectStyle:UIBlurEffectStyleLight cornersRadius:16]]];
        
    }
    return _themesArray;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ThemeCell reuserIdentifier] forIndexPath:indexPath];
    
    Container *container = self.themesArray[indexPath.row];
    
    cell.themeNameLabel.text = container.name;
    cell.themeNameLabel.textColor = container.theme.tintColor;
    cell.generalColorView.backgroundColor = container.theme.backgroundColor;
    cell.backgroundColor = container.theme.backgroundDimmingColor;
    cell.generalColorView.layer.borderWidth = 2.f;
    cell.generalColorView.layer.borderColor = [container.theme.datePickerTextColor colorWithAlphaComponent:0.4].CGColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ThemeCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.generalColorView.layer.cornerRadius = cell.generalColorView.bounds.size.height / 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themesArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(themeTableViewProtocolDidSelectTheme:)]) {
        [self.delegate themeTableViewProtocolDidSelectTheme:self.themesArray[indexPath.row].theme];
    }
}

@end
