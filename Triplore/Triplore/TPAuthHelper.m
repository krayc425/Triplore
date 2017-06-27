//
//  TPAuthHelper.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPAuthHelper.h"

@implementation TPAuthHelper

+ (void)signUpWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    AVUser *user = [AVUser user];
    user.username = username;
    user.password = password;
    user.email = username;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(completionBlock){
            completionBlock(succeeded, error);
        }
    }];
}

+ (void)loginWithUsername:(NSString *_Nonnull)username andPassword:(NSString *_Nonnull)password withBlock:(void(^_Nonnull)(AVUser *user, NSError *_Nullable error))completionBlock{
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if(completionBlock){
            if (user != nil) {
                completionBlock(user, error);
            } else {
                completionBlock(nil, error);
            }
        }
    }];
}

+ (void)resetPasswordWithUsername:(NSString *_Nonnull)username withBlock:(void(^_Nonnull)(BOOL succeed, NSError *_Nullable error))completionBlock{
    [AVUser requestPasswordResetForEmailInBackground:username block:^(BOOL succeeded, NSError *error) {
        if(completionBlock){
            completionBlock(succeeded, error);
        }
    }];
}

@end
