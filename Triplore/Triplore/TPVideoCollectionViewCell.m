//
//  TPVideoCollectionViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoCollectionViewCell.h"
#import "TPVideoModel.h"
#import "UIImage+URL.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TPVideoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@end

@implementation TPVideoCollectionViewCell

static NSInteger const width = 220;
static NSInteger const height = 124;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.coverImageView.image = [UIImage imageNamed:@"TEST_PNG"];
    
}

- (void)setVideo:(TPVideoModel *)video {
    
    NSString *url = [video.imgURL stringByReplacingOccurrencesOfString:@".jpg" withString:[NSString stringWithFormat:@"_%d_%d.jpg", width, height]];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    self.titleLabel.text = video.shortTitle;
    self.timesLabel.text = [NSString stringWithFormat:@"播放%d次", video.playCount];
}

@end
