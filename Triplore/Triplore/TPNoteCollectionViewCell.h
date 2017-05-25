//
//  TPNoteCollectionViewCell.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPNoteCollectionViewCell : UICollectionViewCell

@property (nonnull, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *contentLabel;

@end
