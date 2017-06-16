//
//  TestView.m
//  Triplore
//
//  Created by Sorumi on 17/6/16.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TestView.h"

@interface TestView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, strong) UIImageView *planeView;
@property (nonatomic, strong) UIImageView *cloudView1;
@property (nonatomic, strong) UIImageView *cloudView2;
@property (nonatomic, strong) UIImageView *cloudView3;
@property (nonatomic, strong) UIImageView *cloudView4;
@property (nonatomic, strong) UIImageView *cloudView5;

@end

@implementation TestView


//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame]
//    if (self) {
//        [self prepare]
//    }
//}

static CGFloat WRAPPER_WIDTH = 160;
static CGFloat WRAPPER_HEIGHT = 50;

- (void)prepare
{
    [super prepare];
    
    
    self.mj_h = WRAPPER_HEIGHT;
    
    self.wrapperView = [[UIView alloc] init];
    
    self.planeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PLANE"]];
    self.cloudView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CLOUD"]];
    self.cloudView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CLOUD"]];
    self.cloudView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CLOUD"]];
    self.cloudView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CLOUD"]];
    self.cloudView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CLOUD"]];

    
    [self.wrapperView addSubview:self.cloudView1];
    [self.wrapperView addSubview:self.cloudView2];
    [self.wrapperView addSubview:self.cloudView3];
    [self.wrapperView addSubview:self.cloudView4];
    [self.wrapperView addSubview:self.cloudView5];

    [self.wrapperView addSubview:self.planeView];
    
    [self addSubview:self.wrapperView];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor lightGrayColor];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"加载更多视频";
    [self addSubview:self.label];
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    self.wrapperView.frame = CGRectMake((width-WRAPPER_WIDTH)/2, (height-WRAPPER_HEIGHT)/2, WRAPPER_WIDTH, WRAPPER_HEIGHT);
    self.wrapperView.clipsToBounds = YES;
    
    self.planeView.frame = CGRectMake((WRAPPER_WIDTH-44)/2, (WRAPPER_HEIGHT-24)/2, 44, 24);
    
    
    self.cloudView1.frame = CGRectMake(50, (WRAPPER_HEIGHT-14)/2, 21, 14);
    self.cloudView2.frame = CGRectMake(WRAPPER_WIDTH+30, (WRAPPER_HEIGHT-14)/2, 21, 14);
    self.cloudView3.frame = CGRectMake(100, (height-24)/2+10, 30, 20);
    self.cloudView4.frame = CGRectMake(WRAPPER_WIDTH+30, (height-24)/2+10, 30, 20);
    self.cloudView5.frame = CGRectMake(WRAPPER_WIDTH+30, (height-24)/2, 26, 17);
    
    
    self.label.frame = self.bounds;
    
    [self startAnimating];
}

#pragma mark - Animation

- (void)startAnimating {
    
    CGRect frame = self.planeView.frame;
    frame.origin.y += 10;
    [UIView animateWithDuration: 1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations: ^{
                         self.planeView.frame = frame;
                         self.planeView.transform = CGAffineTransformRotate(self.planeView.transform, M_PI / 60);
                     } completion: ^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration: 4.0
                          delay: 0.0
                        options: 0
                     animations: ^{
                         self.cloudView1.transform = CGAffineTransformTranslate(self.cloudView1.transform, -80, 0);
                     } completion: ^(BOOL finished){
                     }];
    
    [UIView animateWithDuration: 11.0
                          delay: 2.5
                        options: UIViewAnimationOptionRepeat
                     animations: ^{
                         self.cloudView2.transform = CGAffineTransformTranslate(self.cloudView2.transform, -160-60, 0);
                     } completion: ^(BOOL finished){
                         
                     }];
    [UIView animateWithDuration: 6.5
                          delay: 0.0
                        options: 0
                     animations: ^{
                         self.cloudView3.transform = CGAffineTransformTranslate(self.cloudView3.transform, -130, 0);
                     } completion: ^(BOOL finished){
                     }];
    [UIView animateWithDuration: 11.0
                          delay: 5.0
                        options: UIViewAnimationOptionRepeat
                     animations: ^{
                         self.cloudView4.transform = CGAffineTransformTranslate(self.cloudView4.transform, -160-60, 0);
                     } completion: ^(BOOL finished){
                         
                     }];
    [UIView animateWithDuration: 11.0
                          delay: 0
                        options: UIViewAnimationOptionRepeat
                     animations: ^{
                         self.cloudView5.transform = CGAffineTransformTranslate(self.cloudView5.transform, -160-60, 0);
                     } completion: ^(BOOL finished){
                         
                     }];
}

- (void)stopAnimating {
    [self.planeView.layer removeAllAnimations];
    [self.cloudView1.layer removeAllAnimations];
}


@end
