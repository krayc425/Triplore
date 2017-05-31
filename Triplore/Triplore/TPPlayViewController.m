//
//  TPPlayViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPlayViewController.h"
#import "QYPlayerController.h"
#import "ActivityIndicatorView.h"
#import "Utilities.h"
#import "TPNoteCreator.h"
#import "TPNoteViewController.h"
#import "TPAddTextViewController.h"
#import <objc/runtime.h>
#import "QYAVPlayerController.h"
#import "PlayerController.h"

#define KIPhone_AVPlayerRect_mwidth 320.0
#define KIPhone_AVPlayerRect_mheight 280.0

#define CONTROLLER_BAR_WIDTH 30

@interface TPPlayViewController () <QYPlayerControllerDelegate, TPAddNoteViewDelegate, PlayerControllerDelegate>{
    CGRect playFrame;
    UIView *playerView;
    QYAVPlayerController *qyplayer;
    PlayerController *pc;
}

@property (nonatomic,strong) ActivityIndicatorView *activityWheel;

@end

@implementation TPPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utilities getBackgroundColor];
    
    self.navigationController.navigationBar.barTintColor = [Utilities getColor];
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"视频";
    
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    //    CGRect playFrame = CGRectMake(0,
    //                                  0,
    //                                  self.view.frame.size.width - CONTROLLER_BAR_WIDTH,
    //                                  self.view.frame.size.height);
    
    playFrame = CGRectMake(0,
                           64,
                           self.view.frame.size.width,
                           320);
    [QYPlayerController sharedInstance].delegate = self;
    [[QYPlayerController sharedInstance] setPlayerFrame:playFrame];
    playerView = [QYPlayerController sharedInstance].view;
    [self.view addSubview:playerView];
    
    
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
    
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 112,
                                                                      playFrame.size.height + 20,
                                                                      24,
                                                                      24)];
    [editButton setImage:[UIImage imageNamed:@"NOTE_EDIT"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editNoteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    UIButton *screenshotButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 78,
                                                                            playFrame.size.height + 20,
                                                                            24,
                                                                            24)];
    [screenshotButton setImage:[UIImage imageNamed:@"NOTE_SCREENSHOT"] forState:UIControlStateNormal];
    [screenshotButton addTarget:self action:@selector(screenShotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:screenshotButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 44,
                                                                      playFrame.size.height + 20,
                                                                      24,
                                                                      24)];
    [saveButton setImage:[UIImage imageNamed:@"NOTE_SAVE"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveNoteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    //    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    //    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
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

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
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
    qyplayer = (QYAVPlayerController *)[[QYPlayerController sharedInstance] valueForKey:@"_qyPlayer"];
    NSLog(@"%f", [qyplayer totalDuration]);
    pc = [qyplayer valueForKey:@"pumaPlayerCtrl"];
//    pc.delegate = self;
    
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

#pragma mark - Button Action

- (void)editNoteAction{
    TPAddTextViewController *textVC = [[TPAddTextViewController alloc] initWithNibName:@"TPAddTextViewController" bundle:[NSBundle mainBundle]];
    textVC.addNoteViewDelegate = self;
    [textVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;//关键语句，必须有
    [self presentViewController:textVC animated:YES completion:nil];
}

- (void)addNoteView:(UIView *_Nonnull)view{
    [[TPNoteCreator shareInstance] addNoteView:view];
    NSLog(@"%lu Views", (long)[[TPNoteCreator shareInstance] countNoteView]);
}

- (void)screenShotAction{
    UIImageView *view = (UIImageView *)[self.view snapshotViewAfterScreenUpdates:YES];
//    UIImage *tmpImg = view.image;
//    tmpImg = [TPPlayViewController imageFromImage:tmpImg inRect:playFrame];
    [view setBounds:playFrame];
    [view setClipsToBounds:YES];
    [self addNoteView:view];
    
//    [pc pause];
//    [qyplayer snapShot];
//    [pc startImageCutWithVideoPath:nil imageSaveDir:nil videoCutResultJson:nil];
//    [pc.delegate OnSnapShot:nil width:100 height:100 format:1];
//    [pc snapShot];
//    [pc showWatermark];
//    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [[UIScreen mainScreen] scale]);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 40, image.size.height)];
////    [imgView1 setBounds:CGRectMake(0, 0, CGRectGetWidth(imgView1.frame) - 40, image.size.height)];
//    [imgView1 setImage:image];
//    [imgView1 setContentMode:UIViewContentModeScaleAspectFit];
//    [self addNoteView:imgView1];
}

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

- (void)saveNoteAction{
    NSLog(@"保存");
    
    NSArray *noteArr = [[TPNoteCreator shareInstance] getNoteViews];
    if(noteArr.count <= 0){
        NSLog(@"没有 View");
        return;
    }
    
    TPNoteViewController *noteVC = [[TPNoteViewController alloc] init];
    [noteVC setVideoDict:self.playDetail];
    [noteVC setNoteViews:[[TPNoteCreator shareInstance] getNoteViews]];
//    [self presentViewController:noteVC animated:YES completion:nil];
    [self.navigationController pushViewController:noteVC animated:YES];
}

//- (void)onIsPlayingStateChanged:(BOOL)arg1{
//    NSLog(@"C : %d", arg1);
//}
//
//- (void)onStart{
//    NSLog(@"start");
//}
//
//- (void)OnSnapShot:(void *)arg1 width:(unsigned int)arg2 height:(unsigned int)arg3 format:(unsigned int)arg4{
//    NSLog(@"%@ %u %u %u",arg1, arg2, arg3, arg4);
//}

@end
    
