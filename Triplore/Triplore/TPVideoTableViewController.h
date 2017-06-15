//
//  TPVideoTableViewController.h
//  Triplore
//
//  Created by Sorumi on 17/6/2.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPVideoSingleTableViewCell.h"

@interface TPVideoTableViewController : UITableViewController <FavoriteCellDelegate>

@property (nonatomic, nonnull) NSString *site;
@property (nonatomic, nonnull) NSString *keywords;

@end
