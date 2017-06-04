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

@class TPVideo;

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
@property (nonatomic) NSInteger playCount;
@property (nonnull, nonatomic) NSString *playCountString;
@property (nonnull, nonatomic) NSDictionary *videoDict;

/**
 若是专辑类型，这个属性记录有几集
 */
@property (nonatomic) NSInteger totalEpisode;

- (_Nonnull instancetype)initWithTPVideo:(TPVideo *_Nonnull)video;

- (_Nonnull instancetype)initWithDict:(NSDictionary *_Nonnull)dict;

@end
