//
//  TPVideoModel.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TPVideoType){
    TPVideoNormal     = 1,
    TPVideoAlbum      = 2,
};

/**
 用于和 VC 交流的 Video 模型
 */
@interface TPVideoModel : NSObject

@property (nonnull, nonatomic) NSString *title;
@property (nonnull, nonatomic) NSString *shortTitle;
@property (nonnull, nonatomic) NSString *imgURL;    //请求图片 URL 后面需要拼接上“?sign=iqiyi”
@property (nonatomic) NSInteger videoid;
@property (nonnull, nonatomic) NSDate *videoDate;
@property (nonatomic) TPVideoType videoType;
@property (nonnull, nonatomic) NSDictionary *videoDict;

- (_Nonnull instancetype)initWithDict:(NSDictionary *_Nonnull)dict;

@end
