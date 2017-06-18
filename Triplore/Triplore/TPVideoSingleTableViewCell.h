//
//  TPVideoSingleTableViewCell.h
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPVideoModel;

@protocol FavoriteCellDelegate <NSObject>

- (void)didSelectFavorite:(id _Nonnull)sender;

@end

@interface TPVideoSingleTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<FavoriteCellDelegate> cellDelegate;

@property (nonatomic, nonnull) TPVideoModel *video;

- (void)setFavorite:(BOOL)isFavorite;

@end
