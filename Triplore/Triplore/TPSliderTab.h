//
//  TPSliderTab.h
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPSliderTabDelegate <NSObject>

@optional

- (void)indexDidSelect:(NSUInteger)selectedIndex;

@end

@interface TPSliderTab : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray *strings;
@property (nonatomic) NSUInteger selectedIndex;
//@property (nonatomic, copy) void (^buttonDidSelect)(NSUInteger index);

@property (nonatomic, nonnull) id<TPSliderTabDelegate> delegate;

- (void)setUp;

@end
