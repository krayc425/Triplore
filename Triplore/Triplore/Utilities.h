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

typedef NS_ENUM(NSInteger, TPNoteMode){
    TPNewNote     = 1,
    TPOldNote     = 2,
};

@interface Utilities : NSObject

+ (void)setFontAtIndex:(NSUInteger)index;

+ (NSString *)getErrorCodeDescription:(NSUInteger)code;

@end
