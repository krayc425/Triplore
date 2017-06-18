//
//  TPCityVideoTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPCityVideoTableViewCell.h"
#import "TPVideoCollectionViewCell.h"
#import "TPVideoModel.h"

@interface TPCityVideoTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation TPCityVideoTableViewCell

static NSString * const reuseIdentifier = @"TPVideoCollectionViewCell";


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"TPVideoCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

- (void)setMode:(TPCategoryMode)mode {
    _mode = mode;
    switch (self.mode) {
        case TPCategoryFood:
            self.categoryLabel.text = @"美食";
            break;
        case TPCategoryShopping:
            self.categoryLabel.text = @"购物";
            break;
        case TPCategoryPlace:
            self.categoryLabel.text = @"景点";
            break;
    }
}

- (void)setVideos:(NSArray *)videos {
    _videos = videos;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.video = self.videos[indexPath.row];
    
//    cell.titleLabel.text = self.sites[indexPath.item];
    
    // Configure the cell
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(didSelectVideo:)]) {
        [self.delegate didSelectVideo:self.videos[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(self.collectionView.frame) - 10) / 2,
                      (CGRectGetWidth(self.collectionView.frame) - 10) / 2 / 16 * 9 + 55);
}

- (IBAction)allDidTap:(id)sender {

    if([self.delegate respondsToSelector:@selector(didTapAllWithMode:)]) {
        [self.delegate didTapAllWithMode:self.mode];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
