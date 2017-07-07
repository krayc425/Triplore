//
//  TPNoteDecorator.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TPNote;
@class TPNoteTemplate;

@interface TPNoteDecorator : NSObject

/**
 得到模板装饰后的笔记 Views

 @param note  笔记模型
 @param template 哪种模板
 @return 修饰后的 UIView 数组
 */
+ (NSArray<UIView *> *)getNoteViews:(TPNote *)note andTemplate:(TPNoteTemplate *)template;

@end
