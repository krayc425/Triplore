//
//  TPSiteTableViewCell.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/23.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSiteTableViewCell.h"
#import "Utilities.h"
#import "TPSiteCollectionViewCell.h"


@interface TPSiteTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation TPSiteTableViewCell

static NSString * const reuseIdentifier = @"TPSiteCollectionViewCell";


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.categoryLabel sizeToFit];
    
    [self.categoryLabel setTextColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]];
    [self.allButton setTitleColor:[Utilities getColor] forState:UIControlStateNormal];
    [self.allButton2 setTitleColor:[Utilities getColor] forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"TPSiteCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsAll:(BOOL)isAll {
    _isAll = isAll;
    self.allButtons.hidden = !isAll;
}

- (void)setMode:(TPSiteMode)mode {
    _mode = mode;
    if (mode == TPSiteCountry) {
        self.categoryLabel.text = @"国家";
    } else if (mode == TPSiteCity) {
        self.categoryLabel.text = @"城市";
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sites.count;
}

- (TPSiteCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPSiteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.sites[indexPath.item];
    
    // Configure the cell
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if([self.delegate respondsToSelector:@selector(didSelectSite:withMode:)]) {
        NSLog(@"select %@", self.sites[indexPath.item]);
        [self.delegate didSelectSite:self.sites[indexPath.item] withMode:self.mode];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(self.collectionView.frame) - 20) / 3, (CGRectGetWidth(self.collectionView.frame) - 20) / 2);
}



- (IBAction)allDidTap:(id)sender {

    if([self.delegate respondsToSelector:@selector(didTapAllWithMode:)]) {
        [self.delegate didTapAllWithMode:self.mode];
    }
}

@end
