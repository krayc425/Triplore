//
//  Utilities.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Utilities.h"

@implementation Utilities

+ (void)setFontAtIndex:(NSUInteger)index{
    [[NSUserDefaults standardUserDefaults] setValue:TPAllFonts[index][@"name"] forKey:@"font"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getErrorCodeDescription:(NSUInteger)code{
    switch (code) {
        case 200:
            return @"用户名为空";
        case 201:
            return @"密码为空";
        case 202:
            return @"密码已经被占用";
        case 203:
            return @"电子邮箱已经被占用";
        case 204:
            return @"邮箱为空";
        case 205:
            return @"找不到邮箱对应的用户";
        case 206:
            return @"没有提供 session";
        case 207:
            return @"只能通过注册创建用户，不允许第三方登录";
        case 210:
            return @"用户名和密码不匹配";
        case 211:
            return @"找不到用户";
        case 212:
            return @"请提供手机号码";
        case 213:
            return @"手机号码对应的用户不存在";
        case 214:
            return @"手机号码已经被注册";
        case 215:
            return @"未验证的手机号码";
        case 216:
            return @"未验证的邮箱地址";
        case 217:
            return @"无效的用户名，不允许空白用户名";
        case 218:
            return @"无效的密码，不允许空白密码";
        default:
            return @"";
    }
}

@end
