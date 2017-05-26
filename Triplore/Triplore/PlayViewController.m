//
//  PlayViewController.m
//  PlayDemo
//
//  Copyright (c) 2017-present, IQIYI, Inc. All rights reserved.
//


#import "PlayViewController.h"
#import "QYPlayerController.h"
#import "ActivityIndicatorView.h"
#import "Utilities.h"

#define KIPhone_AVPlayerRect_mwidth 320.0
#define KIPhone_AVPlayerRect_mheight 280.0

#define CONTROLLER_BAR_WIDTH 30

@interface PlayViewController ()<QYPlayerControllerDelegate>
@property(nonatomic,strong) ActivityIndicatorView *activityWheel;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utilities getBackgroundColor];

    CGRect playFrame = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width - CONTROLLER_BAR_WIDTH,
                                  self.view.frame.size.height);
    [QYPlayerController sharedInstance].delegate = self;
    [[QYPlayerController sharedInstance] setPlayerFrame:playFrame];
    [self.view addSubview:[QYPlayerController sharedInstance].view];
    
    UIButton *backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 10, 30, 30)];
    UIImage *backImg = [UIImage imageNamed:@"playerBack"];
    [backButton setImage:backImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    ActivityIndicatorView *wheel = [[ActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 15, 15)];
    wheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityWheel = wheel;
    self.activityWheel.center = [QYPlayerController sharedInstance].view.center;
    
//    UITextField *titleText = [[UITextField alloc] initWithFrame:CGRectMake(20,
//                                                                           playFrame.size.height,
//                                                                           self.view.frame.size.width - 78,
//                                                                           64)];
//    titleText.placeholder = @"填写标题";
//    titleText.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0f];
//    titleText.textColor = [UIColor colorWithRed:94.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0];
//    [self.view addSubview:titleText];
//    
//    UIButton *screenshotButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 78,
//                                                                            playFrame.size.height + 20,
//                                                                            24,
//                                                                            24)];
//    [screenshotButton setImage:[UIImage imageNamed:@"NOTE_SCREENSHOT"] forState:UIControlStateNormal];
//    [self.view addSubview:screenshotButton];
//    
//    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 44,
//                                                                      playFrame.size.height + 20,
//                                                                      24,
//                                                                      24)];
//    [saveButton setImage:[UIImage imageNamed:@"NOTE_SAVE"] forState:UIControlStateNormal];
//    [self.view addSubview:saveButton];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString* aid = [self.playDetail valueForKey:@"a_id"];
    NSString* tvid = [self.playDetail valueForKey:@"tv_id"];
    NSString* isvip = [self.playDetail valueForKey:@"is_vip"];
    [[QYPlayerController sharedInstance] openPlayerByAlbumId:aid tvId:tvid isVip:isvip];
}

- (void)showPlayView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView==nil){
        UIButton *play= [UIButton buttonWithType:UIButtonTypeCustom];
        [play setBackgroundColor:[UIColor blackColor]];
        [play setFrame:CGRectMake(10,
                                  CGRectGetHeight(self.view.bounds) - 40,
                                  30,
                                  30)];
        [play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        play.layer.masksToBounds=YES;
        play.layer.cornerRadius=15;
        play.alpha = 0.7;
        [play addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [play setTag:100];
        [self.view addSubview:play];
        play.hidden = NO;
        pauseView.hidden = YES;
    }else{
        playView.hidden = NO;
        pauseView.hidden = YES;
    }
}

- (void)showPauseView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(pauseView==nil){
        UIButton *pause= [UIButton buttonWithType:UIButtonTypeCustom];
        [pause setBackgroundColor:[UIColor blackColor]];
        [pause setFrame:CGRectMake(10,
                                  CGRectGetHeight(self.view.bounds) - 40,
                                  30,
                                  30)];
        [pause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        pause.layer.masksToBounds=YES;
        pause.layer.cornerRadius=15;
        pause.alpha = 0.7;
        [pause addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
        [pause setTag:200];
        [self.view addSubview:pause];
        pause.hidden = NO;
        playView.hidden = YES;
    }else{
        pauseView.hidden = NO;
        playView.hidden = YES;
    }
}

- (void)enablePlayPauseView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView!=nil){
        playView.userInteractionEnabled = YES;
    }
    if(pauseView!=nil){
        playView.userInteractionEnabled = YES;
    }
}

- (void)unablePlayPauseView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView!=nil){
        playView.userInteractionEnabled = NO;
    }
    if(pauseView!=nil){
        playView.userInteractionEnabled = NO;
    }
}

- (void)backClick{
    [[QYPlayerController sharedInstance] stopPlayer];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)playClick{
    [[QYPlayerController sharedInstance] play];
    [self showPauseView];
}

- (void)pauseClick{
    if ([QYPlayerController sharedInstance].isPlaying==YES) {
        [[QYPlayerController sharedInstance] pause];
        [self showPlayView];
    }
}

#pragma QYBasePlayerControllerDelegate
/*
 * 播放出错
 */
- (void)onPlayerError:(NSDictionary *)error_no{
    [self.activityWheel stopAnimating];
    [self.activityWheel removeFromSuperview];
}

/*
 * 显示加载loading
 */
- (void)startLoading:(QYPlayerController *)player{
    if (self.activityWheel.superview==nil) {
        [self.view addSubview:self.activityWheel];
        [self.activityWheel startAnimating];
    }
    [self unablePlayPauseView];
}

/*
 * 关闭加载loading
 */
- (void)stopLoading:(QYPlayerController *)player{
    [self.activityWheel stopAnimating];
    [self.activityWheel removeFromSuperview];
    [self enablePlayPauseView];
}
/**
 **功能: 开始播放广告
 *
 */
- (void)onAdStartPlay:(QYPlayerController *)player{
    [self showPauseView];
}

/**
 **功能: 开始播放正片
 *
 */
- (void)onContentStartPlay:(QYPlayerController *)player{
    [self showPauseView];
}

/*
 * 播放时长发生变化
 */
-(void)playbackTimeChanged:(QYPlayerController *)player{

}

/*
 * 播放完成
 */
-(void)playbackFinshed:(QYPlayerController *)player{

}

/*
 * 网络变化
 */
- (void)playerNetworkChanged:(QYPlayerController *)player{

}

- (BOOL)shouldAutorotate{
    return YES;
}
//支持横竖屏显示

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

@end
