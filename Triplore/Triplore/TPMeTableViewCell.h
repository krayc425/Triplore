//
//  TPMeTableViewCell.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPMeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *cellImg;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@end
