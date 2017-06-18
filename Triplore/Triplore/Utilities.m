//
//  Utilities.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Utilities.h"

@implementation Utilities

+ (void)setFontAtIndex:(NSUInteger)index{
    [[NSUserDefaults standardUserDefaults] setValue:TPAllFonts[index][@"name"] forKey:@"font"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
