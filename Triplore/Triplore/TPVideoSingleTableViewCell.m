//
//  TPVideoSingleTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoSingleTableViewCell.h"
#import "TPVideoModel.h"
#import "UIImage+URL.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TPVideoManager.h"

@interface TPVideoSingleTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TPVideoSingleTableViewCell

static NSInteger const width = 220;
static NSInteger const height = 124;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.coverImageView.image = [UIImage imageNamed:@"TEST_PNG"];
}

- (void)setVideo:(TPVideoModel *)video {
    _video = video;
    
    NSString *url = [video.imgURL stringByReplacingOccurrencesOfString:@".jpg" withString:[NSString stringWithFormat:@"_%d_%d.jpg", width, height]];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];

    self.titleLabel.text = video.shortTitle;
    self.timesLabel.text = [NSString stringWithFormat:@"%d", video.playCount];
  
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSLog(@"%f", [video.videoDate timeIntervalSince1970]);
    if([video.videoDate timeIntervalSince1970] == 0){
        self.dateLabel.text = @"无日期";
    }else{
        self.dateLabel.text = [dateFormatter stringFromDate:video.videoDate];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favoriteAction:(id)sender{
    NSLog(@"Favorite in Cell");
    [self.cellDelegate didSelectFavorite:self];
}

- (void)setFavorite:(BOOL)isFavorite{
    UIImage *img;
    if(isFavorite){
        img = [UIImage imageNamed:@"ME_COLLECT_FULL"];
    }else{
        img = [UIImage imageNamed:@"ME_COLLECT"];
    }
    [self.favoriteButton setImage:img forState:UIControlStateNormal];
}

@end
