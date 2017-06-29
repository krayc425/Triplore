//
//  TPNoteCollectionViewCell+Configure.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCollectionViewCell.h"

@class TPNote;
@class TPNoteServer;

@interface TPNoteCollectionViewCell (Configure)

- (void)configureWithNote:(TPNote *)note;

- (void)configureWithNoteServer:(TPNoteServer *)noteServer;

@end
