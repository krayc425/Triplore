//
//  TPNoteTitleViewGreen.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteTitleViewGreen.h"

@implementation TPNoteTitleViewGreen

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDate:(NSDate * _Nonnull)date{
    NSDateFormatter *monthYearFmt = [[NSDateFormatter alloc] init];
    [monthYearFmt setDateFormat:@"MMMM yyyy"];
    [self.monthYearLabel setText:[monthYearFmt stringFromDate:date]];
    NSDateFormatter *dayFmt = [[NSDateFormatter alloc] init];
    [dayFmt setDateFormat:@"dd"];
    [self.dayLabel setText:[dayFmt stringFromDate:date]];
}

@end
