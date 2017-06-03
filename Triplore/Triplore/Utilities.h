//
//  Utilities.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPCategoryMode){
    TPCategoryFood      = 1,
    TPCategoryShopping  = 2,
    TPCategoryPlace     = 3,
};


@interface Utilities : NSObject

+ (UIColor *)getColor;

+ (UIColor *)getBackgroundColor;

+ (UIColor *)getGradientColorDark;

@end
