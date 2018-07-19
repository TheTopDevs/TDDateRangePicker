//
//  ThemeTableViewProtocol.h
//  TDDateRangePickerDemo
//
//  Created by TopDevs on 7/10/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TDPickerTheme;

@protocol ThemeTableViewProtocolDelegate <NSObject>

- (void)themeTableViewProtocolDidSelectTheme:(TDPickerTheme *)theme;

@end

@interface ThemeTableViewProtocol : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <ThemeTableViewProtocolDelegate> delegate;

@end
