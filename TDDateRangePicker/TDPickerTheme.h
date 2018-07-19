//
//  TDPickerTheme.h
//  PickerDemo
//
//  Created by TopDevs on 5/31/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PickerSides) {
    PickerSidesNone = 0,
    PickerSidesTop,
    PickerSidesBottom,
    PickerSidesAll
};

extern inline UIColor *colorWithRGBA(int red, int green, int blue, int alpha);

/**
Object themes for customizing the type of date range picker.
*/
@interface TDPickerTheme : NSObject

/**
 KVO Master property. Observe this property for observing for all values of picker theme model.
 */
@property (nonatomic, strong, readonly) id themeMaster;
/// Buttons color
@property (nonatomic, strong) UIColor *tintColor;
/// Picker's text color
@property (nonatomic, strong) UIColor *datePickerTextColor;
/// Background color
@property (nonatomic, strong) UIColor *backgroundColor;
/// Substrate color shading.
@property (nonatomic, strong) UIColor *backgroundDimmingColor;
/// Color of title label
@property (nonatomic, strong) UIColor *titleColor;
/// Color of subtitles label
@property (nonatomic, strong) UIColor *subtitlesColor;
/// Blur styles available for UIVisualEffectView bacground of picker view
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;
/// Modal presentation styles available when presenting view controllers.
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;
/// The radius to use when drawing rounded corners for the picker view background
@property (nonatomic, assign) CGFloat cornersRadius;
/// The corners of a picker view.
@property (nonatomic, assign) PickerSides sides;
/// The total duration of the animations, measured in seconds.
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 Initializing the theme for customizing the date range picker.
 */
- (_Nonnull instancetype)initWithTintColor:(UIColor * _Nullable )tintColor
                           backgroundColor:(UIColor * _Nullable )backgroundColor
                       datePickerTextColor:(UIColor * _Nullable )datePickerTextColor
                    backgroundDimmingColor:(UIColor * _Nullable )backgroundDimmingColor
                                titleColor:(UIColor * _Nullable )titleColor
                            subtitlesColor:(UIColor * _Nullable )subtitlesColor
                           blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                             cornersRadius:(CGFloat)cornersRadius;

/// Preset with default light theme
+ (_Nonnull instancetype)lightTheme;
/// Preset with default dark theme
+ (_Nonnull instancetype)darkTheme;

@end

@interface TDPickerTheme (Defaults)

+ (UIColor *)defaultTintColor;

+ (UIColor *)defaultBackgroundColor;

+ (UIColor *)defaultDatePickerTextColor;

+ (UIColor *)defaultBackgroundDimmingColor;

+ (UIColor *)defaultTitleColor;

+ (UIColor *)defaultSubtitlesColor;

+ (UIBlurEffectStyle)defaultBlurEffectStyle;

+ (UIModalPresentationStyle)defaultModalPresentationStyle;

+ (CGFloat)defaultCornersRadius;

+ (PickerSides)defaultSides;

+ (NSTimeInterval)defaultAnimationDuration;

@end
