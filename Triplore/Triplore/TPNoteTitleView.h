//
//  TPNoteTitleView.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/15.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TPNoteTitleView : UIView

@property (nonatomic, nonnull) IBOutlet UILabel *dayLabel;
@property (nonatomic, nonnull) IBOutlet UILabel *monthYearLabel;

- (void)setDate:(NSDate * _Nonnull)date;

@end
