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
        self.dislike = @0;
        self.views = [NSKeyedArchiver archivedDataWithRootObject:note.views];
        self.videoDict = [TPVideoManager fetchVideoWithID:note.videoid].dict;
    }
    return self;
}

- (instancetype)initWithAVObject:(AVObject *)object{
    self = [super init];
    if(self) {
        self.title = (NSString *)[object objectForKey:@"title"];
        self.like = (NSNumber *)[object objectForKey:@"like"];
        self.dislike = (NSNumber *)[object objectForKey:@"dislike"];
        self.noteServerID = object.objectId;
        AVFile *viewsFile = (AVFile *)[object objectForKey:@"views"];
        self.views = [viewsFile getData];
        self.videoDict = (NSDictionary *)[object objectForKey:@"videoDict"];
    }
    return self;
}


@end
