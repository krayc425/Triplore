//
//  TPAddTextViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPAddNoteViewDelegate <NSObject>

- (void)addNoteView:(UIView *_Nonnull)view;

@end

@interface TPAddTextViewController : UIViewController

@property (nonnull, nonatomic) id<TPAddNoteViewDelegate> addNoteViewDelegate;

@end
