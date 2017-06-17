//
//  TPNoteViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@class TPNote;

@interface TPNoteViewController : UIViewController 

@property (nonatomic) TPNoteMode noteMode;

@property (nonnull, nonatomic) TPNote *note;
@property (nonnull, nonatomic) NSDictionary *videoDict;

@end
