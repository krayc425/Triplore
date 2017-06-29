//
//  TPAuthHelper.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface TPAuthHelper : NSObject

/**
 注册
 
 @param username 用户名（邮箱）
 @param password 密码
 @param completionBlock 回调块
 */
+ (void)signUpWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock;

/**
 登录

 @param username 用户名（邮箱）
 @param password 密码
 @param completionBlock 回调块
 */
+ (void)loginWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password withBlock:(void(^_Nonnull)(AVUser * _Nonnull user, NSError *_Nullable error))completionBlock;

/**
 重置密码

 @param username 用户名（邮箱）
 @param completionBlock 回调块
 */
+ (void)resetPasswordWithUsername:(NSString *_Nonnull)username withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock;

@end
