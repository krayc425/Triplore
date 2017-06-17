//
//  TPNoteTitleView.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteTitleView.h"

@implementation TPNoteTitleView

- (void)setDate:(NSDate * _Nonnull)date{
    NSDateFormatter *monthYearFmt = [[NSDateFormatter alloc] init];
    [monthYearFmt setDateFormat:@"MMMM yyyy"];
    [self.monthYearLabel setText:[monthYearFmt stringFromDate:date]];
    NSDateFormatter *dayFmt = [[NSDateFormatter alloc] init];
    [dayFmt setDateFormat:@"dd"];
    [self.dayLabel setText:[dayFmt stringFromDate:date]];
}

- (void)setTitleTextColor:(UIColor *)color{
    [self.dayLabel setTextColor:color];
    [self.monthYearLabel setTextColor:color];
}

@end
