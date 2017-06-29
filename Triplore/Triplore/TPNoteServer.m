//
//  TPNoteServer.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteServer.h"
#import "TPNote.h"
#import "TPVideoManager.h"
#import "TPVideo.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation TPNoteServer

- (instancetype)initWithTPNote:(TPNote *)note{
    self = [super init];
    if(self) {
        self.title = note.title;
        self.like = @0;
        self.views = [NSKeyedArchiver archivedDataWithRootObject:note.views];
        self.videoDict = [TPVideoManager fetchVideoWithID:note.videoid].dict;
    }
    return self;
}

- (instancetype)initWithAVObject:(AVObject *)object{
    self = [super init];
    if(self) {
        self.views = [[AVFile fileWithURL:[object objectForKey:@"views"]] getData];
        self.title = (NSString *)[object objectForKey:@"title"];
        self.like = (NSNumber *)[object objectForKey:@"like"];
        self.noteServerID = object.objectId;
        self.videoDict = (NSDictionary *)[object objectForKey:@"videoDict"];
    }
    return self;
}

@end
