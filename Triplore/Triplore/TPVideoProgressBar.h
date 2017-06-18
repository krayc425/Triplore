//
//  TPVideoProgressBar.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPVideoProgressDelegate <NSObject>

/**
 设置播放器播放到几秒

 @param time 几秒
 */
- (void)setToTime:(double)time;

@end

@interface TPVideoProgressBar : UIControl

@property (nonatomic, weak, nullable) id<TPVideoProgressDelegate> delegate;
@property (nonatomic, weak) IBOutlet UISlider * _Nullable slider;

/**
 设置当前播放时间

 @param seconds 几秒
 */
- (void)setCurrentTimeWithSeconds:(double)seconds;

/**
 设置总时间

 @param seconds 几秒
 */
- (void)setEndTimeWithSeconds:(double)seconds;

@end
