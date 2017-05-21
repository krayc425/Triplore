//
//  ActivityIndicatorView.m
//  QiYiVideo
//
//  Copyright (c) 2017-present, IQIYI, Inc. All rights reserved.
//


#import "ActivityIndicatorView.h"
@interface ActivityIndicatorView() {
    int activityType;
    UIImageView* imageView;
    UIView *_circle;
    CAShapeLayer *_circleLayer;
    NSInteger circleCount;
    BOOL _isOdd;
    BOOL _isAnimating;
    UIView *_triangle;
    CAShapeLayer *_triangleLayer;
    __weak id _wself;
}

@end

@implementation ActivityIndicatorView


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [imageView.layer removeAllAnimations];
    [_circleLayer removeAllAnimations];
    [_triangle.layer removeAllAnimations];
    [self stopAnimating];
}

- (void)stopAnimation
{
    _isAnimating = NO;
    _circleLayer.path = nil;
    [_circleLayer removeAllAnimations];
    [_triangle.layer removeAllAnimations];
    _circle.hidden = _triangle.hidden = YES;
}

- (void)doAnimation
{
    if (!_isAnimating) {
        _isAnimating = YES;
        _isOdd = YES;
        [self doAnimation:YES];
    }
}

- (void)continueStatus
{
    if (_isAnimating) {
        _isOdd = YES;
        [self doAnimation:YES];
    }
}

- (void)doAnimation:(BOOL)isOdd
{
    [_circleLayer removeAllAnimations];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_circleLayer.bounds.size.width / 2, _circleLayer.bounds.size.width / 2) radius:_circleLayer.bounds.size.width / 2 startAngle:-M_PI_2 endAngle:(isOdd ? -1 : 1) * 2 * M_PI - M_PI_2 clockwise:!isOdd];
    _circleLayer.path = path.CGPath;
    
    //圆形的动画
    CABasicAnimation *pkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pkAnimation.duration = .6;
    pkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pkAnimation.autoreverses = NO;
    pkAnimation.fromValue = isOdd ? @(1) : @(0);
    pkAnimation.toValue = isOdd ? @(0) : @(1);
    pkAnimation.delegate = _wself;
    pkAnimation.removedOnCompletion = NO;
    pkAnimation.fillMode = kCAFillModeForwards;
    _circle.hidden = NO;
    [_circleLayer addAnimation:pkAnimation forKey:@"circle"];
    
    if (isOdd) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.delegate =
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rotationAnimation.duration = .6;
        rotationAnimation.repeatCount = 1;
        _triangle.hidden = NO;
        [_triangle.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isAnimating) {
                _isOdd = !_isOdd;
                [self doAnimation:_isOdd];
            }
        });
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initImageView];
    }
    return self;
}
- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    self = [super initWithFrame:[self viewRectWithActivityIndicatorStyle:style]];
    if (self) {
        self.activityIndicatorViewStyle = style;
        [self initImageView];
    }
    return self;
}

- (CGRect)viewRectWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    if (style == UIActivityIndicatorViewStyleWhiteLarge) {
        return CGRectMake(0, 0, 40, 40);
    }
    return CGRectMake(0, 0, 40, 40);
}

- (void)initImageView
{
    _wself = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueStatus) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    activityType = -1;
    self.backgroundColor = [UIColor clearColor];
    
    _triangle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30,  30)];
    [self addSubview:_triangle];
    _triangle.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    CGFloat r = _triangle.bounds.size.width / 2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(r / 2, r - r * sin(M_PI / 3))];
    [path addLineToPoint:CGPointMake(2 * r, r)];
    [path addLineToPoint:CGPointMake(r / 2, r + r * sin(M_PI / 3))];
    [path closePath];
    
    _triangleLayer = [[CAShapeLayer alloc] init];
    _triangleLayer.frame = CGRectMake(0, 0, 35, 35);
    _triangleLayer.fillColor = [UIColor colorWithRed:0x0b/255.0 green:0xbe/255.0 blue:0x06/255.0 alpha:1].CGColor;
    _triangleLayer.path = path.CGPath;
    [_triangle.layer addSublayer:_triangleLayer];
    
    _circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  40,  40)];
    [self addSubview:_circle];
    _circle.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    _circleLayer = [[CAShapeLayer alloc] init];
    _circleLayer.frame = _circle.bounds;
    _circleLayer.strokeColor = [UIColor colorWithRed:0x0b/255.0 green:0xbe/255.0 blue:0x06/255.0 alpha:1].CGColor;
    _circleLayer.fillColor = nil;
    _circleLayer.lineWidth = 1;
    [_circle.layer addSublayer:_circleLayer];
    
    _shouldResetFrame = YES;
}

- (void)setIsForVIP:(BOOL)isForVIP
{
    _isForVIP = isForVIP;
    if (isForVIP) {
        _circleLayer.strokeColor = [UIColor colorWithRed:0xd4/255.0 green:0xac/255.0 blue:0x6d/255.0 alpha:1].CGColor;
        _triangleLayer.fillColor = [UIColor colorWithRed:0xd4/255.0 green:0xac/255.0 blue:0x6d/255.0 alpha:1].CGColor;
    }
    else
    {
        _circleLayer.strokeColor = [UIColor colorWithRed:0x0b/255.0 green:0xbe/255.0 blue:0x06/255.0 alpha:1].CGColor;
        _triangleLayer.fillColor = [UIColor colorWithRed:0x0b/255.0 green:0xbe/255.0 blue:0x06/255.0 alpha:1].CGColor;
    }
}

- (void)setColor:(UIColor *)color
{
    if (color) {
        _triangleLayer.fillColor = color.CGColor;
        _circleLayer.strokeColor = color.CGColor;
    }
}

- (void)setImageFrame
{
    _circle.frame = self.bounds;
    [_circle setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    _circleLayer.frame = _circle.bounds;
    _triangle.frame = CGRectMake(0, 0, _circle.frame.size.width / 2, _circle.frame.size.height / 2);
    _triangle.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _triangleLayer.frame = _triangle.bounds;
    
    CGFloat r = _triangle.bounds.size.width / 2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(r / 2, r - r * sin(M_PI / 3))];
    [path addLineToPoint:CGPointMake(2 * r, r)];
    [path addLineToPoint:CGPointMake(r / 2, r + r * sin(M_PI / 3))];
    [path closePath];
    
    _triangleLayer.path = path.CGPath;
    
    if (_isAnimating) {
        [self stopAnimating];
        [self doAnimation];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_shouldResetFrame) {
        [self setImageFrame];
    }   
}

- (void)updateConstraints
{
    
    [_circle setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _circle.center = self.center;
    
    
    [_triangle setFrame:CGRectMake(0, 0, self.frame.size.width-2, self.frame.size.height-2)];
    _triangle.center = self.center;
    
    
    [super updateConstraints];
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    if (activityType != _activityIndicatorViewStyle) {
        [self setImageFrame];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setImageFrame];
}

- (void)startAnimating
{
    [self doAnimation];
}

- (void)stopAnimating
{
    [self stopAnimation];
}

- (BOOL)isAnimating;
{
    return _isAnimating;
}

@end
