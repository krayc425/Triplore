//
//  TPVideoSeriesTableViewCell.m
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoSeriesTableViewCell.h"
#import "TPVideoEpisodeTableViewCell.h"
#import "TPVideoModel.h"
#import "UIImage+URL.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TPVideoSeriesTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *episodeButton;

@end

@implementation TPVideoSeriesTableViewCell

static NSInteger const width = 220;
static NSInteger const height = 124;

static NSString *cellIdentifier = @"TPVideoEpisodeTableViewCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.coverImageView.image = [UIImage imageNamed:@"TEST_PNG"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // cell
    UINib *nib = [UINib nibWithNibName:@"TPVideoEpisodeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];

}


- (void)setVideo:(TPVideoModel *)video {
    
    NSString *url = [video.imgURL stringByReplacingOccurrencesOfString:@".jpg" withString:[NSString stringWithFormat:@"_%d_%d.jpg", width, height]];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    self.titleLabel.text = video.shortTitle;    
    self.timesLabel.text = [NSString stringWithFormat:@"播放%d次", video.playCount];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    self.dateLabel.text = [dateFormatter stringFromDate:video.videoDate];
    
//     self.episodeButton.titleLabel.text = [NSString stringWithFormat:@"全部 %d 集", video.];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    TPVideoEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
    return cell;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
