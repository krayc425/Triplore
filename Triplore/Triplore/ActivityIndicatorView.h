//
//  ActivityIndicatorView.h
//  QiYiVideo
//
//  Copyright (c) 2017-present, IQIYI, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView {
    
}
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property(nonatomic) BOOL                         hidesWhenStopped;
@property (nonatomic, assign) BOOL isForVIP;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL shouldResetFrame;

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
- (void)setIsForVIP:(BOOL)isForVIP;
@end
