//
//  TPNoteManager.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCreator.h"
#import <UIKit/UIKit.h>

@implementation TPNoteCreator{
    NSMutableArray *noteViewArray;
}

static TPNoteCreator *_instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [TPNoteCreator shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        noteViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [TPNoteCreator shareInstance];
}

#pragma mark - Create Note Methods

/**
 增加一个 View

 @param view 子 view
 */
- (void)addNoteView:(UIView *)view{
    [noteViewArray addObject:view];
}

/**
 清空 View 数组
 */
- (void)clearNoteView{
    [noteViewArray removeAllObjects];
}

/**
 @return View 数组子 View 数量
 */
- (NSInteger)countNoteView{
    return noteViewArray.count;
}

/**
 @return View 数组
 */
- (NSArray *)getNoteViews{
    return [NSArray arrayWithArray:noteViewArray];
}

@end
