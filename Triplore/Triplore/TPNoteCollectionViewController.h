//
//  TPNoteCollectionViewController.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPNoteCollectionViewController : UICollectionViewController

@property (nonatomic, strong) UINavigationController *parentNavigationController;

- (void)loadNotes;

@end
