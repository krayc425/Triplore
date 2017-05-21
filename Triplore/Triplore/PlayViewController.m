//
//  PlayViewController.m
//  PlayDemo
//
//  Copyright (c) 2017-present, IQIYI, Inc. All rights reserved.
//


#import "PlayViewController.h"
#import "QYPlayerController.h"
#import "ActivityIndicatorView.h"

#define KIPhone_AVPlayerRect_mwidth 320
#define KIPhone_AVPlayerRect_mheight 180

@interface PlayViewController ()<QYPlayerControllerDelegate>
@property(nonatomic,strong) ActivityIndicatorView *activityWheel;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBasePlayerController];
    [self createBackView];
    [self createCopyRight];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBackView
{
    UIButton *backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"playerBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}
- (void)createCopyRight
{
    UILabel *copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [copyLabel setText:@" Copyright © 2017 爱奇艺 All Rights Reserved"];
    [copyLabel setTextColor:[UIColor lightGrayColor]];
    copyLabel.center = self.view.center;
    copyLabel.font = [UIFont systemFontOfSize:14];
    copyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyLabel];
}
- (void)showPlayView
{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView==nil)
    {
        UIButton *play= [UIButton buttonWithType:UIButtonTypeCustom];
        [play setBackgroundColor:[UIColor blackColor]];
        [play setFrame:CGRectMake(self.view.frame.size.width-40, self.view.frame.size.width/KIPhone_AVPlayerRect_mwidth*KIPhone_AVPlayerRect_mheight-20, 30, 30)];
        [play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        play.layer.masksToBounds=YES;
        play.layer.cornerRadius=15;
        play.alpha = 0.7;
        [play addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [play setTag:100];
        [self.view addSubview:play];
        play.hidden = NO;
        pauseView.hidden = YES;
    }
    else
    {
        playView.hidden = NO;
        pauseView.hidden = YES;
    }
}
- (void)showPauseView
{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(pauseView==nil)
    {
        UIButton *pause= [UIButton buttonWithType:UIButtonTypeCustom];
        [pause setBackgroundColor:[UIColor blackColor]];
        [pause setFrame:CGRectMake(self.view.frame.size.width-40, self.view.frame.size.width/KIPhone_AVPlayerRect_mwidth*KIPhone_AVPlayerRect_mheight-20, 30, 30)];
        [pause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        pause.layer.masksToBounds=YES;
        pause.layer.cornerRadius=15;
        pause.alpha = 0.7;
        [pause addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
        [pause setTag:200];
        [self.view addSubview:pause];
        pause.hidden = NO;
        playView.hidden = YES;
    }
    else
    {
        pauseView.hidden = NO;
        playView.hidden = YES;
    }
}
- (void)enablePlayPauseView
{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView!=nil)
    {
        playView.userInteractionEnabled = YES;
    }
    if(pauseView!=nil)
    {
        playView.userInteractionEnabled = YES;
    }
}
- (void)unablePlayPauseView
{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView!=nil)
    {
        playView.userInteractionEnabled = NO;
    }
    if(pauseView!=nil)
    {
        playView.userInteractionEnabled = NO;
    }
}
- (void)backClick
{
    [[QYPlayerController sharedInstance] stopPlayer];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)createBasePlayerController
{
    CGRect playFrame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width/KIPhone_AVPlayerRect_mwidth*KIPhone_AVPlayerRect_mheight);
    [QYPlayerController sharedInstance].delegate = self;
    [[QYPlayerController sharedInstance] setPlayerFrame:playFrame];
    [self.view addSubview:[QYPlayerController sharedInstance].view];
    
    ActivityIndicatorView *wheel = [[ActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 15, 15)];
    wheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityWheel = wheel;
    self.activityWheel.center = [QYPlayerController sharedInstance].view.center;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString* aid = [self.playDetail valueForKey:@"a_id"];
    NSString* tvid = [self.playDetail valueForKey:@"tv_id"];
    NSString* isvip = [self.playDetail valueForKey:@"is_vip"];
    [[QYPlayerController sharedInstance] openPlayerByAlbumId:aid tvId:tvid isVip:isvip];
}

-(void)playClick
{
    [[QYPlayerController sharedInstance] play];
    [self showPauseView];
}

-(void)pauseClick
{
    if ([QYPlayerController sharedInstance].isPlaying==YES) {
        [[QYPlayerController sharedInstance] pause];
        [self showPlayView];
    }
}

#pragma QYBasePlayerControllerDelegate
/*
 * 播放出错
 */
-(void)onPlayerError:(NSDictionary *)error_no
{
    [self.activityWheel stopAnimating];
    [self.activityWheel removeFromSuperview];
}

/*
 * 显示加载loading
 */
-(void)startLoading:(QYPlayerController *)player
{
    if (self.activityWheel.superview==nil) {
        [self.view addSubview:self.activityWheel];
        [self.activityWheel startAnimating];
    }
    [self unablePlayPauseView];
}

/*
 * 关闭加载loading
 */
-(void)stopLoading:(QYPlayerController *)player
{
    [self.activityWheel stopAnimating];
    [self.activityWheel removeFromSuperview];
    [self enablePlayPauseView];
}
/**
 **功能: 开始播放广告
 *
 */
- (void)onAdStartPlay:(QYPlayerController *)player
{
    [self showPauseView];
}

/**
 **功能: 开始播放正片
 *
 */
- (void)onContentStartPlay:(QYPlayerController *)player
{
    [self showPauseView];
}

/*
 * 播放时长发生变化
 */
-(void)playbackTimeChanged:(QYPlayerController *)player
{

}

/*
 * 播放完成
 */
-(void)playbackFinshed:(QYPlayerController *)player
{

}

/*
 * 网络变化
 */
- (void)playerNetworkChanged:(QYPlayerController *)player
{

}



@end
