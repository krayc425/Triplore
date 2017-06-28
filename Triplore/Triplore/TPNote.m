//
//  TPNote.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNote.h"
#import "TPNoteServer.h"

static NSString *kNoteID        = @"NoteID";
static NSString *kNoteVideoID   = @"VideoID";
static NSString *kNoteTime      = @"CreateTime";
static NSString *kNoteTitle     = @"Title";
static NSString *kNoteView      = @"View";
static NSString *kNoteTemplate  = @"Template";

@implementation TPNote

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.noteid       forKey:kNoteID];
    [aCoder encodeObject:self.videoid       forKey:kNoteVideoID];
    [aCoder encodeObject:self.createTime    forKey:kNoteTime];
    [aCoder encodeObject:self.title         forKey:kNoteTitle];
    [aCoder encodeObject:self.views         forKey:kNoteView];
    [aCoder encodeInteger:self.templateNum  forKey:kNoteTemplate];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.noteid         = [aDecoder decodeIntegerForKey:kNoteID];
    self.videoid        = [aDecoder decodeObjectForKey:kNoteVideoID];
    self.createTime     = [aDecoder decodeObjectForKey:kNoteTime];
    self.title          = [aDecoder decodeObjectForKey:kNoteTitle];
    self.views          = [aDecoder decodeObjectForKey:kNoteView];
    self.templateNum    = [aDecoder decodeIntegerForKey:kNoteTemplate];
    return self;
}

- (id)initWithTPNoteServer:(TPNoteServer *)noteServer{
    self = [super init];
    if(self) {
        self.title = noteServer.title;
        self.createTime = [NSDate date];
        self.templateNum = 0;
        self.views = [NSKeyedUnarchiver unarchiveObjectWithData:noteServer.views];
        self.videoid = noteServer.videoDict[@"id"];
    }
    return self;
}

@end
