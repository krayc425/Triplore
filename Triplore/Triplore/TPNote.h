//
//  TPNote.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 存入数据库的 Note 模型
 */
@interface TPNote : NSObject

@property (nonatomic) NSInteger noteid;
@property (nonatomic) NSInteger videoid;
@property (nonatomic, nonnull) NSDate *createTime;
@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nonnull) NSArray<UIView *> *views;

@end
