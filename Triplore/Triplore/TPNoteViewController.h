//
//  TPNoteViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPNote;

@interface TPNoteViewController : UIViewController 

@property (nonnull, nonatomic) TPNote *note;
@property (nonnull, nonatomic) NSString *noteTitle;
@property (nonnull, nonatomic) NSDictionary *videoDict;
@property (nonnull, nonatomic) NSArray<UIView *> *noteViews;

@end
