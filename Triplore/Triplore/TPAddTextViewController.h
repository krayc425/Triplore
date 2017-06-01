//
//  TPAddTextViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPAddMode){
    TPAddNote     = 1,
    TPUpdateNote  = 2,
};

@protocol TPAddNoteViewDelegate <NSObject>

@optional
- (void)addNoteView:(UIView *_Nonnull)view;
- (void)updateNoteView:(UIView *_Nonnull)view;

@end

@interface TPAddTextViewController : UIViewController

@property (nonnull, nonatomic) id<TPAddNoteViewDelegate> addNoteViewDelegate;

@property (nonnull, nonatomic) NSString *noteString;
@property (nonatomic) TPAddMode addMode;

@end
