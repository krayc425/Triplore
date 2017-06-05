//
//  TPPlayViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@class TPNote;

@interface TPPlayViewController : UIViewController

@property (nonatomic) TPNoteMode noteMode;

@property (nonnull, nonatomic) TPNote *note;
@property (nonnull, nonatomic) NSString *noteTitle;
@property (nonnull, nonatomic) NSDictionary *videoDict;
@property (nonnull, nonatomic) NSMutableArray<UIView *> *noteViews;

@end
