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

+ (void)saveImage:(UIImage *)img withCompletionBlock:(void(^)(BOOL success, NSError *error))completionBlock;

+ (void)saveVideoAtURL:(NSURL *)url withCompletionBlock:(void(^)(BOOL success, NSError *error))completionBlock;

@end
