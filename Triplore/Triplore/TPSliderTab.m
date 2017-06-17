//
//  TPSliderTab.m
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSliderTab.h"


@interface TPSliderTab ()

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *slider;

@end


@implementation TPSliderTab
static const CGFloat fontSize = 14.0;
static const CGFloat sliderHeight = 2.0;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setStrings:(NSArray *)strings {
    _strings = strings;
    [self setUp];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setUp];
}

- (void)setUp {
    if (!_strings || _strings.count == 0) {
        return;
    }
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSUInteger count = _strings.count;
    CGFloat width = self.frame.size.width / count;
    CGFloat height = self.frame.size.height;
    CGFloat x = 0.0;
    
    for (NSString *string in _strings) {
        CGRect frame = CGRectMake(x, 0, width, height);
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:_color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.alpha = 0.5;
        
        [button addTarget:self action:@selector(buttonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
        [self addSubview:button];
        x += width;
    }
    _buttons = buttons;
    
    _slider = [[UIView alloc] initWithFrame:CGRectMake(0, height-sliderHeight, width, sliderHeight)];
    _slider.backgroundColor = _color;
    [self addSubview:_slider];
    
    self.selectedIndex = 0;
}

- (void)buttonDidTap:(UIButton *)sender {
    NSUInteger index = [_buttons indexOfObject:sender];
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    //    if (selectedIndex == _selectedIndex) {
    //        return;
    //    }
    UIButton *oldButton = _buttons[_selectedIndex];
    UIButton *newButton = _buttons[selectedIndex];
    
    _selectedIndex = selectedIndex;
    
    CGSize size = [_strings[selectedIndex] sizeWithAttributes:@{
                                                                NSFontAttributeName: [UIFont systemFontOfSize:fontSize]
                                                                }];
    CGFloat width = self.frame.size.width / _strings.count;
    CGFloat height = self.frame.size.height;
    CGFloat textWidth = size.width;
    
    CGRect frame = CGRectMake(width*selectedIndex+(width-textWidth)/2, height-sliderHeight, textWidth, sliderHeight);
    
    [UIView animateWithDuration:.3
                     animations:^{
                         _slider.frame = frame;
                         oldButton.alpha = 0.5;
                         newButton.alpha = 1;
                     }];
    
    if ([self.delegate respondsToSelector:@selector(indexDidSelect:)]) {
        [self.delegate indexDidSelect:selectedIndex];
    }
}

@end
