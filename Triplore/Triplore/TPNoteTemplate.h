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

@property (nonnull, nonatomic) UIColor *tem_color;
@property (nonnull, nonatomic) UIColor *tem_titleColor;
@property (nonnull, nonatomic) UIColor *tem_textColor;
@property (copy, nonnull, nonatomic) NSString *tem_font;
@property (nonnull, nonatomic) TPNoteTitleView *tem_titleView;
@property (nonatomic) TPNoteTemplateNumber tem_num;

- (instancetype _Nonnull)initWithColor:(UIColor *_Nonnull)color
                               andFont:(NSString *_Nonnull)font
                         andTitleColor:(UIColor *_Nonnull)titleColor
                          andTextColor:(UIColor *_Nonnull)textColor
                          andTitleView:(TPNoteTitleView *_Nonnull)titleView
                         andImageStyle:(TPNoteTemplateNumber)number;

@end
