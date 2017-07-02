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

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface TPVideoSingleTableViewCell (){
    UIView *deleteView;
}

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
    
    //自定义删除 View
    deleteView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth,
                                                          0,
                                                          300,
                                                          CGRectGetHeight(self.frame))];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        90,
                                                                        CGRectGetHeight(deleteView.frame))];
    [deleteButton setImage:[UIImage imageNamed:@"CELL_DELETE"] forState:UIControlStateNormal];
    deleteView.backgroundColor = [UIColor whiteColor];
    [deleteView addSubview:deleteButton];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:deleteView];
}

- (void)setVideo:(TPVideoModel *)video {
    _video = video;
    
    NSString *url = [video.imgURL stringByReplacingOccurrencesOfString:@".jpg" withString:[NSString stringWithFormat:@"_%ld_%ld.jpg", (long)width, (long)height]];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];

    self.titleLabel.text = video.shortTitle;
    self.timesLabel.text = [NSString stringWithFormat:@"%ld", (long)video.playCount];
  
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
}

- (IBAction)favoriteAction:(id)sender{
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
