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

+ (NSArray<UIView *> *)getNoteViews:(TPNote *)note andTemplate:(TPNoteTemplate *)template;

@end
