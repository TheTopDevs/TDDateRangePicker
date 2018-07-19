//
//  TDPickerTheme.m
//  PickerDemo
//
//  Created by TopDevs on 5/31/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import "TDPickerTheme.h"

inline UIColor *colorWithRGBA(int red, int green, int blue, int alpha) {
    return [UIColor colorWithRed:red / 255.
                           green:green / 255.
                            blue:blue / 255.
                           alpha:alpha / 100.];
};

@interface TDPickerTheme ()

@property (nonatomic, strong, readwrite) id themeMaster;

@end

@implementation TDPickerTheme

- (_Nonnull instancetype)initWithTintColor:(UIColor *)tintColor
                           backgroundColor:(UIColor *)backgroundColor
                       datePickerTextColor:(UIColor *)datePickerTextColor
                    backgroundDimmingColor:(UIColor *)backgroundDimmingColor
                                titleColor:(UIColor *)titleColor
                            subtitlesColor:(UIColor *)subtitlesColor
                           blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                             cornersRadius:(CGFloat)cornersRadius {
    
    self = [super init];
    if (self) {
        self.tintColor = tintColor;
        self.backgroundColor = backgroundColor;
        self.datePickerTextColor = datePickerTextColor;
        self.backgroundDimmingColor = backgroundDimmingColor;
        self.titleColor = titleColor;
        self.subtitlesColor = subtitlesColor;
        self.blurEffectStyle = blurEffectStyle;
        self.modalPresentationStyle = [TDPickerTheme defaultModalPresentationStyle];
        self.cornersRadius = cornersRadius;
        self.sides = PickerSidesTop;
        self.animationDuration = [TDPickerTheme defaultAnimationDuration];
    }
    
    return self;
}

+ (_Nonnull instancetype)lightTheme {
    return [[TDPickerTheme alloc] initWithTintColor:[TDPickerTheme defaultTintColor]
                                  backgroundColor:[TDPickerTheme defaultBackgroundColor]
                              datePickerTextColor:[TDPickerTheme defaultDatePickerTextColor]
                           backgroundDimmingColor:[TDPickerTheme defaultBackgroundDimmingColor]
                                       titleColor:[TDPickerTheme defaultTitleColor]
                                   subtitlesColor:[TDPickerTheme defaultSubtitlesColor]
                                  blurEffectStyle:[TDPickerTheme defaultBlurEffectStyle]
                                    cornersRadius:[TDPickerTheme defaultCornersRadius]];
}

+ (_Nonnull instancetype)darkTheme {
    
    return [[TDPickerTheme alloc] initWithTintColor:[UIColor lightTextColor]
                                  backgroundColor:[UIColor clearColor]
                              datePickerTextColor:[UIColor lightTextColor]
                           backgroundDimmingColor:colorWithRGBA(0, 0, 0, 60)
                                       titleColor:[UIColor lightTextColor]
                                   subtitlesColor:[UIColor lightTextColor]
                                  blurEffectStyle:UIBlurEffectStyleDark
                                    cornersRadius:[TDPickerTheme defaultCornersRadius]];
}

+ (NSSet *)keyPathsForValuesAffectingThemeMaster {
    return [NSSet setWithObjects:@"tintColor",
            @"backgroundColor",
            @"backgroundDimmingColor",
            @"titleColor",
            @"subtitlesColor",
            @"blurEffectStyle",
            @"modalPresentationStyle",
            @"cornersRadius",
            @"corners",
            @"animationDuration", nil];
}

@end

@implementation TDPickerTheme (Defaults)

+ (UIColor *)defaultTintColor {
    return colorWithRGBA(45, 123, 246, 100);
}

+ (UIColor *)defaultBackgroundColor {
    return colorWithRGBA(0, 0, 0, 0);
}

+ (UIColor *)defaultBackgroundDimmingColor {
    return colorWithRGBA(255, 255, 255, 60);
}

+ (UIColor *)defaultTitleColor {
    return colorWithRGBA(0, 0, 0, 100);
}

+ (UIColor *)defaultSubtitlesColor {
    return colorWithRGBA(0, 0, 0, 100);
}

+ (UIColor *)defaultDatePickerTextColor {
    return colorWithRGBA(0, 0, 0, 100);
}

+ (UIBlurEffectStyle)defaultBlurEffectStyle {
    return UIBlurEffectStyleLight;
}

+ (UIModalPresentationStyle)defaultModalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}

+ (CGFloat)defaultCornersRadius {
    return 14.0;
}

+ (PickerSides)defaultSides {
    return PickerSidesTop;
}

+ (NSTimeInterval)defaultAnimationDuration {
    return 0.8;
}

@end
