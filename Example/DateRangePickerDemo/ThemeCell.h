//
//  ThemeCell.h
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/10/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *generalColorView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;

+ (NSString *)reuserIdentifier;

@end
