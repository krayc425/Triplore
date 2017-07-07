//
//  TPNoteTemplate.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPNoteTemplateNumber){
    TPGreen     = 0,
    TPBrown     = 1,
};

@class TPNoteTitleView;

@interface TPNoteTemplate : NSObject

/**
 模板主颜色
 */
@property (nonnull, nonatomic) UIColor *tem_color;

/**
 模板标题颜色
 */
@property (nonnull, nonatomic) UIColor *tem_titleColor;

/**
 模板文字颜色
 */
@property (nonnull, nonatomic) UIColor *tem_textColor;

/**
 模板
 */
@property (copy, nonnull, nonatomic) NSString *tem_font;

/**
 标题 View
 */
@property (nonnull, nonatomic) TPNoteTitleView *tem_titleView;

/**
 模板编号
 */
@property (nonatomic) TPNoteTemplateNumber tem_num;

- (instancetype _Nonnull)initWithColor:(UIColor *_Nonnull)color
                               andFont:(NSString *_Nonnull)font
                         andTitleColor:(UIColor *_Nonnull)titleColor
                          andTextColor:(UIColor *_Nonnull)textColor
                          andTitleView:(TPNoteTitleView *_Nonnull)titleView
                         andImageStyle:(TPNoteTemplateNumber)number;

@end
