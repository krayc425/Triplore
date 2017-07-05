//
//  TPNoteCollectionViewCell.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPNote;
@class TPNoteServer;

typedef NS_ENUM(NSInteger, TPNoteCellMode){
    TPNoteCellLocal     = 1,
    TPNoteCellRemote    = 2,
};


@interface TPNoteCollectionViewCell : UICollectionViewCell

@property (nonatomic) TPNoteCellMode mode;

@property (nonatomic, nonnull) TPNote *note;
@property (nonatomic, nonnull) TPNoteServer *noteServer;

@end
