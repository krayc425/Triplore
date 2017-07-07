//
//  TPVideoProgressBar.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPVideoProgressBar.h"

@interface TPVideoProgressBar()

@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;

@end

@implementation TPVideoProgressBar{
    double endTime;
    double currentTime;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)sliderValueChanged:(id)sender{
    UISlider *slider = (UISlider *)sender;
//    NSLog(@"Slider value: %f", slider.value);
    [self.delegate setToTime:slider.value];
}

- (void)setEndTimeWithSeconds:(double)seconds{
    endTime = seconds;
    [self.slider setMinimumValue:0.0];
    [self.slider setMaximumValue:endTime];
    [self.endTimeLabel setText:[self timeFormatted:seconds]];
}

- (void)setCurrentTimeWithSeconds:(double)seconds{
    currentTime = seconds;
    [self.slider setValue:currentTime animated:YES];
    [self.currentTimeLabel setText:[self timeFormatted:seconds]];
}

- (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if(hours == 0){
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
}

@end
