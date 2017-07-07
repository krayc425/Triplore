//
//  TPMediaSaver.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TPMediaSaver : NSObject

/**
 检查权限

 @param completionBlock 回调块
 */
+ (void)checkStatusWithCompletionBlock:(void(^_Nonnull)(BOOL authorized))completionBlock;

/**
 保存图片

 @param img 图片
 @param completionBlock 回调块
 */
+ (void)saveImage:(UIImage *_Nonnull)img withCompletionBlock:(void(^_Nonnull)(BOOL success, NSError * _Nullable error))completionBlock;

/**
 保存视频

 @param url 视频本地 URL
 @param completionBlock 回调块
 */
+ (void)saveVideoAtURL:(NSURL *_Nonnull)url withCompletionBlock:(void(^_Nonnull)(BOOL success, NSError * _Nullable error))completionBlock;

@end
