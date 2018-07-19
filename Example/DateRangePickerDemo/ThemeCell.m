//
//  ThemeCell.m
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/10/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)reuserIdentifier {
    return @"ThemeCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Save previous view color.
    UIColor *color = self.generalColorView.backgroundColor;

    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.generalColorView.backgroundColor = color;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // Save previous view color.
    UIColor *color = self.generalColorView.backgroundColor;

    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.generalColorView.backgroundColor = color;
    }
}

@end
