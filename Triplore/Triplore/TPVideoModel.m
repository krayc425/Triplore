//
//  TPVideoModel.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoModel.h"

static NSString *dateFormatString = @"yyyy-MM-dd";

@implementation TPVideoModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.shortTitle = dict[@"short_title"];
        self.imgURL = [dict[@"img"] stringByAppendingString:@"?sign=iqiyi"];
        self.videoid = [dict[@"id"] integerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatString];
        self.videoDate = [dateFormatter dateFromString:dict[@"date_format"]];
        self.playCount = [dict[@"play_count"] integerValue];
        self.playCountString = dict[@"play_count_text"];
        switch ([dict[@"p_type"] integerValue]) {
            case 1:
                self.videoType = TPVideoNormal;
                break;
            case 2:
            case 3:
            {
                self.videoType = TPVideoAlbum;
                self.totalEpisode = [dict[@"total_num"] integerValue];
            }
                break;
            default:
                self.videoType = TPVideoNormal;
                break;
        }
        self.videoDict = dict;
    }
    return self;
}

@end
